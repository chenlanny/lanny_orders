using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using OfficeOrderApi.Data;
using OfficeOrderApi.DTOs;

namespace OfficeOrderApi.Controllers
{
    /// <summary>
    /// 統計分析控制器
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class StatsController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly ILogger<StatsController> _logger;

        public StatsController(AppDbContext context, ILogger<StatsController> logger)
        {
            _context = context;
            _logger = logger;
        }

        /// <summary>
        /// 取得當前用戶ID
        /// </summary>
        private int GetCurrentUserId()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.Parse(userIdClaim ?? "0");
        }

        /// <summary>
        /// 取得熱門品項排行（TOP 10）
        /// </summary>
        [HttpGet("popular-items")]
        public async Task<ActionResult<ApiResponse<List<PopularItemDto>>>> GetPopularItems(
            [FromQuery] int days = 30)
        {
            try
            {
                var cutoffDate = DateTime.Now.AddDays(-days);

                var popularItems = await _context.OrderItems
                    .Include(oi => oi.MenuItem)
                        .ThenInclude(i => i.Store)
                    .Where(oi => oi.CreatedAt >= cutoffDate)
                    .GroupBy(oi => new { 
                        oi.ItemId, 
                        ItemName = oi.MenuItem.Name, 
                        StoreName = oi.MenuItem.Store.Name, 
                        Category = oi.MenuItem.Store.Category 
                    })
                    .Select(g => new PopularItemDto
                    {
                        ItemId = g.Key.ItemId,
                        ItemName = g.Key.ItemName,
                        StoreName = g.Key.StoreName,
                        Category = g.Key.Category,
                        OrderCount = g.Sum(oi => oi.Quantity),
                        TotalAmount = g.Sum(oi => oi.SubTotal),
                        OrderTimes = g.Count()
                    })
                    .OrderByDescending(p => p.OrderCount)
                    .Take(20)
                    .ToListAsync();

                return Ok(ApiResponse<List<PopularItemDto>>.Ok(popularItems, "取得熱門品項成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得熱門品項失敗");
                return StatusCode(500, ApiResponse<List<PopularItemDto>>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 取得個人消費統計
        /// </summary>
        [HttpGet("personal")]
        public async Task<ActionResult<ApiResponse<PersonalStatsDto>>> GetPersonalStats(
            [FromQuery] int days = 30)
        {
            try
            {
                var userId = GetCurrentUserId();
                var cutoffDate = DateTime.Now.AddDays(-days);

                var orders = await _context.OrderItems
                    .Include(oi => oi.MenuItem)
                        .ThenInclude(i => i.Store)
                    .Where(oi => oi.UserId == userId && oi.CreatedAt >= cutoffDate)
                    .ToListAsync();

                var totalAmount = orders.Sum(o => o.SubTotal);
                var totalOrders = orders.Count;
                var totalItems = orders.Sum(o => o.Quantity);

                var favoriteItems = orders
                    .GroupBy(o => new { o.ItemId, ItemName = o.MenuItem.Name, StoreName = o.MenuItem.Store.Name })
                    .Select(g => new FavoriteItemDto
                    {
                        ItemName = g.Key.ItemName,
                        StoreName = g.Key.StoreName,
                        OrderCount = g.Sum(o => o.Quantity),
                        TotalAmount = g.Sum(o => o.SubTotal)
                    })
                    .OrderByDescending(f => f.OrderCount)
                    .Take(5)
                    .ToList();

                var storeDistribution = orders
                    .GroupBy(o => new { StoreName = o.MenuItem.Store.Name, Category = o.MenuItem.Store.Category })
                    .Select(g => new StoreDistributionDto
                    {
                        StoreName = g.Key.StoreName,
                        Category = g.Key.Category,
                        OrderCount = g.Count(),
                        TotalAmount = g.Sum(o => o.SubTotal),
                        Percentage = 0 // 稍後計算
                    })
                    .ToList();

                // 計算百分比
                foreach (var store in storeDistribution)
                {
                    store.Percentage = totalOrders > 0 
                        ? Math.Round((double)store.OrderCount / totalOrders * 100, 1) 
                        : 0;
                }

                var stats = new PersonalStatsDto
                {
                    TotalAmount = totalAmount,
                    TotalOrders = totalOrders,
                    TotalItems = totalItems,
                    AverageAmount = totalOrders > 0 ? Math.Round(totalAmount / totalOrders, 1) : 0,
                    FavoriteItems = favoriteItems,
                    StoreDistribution = storeDistribution
                };

                return Ok(ApiResponse<PersonalStatsDto>.Ok(stats, "取得個人統計成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得個人統計失敗：UserId={UserId}", GetCurrentUserId());
                return StatusCode(500, ApiResponse<PersonalStatsDto>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 取得部門消費排行（僅管理員，含配送費分攤）
        /// </summary>
        [HttpGet("department-ranking")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<ApiResponse<List<DepartmentStatsDto>>>> GetDepartmentRanking(
            [FromQuery] int days = 30)
        {
            try
            {
                var cutoffDate = DateTime.Now.AddDays(-days);

                // 載入所有訂單項目和訂單群組
                var orderItems = await _context.OrderItems
                    .Include(oi => oi.User)
                    .Include(oi => oi.OrderGroup)
                    .Where(oi => oi.CreatedAt >= cutoffDate && oi.User.Department != null)
                    .ToListAsync();

                // 計算每個部門的配送費分攤
                var departmentDeliveryFees = new Dictionary<string, decimal>();
                var groupedByOrderGroup = orderItems.GroupBy(oi => oi.GroupId);
                
                foreach (var groupOrders in groupedByOrderGroup)
                {
                    var orderGroup = groupOrders.First().OrderGroup;
                    var participantCount = groupOrders.Select(oi => oi.UserId).Distinct().Count();
                    var deliveryFeeShare = participantCount > 0 
                        ? Math.Ceiling(orderGroup.DeliveryFee / participantCount) 
                        : 0;

                    foreach (var userGroup in groupOrders.GroupBy(oi => oi.User.Department))
                    {
                        if (!departmentDeliveryFees.ContainsKey(userGroup.Key))
                            departmentDeliveryFees[userGroup.Key] = 0;
                        
                        // 每個部門的用戶在這個群組的配送費分攤
                        var deptUserCount = userGroup.Select(oi => oi.UserId).Distinct().Count();
                        departmentDeliveryFees[userGroup.Key] += deliveryFeeShare * deptUserCount;
                    }
                }

                // 在記憶體中進行分組統計
                var departmentStats = orderItems
                    .GroupBy(oi => oi.User.Department)
                    .Select(g => new DepartmentStatsDto
                    {
                        DepartmentName = g.Key,
                        TotalAmount = g.Sum(oi => oi.SubTotal) + 
                            (departmentDeliveryFees.ContainsKey(g.Key) ? departmentDeliveryFees[g.Key] : 0),
                        TotalOrders = g.Count(),
                        UserCount = g.Select(oi => oi.UserId).Distinct().Count(),
                        AveragePerPerson = 0 // 稍後計算
                    })
                    .OrderByDescending(d => d.TotalAmount)
                    .ToList();

                // 計算人均消費
                foreach (var dept in departmentStats)
                {
                    dept.AveragePerPerson = dept.UserCount > 0 
                        ? Math.Round(dept.TotalAmount / dept.UserCount, 1) 
                        : 0;
                }

                return Ok(ApiResponse<List<DepartmentStatsDto>>.Ok(departmentStats, "取得部門排行成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得部門排行失敗");
                return StatusCode(500, ApiResponse<List<DepartmentStatsDto>>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 取得月度消費趨勢（飲料、便當分類統計，含配送費分攤）
        /// </summary>
        [HttpGet("monthly-trend")]
        public async Task<ActionResult<ApiResponse<List<MonthlyTrendDto>>>> GetMonthlyTrend(
            [FromQuery] int months = 6)
        {
            try
            {
                var userId = GetCurrentUserId();
                var startDate = DateTime.Now.AddMonths(-months).Date;

                // 查詢所有訂單項目，包含店家分類信息和訂單群組
                var orders = await _context.OrderItems
                    .Include(oi => oi.MenuItem)
                    .ThenInclude(m => m.Store)
                    .Include(oi => oi.OrderGroup)
                    .Where(oi => oi.UserId == userId && oi.CreatedAt >= startDate)
                    .ToListAsync();

                // 按年月分組統計
                var monthlyGroups = orders
                    .GroupBy(oi => new { oi.CreatedAt.Year, oi.CreatedAt.Month })
                    .ToList();

                var monthlyData = new List<MonthlyTrendDto>();

                foreach (var monthGroup in monthlyGroups)
                {
                    var drinkOrders = monthGroup.Where(oi => oi.MenuItem.Store.Category == "Drink").ToList();
                    var lunchOrders = monthGroup.Where(oi => oi.MenuItem.Store.Category == "Lunch").ToList();

                    // 計算配送費分攤（按 OrderGroup 分組）
                    decimal drinkDeliveryFee = 0;
                    decimal lunchDeliveryFee = 0;

                    var groupedByOrderGroup = monthGroup.GroupBy(oi => oi.GroupId);
                    foreach (var groupOrders in groupedByOrderGroup)
                    {
                        var orderGroup = groupOrders.First().OrderGroup;
                        var participantCount = _context.OrderItems
                            .Where(oi => oi.GroupId == groupOrders.Key)
                            .Select(oi => oi.UserId)
                            .Distinct()
                            .Count();

                        var deliveryFeeShare = participantCount > 0 
                            ? Math.Ceiling(orderGroup.DeliveryFee / participantCount) 
                            : 0;

                        var storeCategory = groupOrders.First().MenuItem.Store.Category;
                        if (storeCategory == "Drink")
                            drinkDeliveryFee += deliveryFeeShare;
                        else if (storeCategory == "Lunch")
                            lunchDeliveryFee += deliveryFeeShare;
                    }

                    monthlyData.Add(new MonthlyTrendDto
                    {
                        Year = monthGroup.Key.Year,
                        Month = monthGroup.Key.Month,
                        DrinkOrderCount = drinkOrders.Count,
                        DrinkAmount = drinkOrders.Sum(oi => oi.SubTotal) + drinkDeliveryFee,
                        DrinkDeliveryFee = drinkDeliveryFee,
                        LunchOrderCount = lunchOrders.Count,
                        LunchAmount = lunchOrders.Sum(oi => oi.SubTotal) + lunchDeliveryFee,
                        LunchDeliveryFee = lunchDeliveryFee
                    });
                }

                monthlyData = monthlyData
                    .OrderBy(m => m.Year)
                    .ThenBy(m => m.Month)
                    .ToList();

                return Ok(ApiResponse<List<MonthlyTrendDto>>.Ok(monthlyData, "取得月度趨勢成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得月度趨勢失敗：UserId={UserId}", GetCurrentUserId());
                return StatusCode(500, ApiResponse<List<MonthlyTrendDto>>.Fail("伺服器錯誤", ex.Message));
            }
        }
    }
}
