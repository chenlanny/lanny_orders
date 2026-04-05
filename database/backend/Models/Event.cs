using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OfficeOrderApi.Models
{
    [Table("Events")]
    public class Event
    {
        [Key]
        public int EventId { get; set; }

        [Required]
        [StringLength(100)]
        public string Title { get; set; } = string.Empty;

        [Required]
        public int InitiatorId { get; set; }

        [StringLength(20)]
        public string Status { get; set; } = "Open";

        public DateTime CreatedAt { get; set; } = DateTime.Now;

        public DateTime? ClosedAt { get; set; }

        public DateTime? DeliveredAt { get; set; }

        [StringLength(500)]
        public string? Notes { get; set; }

        [StringLength(20)]
        public string? OrderType { get; set; }

        public DateTime? Deadline { get; set; }

        [Column(TypeName = "decimal(10, 2)")]
        public decimal DeliveryFee { get; set; } = 0;

        // Navigation properties
        [ForeignKey("InitiatorId")]
        public virtual User Initiator { get; set; } = null!;
        public virtual ICollection<OrderGroup> OrderGroups { get; set; } = new List<OrderGroup>();
    }
}
