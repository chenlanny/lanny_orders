using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OfficeOrderApi.Models
{
    [Table("OrderItems")]
    public class OrderItem
    {
        [Key]
        public int OrderItemId { get; set; }

        [Required]
        public int GroupId { get; set; }

        [Required]
        public int UserId { get; set; }

        [Required]
        public int ItemId { get; set; }

        [Required]
        [StringLength(20)]
        public string SizeCode { get; set; } = string.Empty;

        [Required]
        [StringLength(50)]
        public string SizeName { get; set; } = string.Empty;

        public int Quantity { get; set; } = 1;

        [StringLength(200)]
        public string? CustomOptions { get; set; }

        [Column(TypeName = "nvarchar(500)")]
        public string? Toppings { get; set; }

        [StringLength(200)]
        public string? Note { get; set; }

        [Column(TypeName = "decimal(8,1)")]
        public decimal BasePrice { get; set; }

        [Column(TypeName = "decimal(8,1)")]
        public decimal ToppingPrice { get; set; } = 0;

        [Column(TypeName = "decimal(8,1)")]
        public decimal UnitPrice { get; set; }

        [Column(TypeName = "decimal(8,1)")]
        public decimal SubTotal { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;

        // Navigation properties
        [ForeignKey("GroupId")]
        public virtual OrderGroup OrderGroup { get; set; } = null!;

        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;

        [ForeignKey("ItemId")]
        public virtual MenuItem MenuItem { get; set; } = null!;
    }
}
