using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using OfficeOrderApi.Data;
using OfficeOrderApi.Models;
using OfficeOrderApi.DTOs;

namespace OfficeOrderApi.Services
{
    /// <summary>
    /// 訂單管理服務
    /// </summary>
    public class OrderService
    {
        private readonly AppDbContext _context;
        private readonly ILogger<OrderService> _logger;

        public OrderService(AppDbContext context, ILogger<OrderService> logger)
        {
            _context = context;
            _logger = logger;
        }

        /// <summary>
        /// 下訂單
        /// </summary>
        public async Task<OrderItemDto> PlaceOrderAsync(int eventId, PlaceOrderRequestDto request, int userId)
        {
            var strategy = _context.Database.CreateExecutionStrategy();
            
            return await strategy.ExecuteAsync(async () =>
            {
                using (var transaction = await _context.Database.BeginTransactionAsync())
                {
                    try
                    {
                        _logger.LogInformation("用戶 {UserId} 在活動 {EventId} 下訂單", userId, eventId);

                        // 檢查活動是否存在且進行中
                        var eventEntity = await _context.Events.FindAsync(eventId);
                        if (eventEntity == null)
                        {
                            throw new KeyNotFoundException($"活動不存在：EventId={eventId}");
                        }

                        if (eventEntity.Status != "進行中")
                        {
                            throw new InvalidOperationException("活動已結束，無法下訂單");
                        }

                        if (DateTime.Now > eventEntity.Deadline)
                        {
                            throw new InvalidOperationException("已超過訂購截止時間");
                        }

                        // 取得訂單群組
                        var orderGroup = await _context.OrderGroups
                            .FirstOrDefaultAsync(og => og.EventId == eventId && og.StoreId == request.StoreId);

                        if (orderGroup == null)
                        {
                            throw new InvalidOperationException("此店家未參與本次活動");
                        }

                        // 取得菜單項目
                        var menuItem = await _context.MenuItems
                            .FirstOrDefaultAsync(m => m.ItemId == request.MenuItemId && m.StoreId == request.StoreId);

                        if (menuItem == null)
                        {
                            throw new KeyNotFoundException("菜單項目不存在");
                        }

                        if (!menuItem.IsAvailable)
                        {
                            throw new InvalidOperationException("此商品目前無法訂購");
                        }

                        // 計算價格
                        var pricing = CalculatePrice(menuItem, request);

                        // 將 Sweetness 和 Temperature 合併成 CustomOptions JSON
                        string? customOptions = null;
                        if (!string.IsNullOrEmpty(request.Sweetness) || !string.IsNullOrEmpty(request.Temperature))
                        {
                            var options = new Dictionary<string, string>();
                            if (!string.IsNullOrEmpty(request.Sweetness)) options["sweetness"] = request.Sweetness;
                            if (!string.IsNullOrEmpty(request.Temperature)) options["temperature"] = request.Temperature;
                            customOptions = JsonSerializer.Serialize(options, new JsonSerializerOptions 
                            { 
                                Encoder = System.Text.Encodings.Web.JavaScriptEncoder.UnsafeRelaxedJsonEscaping 
                            });
                        }

                        // 建立訂單項目
                        var orderItem = new OrderItem
                        {
                            GroupId = orderGroup.GroupId,
                            UserId = userId,
                            ItemId = menuItem.ItemId,
                            Quantity = request.Quantity,
                            SizeCode = request.Size ?? string.Empty,
                            SizeName = request.Size ?? string.Empty,
                            CustomOptions = customOptions,
                            Toppings = request.Toppings != null && request.Toppings.Any()
                                ? JsonSerializer.Serialize(request.Toppings, new JsonSerializerOptions 
                                { 
                                    Encoder = System.Text.Encodings.Web.JavaScriptEncoder.UnsafeRelaxedJsonEscaping 
                                })
                                : null,
                            BasePrice = pricing.BasePrice,
                            ToppingPrice = pricing.ToppingPrice,
                            UnitPrice = pricing.UnitPrice,
                            SubTotal = pricing.SubTotal,
                            Note = request.Remarks,
                            CreatedAt = DateTime.Now
                        };

                        _context.OrderItems.Add(orderItem);

                        await _context.SaveChangesAsync();
                        await transaction.CommitAsync();

                        _logger.LogInformation("訂單建立成功：OrderItemId={OrderItemId}, 金額={SubTotal}", 
                            orderItem.OrderItemId, orderItem.SubTotal);

                        // 載入關聯資料
                        await _context.Entry(orderItem).Reference(o => o.User).LoadAsync();
                        await _context.Entry(orderItem).Reference(o => o.MenuItem).LoadAsync();

                        return MapToOrderItemDto(orderItem);
                    }
                    catch (Exception ex)
                    {
                        await transaction.RollbackAsync();
                        _logger.LogError(ex, "下訂單失敗：EventId={EventId}, UserId={UserId}", eventId, userId);
                        throw;
                    }
                }
            });
        }

