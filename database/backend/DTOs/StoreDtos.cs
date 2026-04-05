using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace OfficeOrderApi.DTOs
{
    /// <summary>
    /// 創建店家請求 DTO
    /// </summary>
    public class CreateStoreRequestDto
    {
        [Required(ErrorMessage = "店家名稱為必填")]
        [StringLength(100, ErrorMessage = "店家名稱長度不可超過100字")]
        public string Name { get; set; } = string.Empty;

        [Required(ErrorMessage = "店家類別為必填")]
        [StringLength(50, ErrorMessage = "類別長度不可超過50字")]
        public string Category { get; set; } = string.Empty;

        [Phone(ErrorMessage = "電話格式不正確")]
        [StringLength(20, ErrorMessage = "電話長度不可超過20字")]
        public string? Phone { get; set; }

        [StringLength(200, ErrorMessage = "地址長度不可超過200字")]
        public string? Address { get; set; }
    }

    /// <summary>
    /// 更新店家請求 DTO
    /// </summary>
    public class UpdateStoreRequestDto
    {
        [Required(ErrorMessage = "店家名稱為必填")]
        [StringLength(100, ErrorMessage = "店家名稱長度不可超過100字")]
        public string Name { get; set; } = string.Empty;

        [Required(ErrorMessage = "店家類別為必填")]
        [StringLength(50, ErrorMessage = "類別長度不可超過50字")]
        public string Category { get; set; } = string.Empty;

        [Phone(ErrorMessage = "電話格式不正確")]
        [StringLength(20, ErrorMessage = "電話長度不可超過20字")]
        public string? Phone { get; set; }

        [StringLength(200, ErrorMessage = "地址長度不可超過200字")]
        public string? Address { get; set; }
    }

    /// <summary>
    /// 創建菜單項目請求 DTO
    /// </summary>
    public class CreateMenuItemRequestDto
    {
        [Required(ErrorMessage = "品項名稱為必填")]
        [StringLength(100, ErrorMessage = "品項名稱長度不可超過100字")]
        public string ItemName { get; set; } = string.Empty;

        [Required(ErrorMessage = "品項類別為必填")]
        [StringLength(50, ErrorMessage = "類別長度不可超過50字")]
        public string Category { get; set; } = string.Empty;

        [Required(ErrorMessage = "價格規則為必填")]
        public string PriceRules { get; set; } = string.Empty; // JSON: {"中杯":50,"大杯":60}

        public string? Options { get; set; } // JSON: {"sweetness":["正常","少糖"],"toppings":[...]}

        public bool IsAvailable { get; set; } = true;
    }

    /// <summary>
    /// 更新菜單項目請求 DTO
    /// </summary>
    public class UpdateMenuItemRequestDto
    {
        [Required(ErrorMessage = "品項名稱為必填")]
        [StringLength(100, ErrorMessage = "品項名稱長度不可超過100字")]
        public string ItemName { get; set; } = string.Empty;

        [Required(ErrorMessage = "品項類別為必填")]
        [StringLength(50, ErrorMessage = "類別長度不可超過50字")]
        public string Category { get; set; } = string.Empty;

        [Required(ErrorMessage = "價格規則為必填")]
        public string PriceRules { get; set; } = string.Empty;

        public string? Options { get; set; }

        public bool IsAvailable { get; set; }
    }
}
