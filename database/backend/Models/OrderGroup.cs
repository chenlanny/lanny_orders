using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OfficeOrderApi.Models
{
    [Table("OrderGroups")]
    public class OrderGroup
    {
        [Key]
        public int GroupId { get; set; }

        [Required]
        public int EventId { get; set; }

        [Required]
        public int StoreId { get; set; }

        public DateTime Deadline { get; set; }

        [Column(TypeName = "decimal(8,1)")]
        public decimal DeliveryFee { get; set; } = 0;

        [StringLength(20)]
        public string Status { get; set; } = "Open";

        public DateTime CreatedAt { get; set; } = DateTime.Now;

        // Navigation properties
        [ForeignKey("EventId")]
        public virtual Event Event { get; set; } = null!;

        [ForeignKey("StoreId")]
        public virtual Store Store { get; set; } = null!;

        public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
    }
}