        /// <summary>
        /// 取得用戶在特定活動的所有訂單
        /// </summary>
        public async Task<List<OrderItemDto>> GetUserOrdersInEventAsync(int eventId, int userId)
        {
            try
            {
                var orders = await _context.OrderItems
                    .Include(o => o.User)
                    .Include(o => o.MenuItem)
                    .Include(o => o.OrderGroup)
                    .Where(o => o.OrderGroup.EventId == eventId && o.UserId == userId)
                    .OrderBy(o => o.CreatedAt)
                    .ToListAsync();

                return orders.Select(o => MapToOrderItemDto(o)).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得用戶訂單失敗：EventId={EventId}, UserId={UserId}", eventId, userId);
                throw;
            }
        }

        /// <summary>
        /// 取得用戶所有歷史訂單（管理員可查看所有用戶）
        /// </summary>
        public async Task<List<OrderHistoryDto>> GetUserOrderHistoryAsync(int? userId = null, int pageSize = 50, int page = 1)
        {
            try
            {
                var query = _context.OrderItems
                    .Include(o => o.User)
                    .Include(o => o.MenuItem)
                    .ThenInclude(m => m.Store)
                    .Include(o => o.OrderGroup)
                    .ThenInclude(og => og.Event)
                    .AsQueryable();

                // 如果指定了 userId，則只查詢該用戶的訂單；否則查詢所有訂單（管理員）
                if (userId.HasValue)
                {
                    query = query.Where(o => o.UserId == userId.Value);
                }

                var orders = await query
                    .OrderByDescending(o => o.CreatedAt)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToListAsync();

                var now = DateTime.Now;

                return orders.Select(o => 
                {
                    // 動態判斷揪團狀態
                    var eventStatus = o.OrderGroup.Event.Status;
                    if (eventStatus == "Open")
                    {
                        // 檢查是否已過截止時間
                        var isPastDeadline = o.OrderGroup.Deadline <= now;
                        if (isPastDeadline)
                        {
                            eventStatus = "已截止";
                        }
                    }
                    else if (eventStatus == "Closed")
                    {
                        eventStatus = "已結束";
                    }

                    return new OrderHistoryDto
                    {
                        OrderItemId = o.OrderItemId,
                        EventId = o.OrderGroup.EventId,
                        EventTitle = o.OrderGroup.Event.Title,
                        StoreName = o.MenuItem.Store?.Name ?? "未知店家",
                        ItemName = o.MenuItem.Name,
                        Quantity = o.Quantity,
                        Size = o.SizeName,
                        Sweetness = ExtractCustomOption(o.CustomOptions, "sweetness"),
                        Temperature = ExtractCustomOption(o.CustomOptions, "temperature"),
                        Toppings = o.Toppings,
                        UnitPrice = o.UnitPrice,
                        SubTotal = o.SubTotal,
                        Remarks = o.Note,
                        OrderDate = o.CreatedAt,
                        EventStatus = eventStatus
                    };
                }).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得用戶歷史訂單失敗：UserId={UserId}", userId);
                throw;
            }
        }

        /// <summary>
        /// 從 CustomOptions JSON 提取特定選項
        /// </summary>
        private static string? ExtractCustomOption(string? customOptions, string key)
        {
            if (string.IsNullOrEmpty(customOptions)) return null;
            
            try
            {
                var options = JsonSerializer.Deserialize<Dictionary<string, string>>(customOptions);
                return options?.ContainsKey(key) == true ? options[key] : null;
            }
            catch
            {
                return null;
            }
        }

