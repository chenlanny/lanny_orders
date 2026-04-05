using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OfficeOrderApi.Models
{
    [Table("MenuItems")]
    public class MenuItem
    {
        [Key]
        public int ItemId { get; set; }

        [Required]
        public int StoreId { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; } = string.Empty;

        [Required]
        [StringLength(50)]
        public string Category { get; set; } = string.Empty;

        [Column(TypeName = "nvarchar(500)")]
        public string? PriceRules { get; set; } // JSON

        [Column(TypeName = "nvarchar(1000)")]
        public string? Options { get; set; } // JSON

        [Column(TypeName = "nvarchar(MAX)")]
        public string? ImageUrl { get; set; }

        public bool IsAvailable { get; set; } = true;

        public DateTime CreatedAt { get; set; } = DateTime.Now;

        // Navigation properties
        [ForeignKey("StoreId")]
        public virtual Store Store { get; set; } = null!;
        public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
    }
}
