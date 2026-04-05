using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using OfficeOrderApi.Data;
using OfficeOrderApi.Models;
using OfficeOrderApi.DTOs;

namespace OfficeOrderApi.Services
{
    /// <summary>
    /// 活動管理服務
    /// </summary>
    public class EventService
    {
        private readonly AppDbContext _context;
        private readonly ILogger<EventService> _logger;

        public EventService(AppDbContext context, ILogger<EventService> logger)
        {
            _context = context;
            _logger = logger;
        }

        /// <summary>
        /// 建立訂購活動
        /// </summary>
        public async Task<EventDto> CreateEventAsync(CreateEventRequestDto request, int creatorId)
        {
            // 驗證：檢查截止時間不能是過去時間
            var now = DateTime.Now;
            var invalidDeadlines = request.OrderGroups.Where(g => g.Deadline <= now).ToList();
            if (invalidDeadlines.Any())
            {
                throw new ArgumentException("截止時間不能是過去時間");
            }

            // 驗證：檢查是否有重複的店家
            var storeIds = request.OrderGroups.Select(g => g.StoreId).ToList();
            var duplicateStores = storeIds.GroupBy(id => id)
                                          .Where(g => g.Count() > 1)
                                          .Select(g => g.Key)
                                          .ToList();
            if (duplicateStores.Any())
            {
                throw new ArgumentException($"不能在同一揪團中重複選擇相同店家 (店家ID: {string.Join(", ", duplicateStores)})");
            }

            // 驗證：檢查進行中的揪團是否已有相同店家和相同截止時間
            var existingOpenGroups = await _context.OrderGroups
                .Include(og => og.Store)
                .Include(og => og.Event)
                .Where(og => og.Event.Status == "Open")
                .ToListAsync();

            foreach (var requestGroup in request.OrderGroups)
            {
                var conflictingGroup = existingOpenGroups.FirstOrDefault(og => 
                    og.StoreId == requestGroup.StoreId && 
                    og.Deadline == requestGroup.Deadline);
                
                if (conflictingGroup != null)
                {
                    var storeName = conflictingGroup.Store?.Name ?? $"店家ID:{requestGroup.StoreId}";
                    var deadlineStr = requestGroup.Deadline.ToString("yyyy-MM-dd HH:mm");
                    throw new ArgumentException(
                        $"店家「{storeName}」在 {deadlineStr} 的揪團已存在（活動：{conflictingGroup.Event.Title}），請選擇不同的截止時間或加入現有揪團");
                }
            }

            // 使用執行策略來支持重試
            var strategy = _context.Database.CreateExecutionStrategy();
            
            return await strategy.ExecuteAsync(async () =>
            {
                using (var transaction = await _context.Database.BeginTransactionAsync())
                {
                    try
                    {
                        _logger.LogInformation("用戶 {UserId} 建立活動：{Title}", creatorId, request.Title);

                        // 取得第一個訂單群組的資訊作為活動的預設值
                        var firstGroup = request.OrderGroups.First();
                        
                        // 判斷訂購類型（根據店家類別）
                        var firstStore = await _context.Stores.FindAsync(firstGroup.StoreId);
                        string orderType = firstStore?.Category == "Drink" ? "飲料" : 
                                           firstStore?.Category == "Lunch" ? "便當" : "其他";

                        // 建立活動
                        var newEvent = new Event
                        {
                            Title = request.Title,
                            OrderType = orderType,
                            InitiatorId = creatorId,
                            Deadline = firstGroup.Deadline,
                            DeliveryFee = request.OrderGroups.Sum(g => g.DeliveryFee), // 總運費
                            Notes = request.Notes,
                            Status = "Open",
                            CreatedAt = DateTime.Now
                        };

                        _context.Events.Add(newEvent);
                        await _context.SaveChangesAsync();

                        // 建立各店家的訂單群組
                        var orderGroups = request.OrderGroups.Select(groupDto => new OrderGroup
                        {
                            EventId = newEvent.EventId,
                            StoreId = groupDto.StoreId,
                            Deadline = groupDto.Deadline,
                            DeliveryFee = groupDto.DeliveryFee,
                            Status = "Open",
                            CreatedAt = DateTime.Now
                        }).ToList();

                        _context.OrderGroups.AddRange(orderGroups);
                        await _context.SaveChangesAsync();

                        await transaction.CommitAsync();

                        _logger.LogInformation("活動建立成功：EventId={EventId}", newEvent.EventId);

                        // 載入完整資訊
                        return await GetEventByIdAsync(newEvent.EventId);
                    }
                    catch (Exception ex)
                    {
                        await transaction.RollbackAsync();
                        _logger.LogError(ex, "建立活動失敗：{Title}", request.Title);
                        throw;
                    }
                }
            });
        }

        /// <summary>
        /// 取得所有進行中的活動
        /// </summary>
        public async Task<List<EventDto>> GetActiveEventsAsync()
        {
            try
            {
                var events = await _context.Events
                    .Include(e => e.Initiator)
                    .Include(e => e.OrderGroups)
                        .ThenInclude(og => og.Store)
                    .Include(e => e.OrderGroups)
                        .ThenInclude(og => og.OrderItems)
                    .Where(e => e.Status == "Open")
                    .OrderByDescending(e => e.CreatedAt)
                    .ToListAsync();

                return events.Select(e => MapToEventDto(e)).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得活動列表失敗");
                throw;
            }
        }