        /// <summary>
        /// 計算訂單價格
        /// </summary>
        private PricingResult CalculatePrice(MenuItem menuItem, PlaceOrderRequestDto request)
        {
            decimal basePrice = 0;

            // 從 PriceRules 取得基礎價格（尺寸）
            if (!string.IsNullOrEmpty(menuItem.PriceRules))
            {
                try
                {
                    var priceRules = JsonSerializer.Deserialize<Dictionary<string, decimal>>(menuItem.PriceRules);
                    if (priceRules != null && priceRules.Count > 0)
                    {
                        // 如果有指定尺寸，使用該尺寸價格；否則使用第一個價格
                        if (!string.IsNullOrEmpty(request.Size) && priceRules.ContainsKey(request.Size))
                        {
                            basePrice = priceRules[request.Size];
                        }
                        else
                        {
                            basePrice = priceRules.Values.First();
                        }
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogWarning(ex, "解析 PriceRules 失敗：MenuItemId={MenuItemId}", menuItem.ItemId);
                }
            }

            // 計算加料費用
            decimal toppingPrice = 0;
            if (request.Toppings != null && request.Toppings.Any() && !string.IsNullOrEmpty(menuItem.Options))
            {
                try
                {
                    var options = JsonSerializer.Deserialize<MenuOptions>(menuItem.Options);
                    if (options?.toppings != null)
                    {
                        foreach (var topping in request.Toppings)
                        {
                            var toppingOption = options.toppings.FirstOrDefault(t => t.name == topping);
                            if (toppingOption != null)
                            {
                                toppingPrice += toppingOption.price;
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogWarning(ex, "解析 Options 失敗：MenuItemId={MenuItemId}", menuItem.ItemId);
                }
            }

            decimal unitPrice = basePrice + toppingPrice;
            decimal subTotal = unitPrice * request.Quantity;

            return new PricingResult
            {
                BasePrice = basePrice,
                ToppingPrice = toppingPrice,
                UnitPrice = unitPrice,
                SubTotal = subTotal
            };
        }

        /// <summary>
        /// 映射至 OrderItemDto
        /// </summary>
        private static OrderItemDto MapToOrderItemDto(OrderItem order)
        {
            // 從CustomOptions JSON 解析出 Sweetness 和 Temperature
            string? sweetness = null;
            string? temperature = null;
            if (!string.IsNullOrEmpty(order.CustomOptions))
            {
                try
                {
                    var options = JsonSerializer.Deserialize<Dictionary<string, string>>(order.CustomOptions);
                    if (options != null)
                    {
                        options.TryGetValue("sweetness", out sweetness);
                        options.TryGetValue("temperature", out temperature);
                    }
                }
                catch { }
            }

            return new OrderItemDto
            {
                OrderItemId = order.OrderItemId,
                UserId = order.UserId,
                UserName = order.User?.Name ?? "未知",
                MenuItemId = order.ItemId,
                ItemName = order.MenuItem?.Name ?? "未知",
                Quantity = order.Quantity,
                Size = order.SizeName,
                Sweetness = sweetness,
                Temperature = temperature,
                Toppings = order.Toppings,
                BasePrice = order.BasePrice,
                ToppingPrice = order.ToppingPrice,
                UnitPrice = order.UnitPrice,
                SubTotal = order.SubTotal,
                Remarks = order.Note,
                CreatedAt = order.CreatedAt
            };
        }

        /// <summary>
        /// 價格計算結果
        /// </summary>
        private class PricingResult
        {
            public decimal BasePrice { get; set; }
            public decimal ToppingPrice { get; set; }
            public decimal UnitPrice { get; set; }
            public decimal SubTotal { get; set; }
        }

        /// <summary>
        /// 菜單選項模型（用於 JSON 反序列化）
        /// </summary>
        private class MenuOptions
        {
            public List<string>? sweetness { get; set; }
            public List<string>? temperature { get; set; }
            public List<ToppingOption>? toppings { get; set; }
        }

        private class ToppingOption
        {
            public string name { get; set; } = string.Empty;
            public decimal price { get; set; }
        }

        /// <summary>
        /// 批量提交訂單（前端統一使用此API）
        /// </summary>
        public async Task<List<OrderItemDto>> SubmitBatchOrderAsync(int eventId, SubmitBatchOrderRequestDto request, int userId)
        {
            var strategy = _context.Database.CreateExecutionStrategy();
            
            return await strategy.ExecuteAsync(async () =>
            {
                using (var transaction = await _context.Database.BeginTransactionAsync())
                {
                    try
                    {
                        _logger.LogInformation("用戶 {UserId} 在活動 {EventId} 提交批量訂單", userId, eventId);

                        // 檢查活動是否存在且進行中
                        var eventEntity = await _context.Events.FindAsync(eventId);
                        if (eventEntity == null)
                        {
                            throw new KeyNotFoundException($"活動不存在：EventId={eventId}");
                        }

                        if (eventEntity.Status != "Open")
                        {
                            throw new InvalidOperationException("活動已結束，無法下訂單");
                        }

                        // 取得訂單群組
                        var orderGroup = await _context.OrderGroups
                            .Include(og => og.Store)
                            .FirstOrDefaultAsync(og => og.GroupId == request.GroupId && og.EventId == eventId);

                        if (orderGroup == null)
                        {
                            throw new KeyNotFoundException($"訂單群組不存在：GroupId={request.GroupId}");
                        }

                        // 檢查截止時間
                        if (DateTime.Now > orderGroup.Deadline)
                        {
                            throw new InvalidOperationException($"店家 {orderGroup.Store?.Name ?? "未知"} 已超過訂購截止時間");
                        }

                        var createdOrders = new List<OrderItemDto>();

                        // 處理每個訂單項目
                        foreach (var itemDto in request.Items)
                        {
                            // 取得菜單項目
                            var menuItem = await _context.MenuItems
                            .FirstOrDefaultAsync(m => m.ItemId == itemDto.ItemId && m.StoreId == orderGroup.StoreId);

                        if (menuItem == null)
                        {
                            throw new KeyNotFoundException($"菜單項目不存在：ItemId={itemDto.ItemId}");
                        }

                        if (!menuItem.IsAvailable)
                        {
                            throw new InvalidOperationException($"商品 {menuItem.Name} 目前無法訂購");
                        }

                        // 計算價格
                        decimal basePrice = CalculatePriceBySize(menuItem, itemDto.SizeCode);
                        decimal toppingPrice = CalculateToppingPrice(menuItem, itemDto.Toppings);
                        decimal unitPrice = basePrice + toppingPrice;
                        decimal subTotal = unitPrice * itemDto.Quantity;

                        // 序列化 Toppings
                        string? toppingsJson = null;
                        if (itemDto.Toppings != null && itemDto.Toppings.Any())
                        {
                            toppingsJson = JsonSerializer.Serialize(itemDto.Toppings, new JsonSerializerOptions 
                            { 
                                Encoder = System.Text.Encodings.Web.JavaScriptEncoder.UnsafeRelaxedJsonEscaping 
                            });
                        }

                        // 建立訂單項目
                        var orderItem = new OrderItem
                        {
                            GroupId = orderGroup.GroupId,
                            UserId = userId,
                            ItemId = menuItem.ItemId,
                            Quantity = itemDto.Quantity,
                            SizeCode = itemDto.SizeCode,
                            SizeName = itemDto.SizeCode,
                            CustomOptions = itemDto.CustomOptions,
                            Toppings = toppingsJson,
                            BasePrice = basePrice,
                            ToppingPrice = toppingPrice,
                            UnitPrice = unitPrice,
                            SubTotal = subTotal,
                            Note = itemDto.Note,
                            CreatedAt = DateTime.Now
                        };

                        _context.OrderItems.Add(orderItem);
                        await _context.SaveChangesAsync();

                            // 載入關聯資料
                            await _context.Entry(orderItem).Reference(o => o.User).LoadAsync();
                            await _context.Entry(orderItem).Reference(o => o.MenuItem).LoadAsync();

                            createdOrders.Add(MapToOrderItemDto(orderItem));
                        }

                        await transaction.CommitAsync();

                        _logger.LogInformation("批量訂單建立成功：EventId={EventId}, 品項數={Count}", eventId, createdOrders.Count);

                        return createdOrders;
                    }
                    catch (Exception ex)
                    {
                        await transaction.RollbackAsync();
                        _logger.LogError(ex, "批量訂單失敗：EventId={EventId}, UserId={UserId}", eventId, userId);
                        throw;
                    }
                }
            });
        }

        /// <summary>
        /// 根據尺寸計算基礎價格
        /// </summary>
        private decimal CalculatePriceBySize(MenuItem menuItem, string sizeCode)
        {
            if (string.IsNullOrEmpty(menuItem.PriceRules))
            {
                return 0;
            }

            try
            {
                var priceDict = JsonSerializer.Deserialize<Dictionary<string, decimal>>(menuItem.PriceRules);
                if (priceDict != null && priceDict.ContainsKey(sizeCode))
                {
                    return priceDict[sizeCode];
                }
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "解析 PriceRules 失敗：MenuItemId={MenuItemId}", menuItem.ItemId);
            }

            return 0;
        }

        /// <summary>
        /// 計算加料價格
        /// </summary>
        private decimal CalculateToppingPrice(MenuItem menuItem, List<string>? toppings)
        {
            if (toppings == null || !toppings.Any() || string.IsNullOrEmpty(menuItem.Options))
            {
                return 0;
            }

            decimal total = 0;

            try
            {
                var options = JsonSerializer.Deserialize<MenuOptions>(menuItem.Options);
                if (options?.toppings != null)
                {
                    foreach (var topping in toppings)
                    {
                        var toppingOption = options.toppings.FirstOrDefault(t => t.name == topping);
                        if (toppingOption != null)
                        {
                            total += toppingOption.price;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "解析 Options 失敗：MenuItemId={MenuItemId}", menuItem.ItemId);
            }

            return total;
        }
    }
}
