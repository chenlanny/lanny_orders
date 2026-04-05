using System.Collections.Generic;

namespace OfficeOrderApi.DTOs
{
    /// <summary>
    /// 熱門品項 DTO
    /// </summary>
    public class PopularItemDto
    {
        public int ItemId { get; set; }
        public string ItemName { get; set; } = string.Empty;
        public string StoreName { get; set; } = string.Empty;
        public string Category { get; set; } = string.Empty; // Drink / Lunch / Snack
        public int OrderCount { get; set; }
        public decimal TotalAmount { get; set; }
        public int OrderTimes { get; set; }
    }

    /// <summary>
    /// 個人統計 DTO
    /// </summary>
    public class PersonalStatsDto
    {
        public decimal TotalAmount { get; set; }
        public int TotalOrders { get; set; }
        public int TotalItems { get; set; }
        public decimal AverageAmount { get; set; }
        public List<FavoriteItemDto> FavoriteItems { get; set; } = new List<FavoriteItemDto>();
        public List<StoreDistributionDto> StoreDistribution { get; set; } = new List<StoreDistributionDto>();
    }

    /// <summary>
    /// 最愛品項 DTO
    /// </summary>
    public class FavoriteItemDto
    {
        public string ItemName { get; set; } = string.Empty;
        public string StoreName { get; set; } = string.Empty;
        public int OrderCount { get; set; }
        public decimal TotalAmount { get; set; }
    }

    /// <summary>
    /// 店家分布 DTO
    /// </summary>
    public class StoreDistributionDto
    {
        public string StoreName { get; set; } = string.Empty;
        public string Category { get; set; } = string.Empty; // Drink / Lunch / Snack
        public int OrderCount { get; set; }
        public decimal TotalAmount { get; set; }
        public double Percentage { get; set; }
    }

    /// <summary>
    /// 部門統計 DTO
    /// </summary>
    public class DepartmentStatsDto
    {
        public string DepartmentName { get; set; } = string.Empty;
        public decimal TotalAmount { get; set; }
        public int TotalOrders { get; set; }
        public int UserCount { get; set; }
        public decimal AveragePerPerson { get; set; }
    }

    /// <summary>
    /// 月度趨勢 DTO（按分類統計）
    /// </summary>
    public class MonthlyTrendDto
    {
        public int Year { get; set; }
        public int Month { get; set; }
        
        // 飲料統計
        public int DrinkOrderCount { get; set; }
        public decimal DrinkAmount { get; set; }
        public decimal DrinkDeliveryFee { get; set; }
        
        // 便當統計
        public int LunchOrderCount { get; set; }
        public decimal LunchAmount { get; set; }
        public decimal LunchDeliveryFee { get; set; }
        
        // 總計
        public int TotalOrderCount => DrinkOrderCount + LunchOrderCount;
        public decimal TotalAmount => DrinkAmount + LunchAmount;
        public decimal TotalDeliveryFee => DrinkDeliveryFee + LunchDeliveryFee;
        
        public string MonthLabel => $"{Year}/{Month:D2}";
    }
}
