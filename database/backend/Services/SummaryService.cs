using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using OfficeOrderApi.Data;
using OfficeOrderApi.DTOs;

namespace OfficeOrderApi.Services
{
    /// <summary>
    /// 帳單結算服務
    /// </summary>
    public class SummaryService
    {
        private readonly AppDbContext _context;
        private readonly ILogger<SummaryService> _logger;

        public SummaryService(AppDbContext context, ILogger<SummaryService> logger)
        {
            _context = context;
            _logger = logger;
        }

        /// <summary>
        /// 取得活動結算摘要
        /// </summary>
        public async Task<EventSummaryDto> GetEventSummaryAsync(int eventId)
        {
            try
            {
                _logger.LogInformation("計算活動結算：EventId={EventId}", eventId);

                // 載入活動完整資訊
                var eventEntity = await _context.Events
                    .Include(e => e.OrderGroups)
                        .ThenInclude(og => og.Store)
                    .Include(e => e.OrderGroups)
                        .ThenInclude(og => og.OrderItems)
                            .ThenInclude(oi => oi.User)
                    .Include(e => e.OrderGroups)
                        .ThenInclude(og => og.OrderItems)
                            .ThenInclude(oi => oi.MenuItem)
                    .FirstOrDefaultAsync(e => e.EventId == eventId);

                if (eventEntity == null)
                {
                    throw new KeyNotFoundException($"活動不存在：EventId={eventId}");
                }

                // 計算總金額
                var allOrders = eventEntity.OrderGroups
                    .SelectMany(og => og.OrderItems)
                    .ToList();

                // 計算所有店家的外送費總和
                var totalDeliveryFee = eventEntity.OrderGroups.Sum(og => og.DeliveryFee);
                var grandTotal = allOrders.Sum(o => o.SubTotal) + totalDeliveryFee;

                // 按店家分組處理
                var storeSummaries = new List<StoreSummaryDto>();
                var userTotalDict = new Dictionary<int, UserTotalDto>();

                foreach (var orderGroup in eventEntity.OrderGroups)
                {
                    var store = orderGroup.Store;
                    var storeOrders = orderGroup.OrderItems.ToList();
                    
                    // 計算此店家的參與人數
                    var storeParticipants = storeOrders.Select(o => o.UserId).Distinct().ToList();
                    var participantCount = storeParticipants.Count;
                    
                    // 計算每人外送費（無條件進位）- 使用此店家的外送費
                    var deliveryFeePerPerson = participantCount > 0
                        ? Math.Ceiling(orderGroup.DeliveryFee / participantCount)
                        : 0;

                    // 按用戶分組
                    var userSummaries = new List<UserStoreSummaryDto>();
                    foreach (var userId in storeParticipants)
                    {
                        var userOrders = storeOrders.Where(o => o.UserId == userId).ToList();
                        var user = userOrders.First().User;
                        var itemTotal = userOrders.Sum(o => o.SubTotal);
                        var totalDue = itemTotal + deliveryFeePerPerson;

                        // 建立訂單項目列表
                        var items = userOrders.Select(o => MapToOrderItemSummaryDto(o)).ToList();

                        userSummaries.Add(new UserStoreSummaryDto
                        {
                            UserName = user?.Name ?? "未知",
                            Department = user?.Department ?? "未知",
                            ItemTotal = itemTotal,
                            DeliveryFeeShare = deliveryFeePerPerson,
                            TotalDue = totalDue,
                            Items = items
                        });

                        // 累計用戶總計
                        if (!userTotalDict.ContainsKey(userId))
                        {
                            userTotalDict[userId] = new UserTotalDto
                            {
                                UserId = userId,
                                UserName = user?.Name ?? "未知",
                                Department = user?.Department ?? "未知",
                                ItemTotal = 0,
                                DeliveryFeeTotal = 0,
                                TotalDue = 0
                            };
                        }
                        userTotalDict[userId].ItemTotal += itemTotal;
                        userTotalDict[userId].DeliveryFeeTotal += deliveryFeePerPerson;
                        userTotalDict[userId].TotalDue += totalDue;
                    }

                    storeSummaries.Add(new StoreSummaryDto
                    {
                        StoreName = store?.Name ?? "未知",
                        StoreCategory = store?.Category ?? "未知",
                        DeliveryFee = orderGroup.DeliveryFee,
                        ParticipantCount = participantCount,
                        Total = storeOrders.Sum(o => o.SubTotal) + orderGroup.DeliveryFee,
                        UserSummaries = userSummaries.OrderBy(u => u.UserName).ToList()
                    });
                }

                _logger.LogInformation("結算完成：總金額={GrandTotal}", grandTotal);

                return new EventSummaryDto
                {
                    EventId = eventEntity.EventId,
                    Title = eventEntity.Title,
                    Status = eventEntity.Status,
                    CreatedAt = eventEntity.CreatedAt,
                    ClosedAt = eventEntity.ClosedAt,
                    GrandTotal = grandTotal,
                    StoreSummaries = storeSummaries,
                    UserTotals = userTotalDict.Values.OrderBy(u => u.UserName).ToList()
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "計算活動結算失敗：EventId={EventId}", eventId);
                throw;
            }
        }

        /// <summary>
        /// 映射至 OrderItemSummaryDto
        /// </summary>
        private static OrderItemSummaryDto MapToOrderItemSummaryDto(Models.OrderItem order)
        {
            // 解析 CustomOptions
            string? customOptions = null;
            if (!string.IsNullOrEmpty(order.CustomOptions))
            {
                try
                {
                    var options = System.Text.Json.JsonSerializer.Deserialize<Dictionary<string, string>>(order.CustomOptions);
                    if (options != null)
                    {
                        var optionParts = new List<string>();
                        if (options.TryGetValue("sweetness", out var sweetness))
                            optionParts.Add($"甜度: {sweetness}");
                        if (options.TryGetValue("temperature", out var temperature))
                            optionParts.Add($"冰度: {temperature}");
                        customOptions = string.Join(", ", optionParts);
                    }
                }
                catch { }
            }

            // 解析 Toppings
            List<ToppingDto>? toppings = null;
            if (!string.IsNullOrEmpty(order.Toppings))
            {
                try
                {
                    var toppingNames = System.Text.Json.JsonSerializer.Deserialize<List<string>>(order.Toppings);
                    if (toppingNames != null && toppingNames.Any())
                    {
                        // 計算平均配料價格（總配料價格除以配料數量）
                        var averagePrice = toppingNames.Count > 0 
                            ? order.ToppingPrice / toppingNames.Count 
                            : 0;

                        toppings = toppingNames.Select(name => new ToppingDto
                        {
                            Name = name,
                            Price = averagePrice
                        }).ToList();
                    }
                }
                catch { }
            }

            return new OrderItemSummaryDto
            {
                ItemName = order.MenuItem?.Name ?? "未知",
                SizeName = order.SizeName ?? "未知",
                Quantity = order.Quantity,
                CustomOptions = customOptions,
                Toppings = toppings,
                SubTotal = order.SubTotal
            };
        }
    }
}
