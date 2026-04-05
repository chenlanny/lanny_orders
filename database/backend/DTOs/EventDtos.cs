using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace OfficeOrderApi.DTOs
{
    /// <summary>
    /// 建立訂購活動請求 DTO
    /// </summary>
    public class CreateEventRequestDto
    {
        [Required(ErrorMessage = "活動名稱為必填")]
        [StringLength(100, ErrorMessage = "活動名稱長度不可超過100字")]
        public string Title { get; set; } = string.Empty;

        [StringLength(500, ErrorMessage = "備註長度不可超過500字")]
        public string? Notes { get; set; }

        [Required(ErrorMessage = "店家設定為必填")]
        [MinLength(1, ErrorMessage = "至少需要選擇一家店")]
        public List<CreateOrderGroupDto> OrderGroups { get; set; } = new List<CreateOrderGroupDto>();
    }

    /// <summary>
    /// 訂單群組建立 DTO
    /// </summary>
    public class CreateOrderGroupDto
    {
        [Required(ErrorMessage = "店家ID為必填")]
        public int StoreId { get; set; }

        [Required(ErrorMessage = "截止時間為必填")]
        public DateTime Deadline { get; set; }

        [Range(0, 500, ErrorMessage = "運費必須在0-500之間")]
        public decimal DeliveryFee { get; set; } = 0;
    }

    /// <summary>
    /// 活動資訊 DTO
    /// </summary>
    public class EventDto
    {
        public int EventId { get; set; }
        public string Title { get; set; } = string.Empty;
        public string OrderType { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public DateTime? Deadline { get; set; }
        public decimal DeliveryFee { get; set; }
        public string? Notes { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? ClosedAt { get; set; }

        // 創建者資訊
        public int CreatorId { get; set; }
        public string CreatorName { get; set; } = string.Empty;

        // 訂單群組列表（含截止時間）
        public List<OrderGroupSimpleDto> OrderGroups { get; set; } = new List<OrderGroupSimpleDto>();

        // 統計資訊
        public int TotalOrders { get; set; }
        public int TotalParticipants { get; set; }
    }

    /// <summary>
    /// 訂單群組簡化資訊 DTO
    /// </summary>
    public class OrderGroupSimpleDto
    {
        public int GroupId { get; set; }
        public int StoreId { get; set; }
        public string StoreName { get; set; } = string.Empty;
        public string Category { get; set; } = string.Empty;
        public DateTime Deadline { get; set; }
        public decimal DeliveryFee { get; set; }
        public string Status { get; set; } = string.Empty;
    }

    /// <summary>
    /// 更新訂單群組截止時間請求 DTO
    /// </summary>
    public class UpdateOrderGroupDeadlineDto
    {
        [Required(ErrorMessage = "截止時間為必填")]
        public DateTime Deadline { get; set; }
    }

    /// <summary>
    /// 簡化的店家資訊 DTO
    /// </summary>
    public class StoreSimpleDto
    {
        public int StoreId { get; set; }
        public string StoreName { get; set; } = string.Empty;
        public string Category { get; set; } = string.Empty;
        public string? Phone { get; set; }
        public string? Address { get; set; }
    }

    /// <summary>
    /// 完整店家資訊 DTO（含菜單）
    /// </summary>
    public class StoreDto : StoreSimpleDto
    {
        public DateTime CreatedAt { get; set; }
        public List<MenuItemDto> MenuItems { get; set; } = new List<MenuItemDto>();
    }

    /// <summary>
    /// 菜單項目 DTO
    /// </summary>
    public class MenuItemDto
    {
        public int MenuItemId { get; set; }
        public string ItemName { get; set; } = string.Empty;
        public string Category { get; set; } = string.Empty;
        public string? PriceRules { get; set; } // JSON 字串
        public string? Options { get; set; } // JSON 字串
        public bool IsAvailable { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
