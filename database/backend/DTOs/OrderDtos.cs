using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace OfficeOrderApi.DTOs
{
    /// <summary>
    /// 下訂單請求 DTO
    /// </summary>
    public class PlaceOrderRequestDto
    {
        [Required(ErrorMessage = "店家ID為必填")]
        public int StoreId { get; set; }

        [Required(ErrorMessage = "菜單項目ID為必填")]
        public int MenuItemId { get; set; }

        [Required(ErrorMessage = "數量為必填")]
        [Range(1, 99, ErrorMessage = "數量必須在1-99之間")]
        public int Quantity { get; set; }

        [StringLength(20, ErrorMessage = "尺寸長度不可超過20字")]
        public string? Size { get; set; }

        [StringLength(20, ErrorMessage = "甜度長度不可超過20字")]
        public string? Sweetness { get; set; }

        [StringLength(20, ErrorMessage = "溫度長度不可超過20字")]
        public string? Temperature { get; set; }

        [MaxLength(3, ErrorMessage = "加料最多選擇3種")]
        public List<string>? Toppings { get; set; }

        [StringLength(200, ErrorMessage = "備註長度不可超過200字")]
        public string? Remarks { get; set; }
    }

    /// <summary>
    /// 訂單項目 DTO
    /// </summary>
    public class OrderItemDto
    {
        public int OrderItemId { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; } = string.Empty;
        public int MenuItemId { get; set; }
        public string ItemName { get; set; } = string.Empty;
        public int Quantity { get; set; }
        public string? Size { get; set; }
        public string? Sweetness { get; set; }
        public string? Temperature { get; set; }
        public string? Toppings { get; set; }
        public decimal BasePrice { get; set; }
        public decimal ToppingPrice { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal SubTotal { get; set; }
        public string? Remarks { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    /// <summary>
    /// 訂單群組 DTO（店家維度）
    /// </summary>
    public class OrderGroupDto
    {
        public int OrderGroupId { get; set; }
        public int StoreId { get; set; }
        public string StoreName { get; set; } = string.Empty;
        public string Category { get; set; } = string.Empty;
        public decimal TotalAmount { get; set; }
        public int TotalItems { get; set; }
        public List<OrderItemDto> Orders { get; set; } = new List<OrderItemDto>();
    }

    /// <summary>
    /// 活動訂單摘要 DTO（用於結算）
    /// </summary>
    public class EventSummaryDto
    {
        public int EventId { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public DateTime? ClosedAt { get; set; }
        public decimal GrandTotal { get; set; }

        // 按店家分組的明細
        public List<StoreSummaryDto> StoreSummaries { get; set; } = new List<StoreSummaryDto>();

        // 用戶總計
        public List<UserTotalDto> UserTotals { get; set; } = new List<UserTotalDto>();
    }

    /// <summary>
    /// 店家訂單摘要
    /// </summary>
    public class StoreSummaryDto
    {
        public string StoreName { get; set; } = string.Empty;
        public string StoreCategory { get; set; } = string.Empty;
        public decimal DeliveryFee { get; set; }
        public int ParticipantCount { get; set; }
        public decimal Total { get; set; }
        public List<UserStoreSummaryDto> UserSummaries { get; set; } = new List<UserStoreSummaryDto>();
    }

    /// <summary>
    /// 用戶在某店家的訂單摘要
    /// </summary>
    public class UserStoreSummaryDto
    {
        public string UserName { get; set; } = string.Empty;
        public string Department { get; set; } = string.Empty;
        public decimal ItemTotal { get; set; }
        public decimal DeliveryFeeShare { get; set; }
        public decimal TotalDue { get; set; }
        public List<OrderItemSummaryDto> Items { get; set; } = new List<OrderItemSummaryDto>();
    }

    /// <summary>
    /// 訂單項目摘要
    /// </summary>
    public class OrderItemSummaryDto
    {
        public string ItemName { get; set; } = string.Empty;
        public string SizeName { get; set; } = string.Empty;
        public int Quantity { get; set; }
        public string? CustomOptions { get; set; }
        public List<ToppingDto>? Toppings { get; set; }
        public decimal SubTotal { get; set; }
    }

    /// <summary>
    /// 配料 DTO
    /// </summary>
    public class ToppingDto
    {
        public string Name { get; set; } = string.Empty;
        public decimal Price { get; set; }
    }

    /// <summary>
    /// 用戶總計
    /// </summary>
    public class UserTotalDto
    {
        public int UserId { get; set; }
        public string UserName { get; set; } = string.Empty;
        public string Department { get; set; } = string.Empty;
        public decimal ItemTotal { get; set; }
        public decimal DeliveryFeeTotal { get; set; }
        public decimal TotalDue { get; set; }
    }

    /// <summary>
    /// 批量訂單項目 DTO
    /// </summary>
    public class BatchOrderItemDto
    {
        [Required(ErrorMessage = "品項ID為必填")]
        public int ItemId { get; set; }

        [Required(ErrorMessage = "規格不可為空")]
        public string SizeCode { get; set; } = string.Empty;

        [Required(ErrorMessage = "數量為必填")]
        [Range(1, 99, ErrorMessage = "數量必須在1-99之間")]
        public int Quantity { get; set; }

        public string? CustomOptions { get; set; }
        public List<string>? Toppings { get; set; }
        public string? Note { get; set; }
    }

    /// <summary>
    /// 批量提交訂單請求 DTO
    /// </summary>
    public class SubmitBatchOrderRequestDto
    {
        [Required(ErrorMessage = "訂單群組ID為必填")]
        public int GroupId { get; set; }

        [Required(ErrorMessage = "訂單品項不可為空")]
        [MinLength(1, ErrorMessage = "至少需要一個訂單品項")]
        public List<BatchOrderItemDto> Items { get; set; } = new List<BatchOrderItemDto>();
    }

    /// <summary>
    /// 歷史訂單記錄 DTO（包含活動資訊）
    /// </summary>
    public class OrderHistoryDto
    {
        public int OrderItemId { get; set; }
        public int EventId { get; set; }
        public string EventTitle { get; set; } = string.Empty;
        public string StoreName { get; set; } = string.Empty;
        public string ItemName { get; set; } = string.Empty;
        public int Quantity { get; set; }
        public string? Size { get; set; }
        public string? Sweetness { get; set; }
        public string? Temperature { get; set; }
        public string? Toppings { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal SubTotal { get; set; }
        public string? Remarks { get; set; }
        public DateTime OrderDate { get; set; }
        public string EventStatus { get; set; } = string.Empty;
    }
}