        /// <summary>
        /// 根據 EventId 取得活動詳情
        /// </summary>
        public async Task<EventDto> GetEventByIdAsync(int eventId)
        {
            try
            {
                var eventEntity = await _context.Events
                    .Include(e => e.Initiator)
                    .Include(e => e.OrderGroups)
                        .ThenInclude(og => og.Store)
                    .Include(e => e.OrderGroups)
                        .ThenInclude(og => og.OrderItems)
                            .ThenInclude(oi => oi.User)
                    .FirstOrDefaultAsync(e => e.EventId == eventId);

                if (eventEntity == null)
                {
                    throw new KeyNotFoundException($"活動不存在：EventId={eventId}");
                }

                return MapToEventDto(eventEntity);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得活動詳情失敗：EventId={EventId}", eventId);
                throw;
            }
        }

        /// <summary>
        /// 關閉活動（截止訂購）
        /// </summary>
        public async Task<bool> CloseEventAsync(int eventId, int userId)
        {
            try
            {
                var eventEntity = await _context.Events.FindAsync(eventId);
                if (eventEntity == null)
                {
                    throw new KeyNotFoundException($"活動不存在：EventId={eventId}");
                }

                // 檢查權限（只有創建者可關閉）
                if (eventEntity.InitiatorId != userId)
                {
                    _logger.LogWarning("用戶 {UserId} 無權關閉活動 {EventId}", userId, eventId);
                    return false;
                }

                if (eventEntity.Status != "Open")
                {
                    _logger.LogWarning("活動 {EventId} 已結束，無法重複關閉", eventId);
                    return false;
                }

                eventEntity.Status = "Closed";
                eventEntity.ClosedAt = DateTime.Now;

                await _context.SaveChangesAsync();

                _logger.LogInformation("活動已關閉：EventId={EventId}", eventId);
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "關閉活動失敗：EventId={EventId}", eventId);
                throw;
            }
        }

        /// <summary>
        /// 映射至 EventDto
        /// </summary>
        private static EventDto MapToEventDto(Event eventEntity)
        {
            var allOrders = eventEntity.OrderGroups
                .SelectMany(og => og.OrderItems)
                .ToList();

            return new EventDto
            {
                EventId = eventEntity.EventId,
                Title = eventEntity.Title,
                OrderType = eventEntity.OrderType ?? string.Empty,
                Status = eventEntity.Status,
                Deadline = eventEntity.Deadline,
                DeliveryFee = eventEntity.DeliveryFee,
                Notes = eventEntity.Notes,
                CreatedAt = eventEntity.CreatedAt,
                ClosedAt = eventEntity.ClosedAt,
                CreatorId = eventEntity.InitiatorId,
                CreatorName = eventEntity.Initiator?.Name ?? "未知",
                OrderGroups = eventEntity.OrderGroups.Select(og => 
                {
                    // 根據截止時間動態判斷狀態
                    var now = DateTime.Now;
                    var status = og.Deadline <= now ? "Closed" : "Open";
                    
                    return new OrderGroupSimpleDto
                    {
                        GroupId = og.GroupId,
                        StoreId = og.StoreId,
                        StoreName = og.Store?.Name ?? "未知店家",
                        Category = og.Store?.Category ?? string.Empty,
                        Deadline = og.Deadline,
                        DeliveryFee = og.DeliveryFee,
                        Status = status
                    };
                }).ToList(),
                TotalOrders = allOrders.Count,
                TotalParticipants = allOrders.Select(o => o.UserId).Distinct().Count()
            };
        }

        /// <summary>
        /// 更新訂單群組截止時間（管理員提早截止）
        /// </summary>
        public async Task<OrderGroupSimpleDto> UpdateOrderGroupDeadlineAsync(int groupId, UpdateOrderGroupDeadlineDto request, int userId)
        {
            try
            {
                _logger.LogInformation("用戶 {UserId} 更新訂單群組 {GroupId} 截止時間", userId, groupId);

                var orderGroup = await _context.OrderGroups
                    .Include(og => og.Event)
                    .Include(og => og.Store)
                    .FirstOrDefaultAsync(og => og.GroupId == groupId);

                if (orderGroup == null)
                {
                    throw new KeyNotFoundException($"訂單群組不存在：GroupId={groupId}");
                }

                // 檢查權限：只有活動創建者可以更新
                if (orderGroup.Event.InitiatorId != userId)
                {
                    throw new UnauthorizedAccessException("只有活動創建者可以更新截止時間");
                }

                // 檢查活動狀態
                if (orderGroup.Event.Status != "Open")
                {
                    throw new InvalidOperationException("活動已結束，無法更新截止時間");
                }

                // 驗證新截止時間不能晚於原截止時間（只能提早）
                if (request.Deadline > orderGroup.Deadline)
                {
                    throw new ArgumentException("截止時間只能提早，不能延後");
                }

                // 驗證新截止時間不能是過去時間
                if (request.Deadline <= DateTime.Now)
                {
                    throw new ArgumentException("截止時間不能是過去時間");
                }

                orderGroup.Deadline = request.Deadline;
                await _context.SaveChangesAsync();

                _logger.LogInformation("訂單群組截止時間更新成功：GroupId={GroupId}, NewDeadline={Deadline}", 
                    groupId, request.Deadline);

                // 返回更新後的資訊
                var now = DateTime.Now;
                var status = orderGroup.Deadline <= now ? "Closed" : "Open";

                return new OrderGroupSimpleDto
                {
                    GroupId = orderGroup.GroupId,
                    StoreId = orderGroup.StoreId,
                    StoreName = orderGroup.Store?.Name ?? "未知店家",
                    Category = orderGroup.Store?.Category ?? string.Empty,
                    Deadline = orderGroup.Deadline,
                    DeliveryFee = orderGroup.DeliveryFee,
                    Status = status
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "更新訂單群組截止時間失敗：GroupId={GroupId}", groupId);
                throw;
            }
        }
    }
}
