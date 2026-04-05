using Microsoft.EntityFrameworkCore;
using OfficeOrderApi.Models;

namespace OfficeOrderApi.Data
{
    public class AppDbContext : DbContext
    {
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
    }

    public DbSet<User> Users { get; set; } = null!;
    public DbSet<Store> Stores { get; set; } = null!;
    public DbSet<MenuItem> MenuItems { get; set; } = null!;
    public DbSet<Event> Events { get; set; } = null!;
    public DbSet<OrderGroup> OrderGroups { get; set; } = null!;
    public DbSet<OrderItem> OrderItems { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Configure relationships
        modelBuilder.Entity<MenuItem>()
            .HasOne(m => m.Store)
            .WithMany(s => s.MenuItems)
            .HasForeignKey(m => m.StoreId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<Event>()
            .HasOne(e => e.Initiator)
            .WithMany(u => u.InitiatedEvents)
            .HasForeignKey(e => e.InitiatorId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<OrderGroup>()
            .HasOne(og => og.Event)
            .WithMany(e => e.OrderGroups)
            .HasForeignKey(og => og.EventId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<OrderGroup>()
            .HasOne(og => og.Store)
            .WithMany(s => s.OrderGroups)
            .HasForeignKey(og => og.StoreId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<OrderItem>()
            .HasOne(oi => oi.OrderGroup)
            .WithMany(og => og.OrderItems)
            .HasForeignKey(oi => oi.GroupId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<OrderItem>()
            .HasOne(oi => oi.User)
            .WithMany(u => u.OrderItems)
            .HasForeignKey(oi => oi.UserId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<OrderItem>()
            .HasOne(oi => oi.MenuItem)
            .WithMany(mi => mi.OrderItems)
            .HasForeignKey(oi => oi.ItemId)
            .OnDelete(DeleteBehavior.Restrict);

        // Configure indexes
        modelBuilder.Entity<User>()
            .HasIndex(u => u.Email)
            .IsUnique();

        modelBuilder.Entity<Store>()
            .HasIndex(s => s.Category);

        modelBuilder.Entity<MenuItem>()
            .HasIndex(m => m.StoreId);

        modelBuilder.Entity<Event>()
            .HasIndex(e => e.Status);

        modelBuilder.Entity<Event>()
            .HasIndex(e => e.CreatedAt);

        modelBuilder.Entity<OrderGroup>()
            .HasIndex(og => og.EventId);

        modelBuilder.Entity<OrderItem>()
            .HasIndex(oi => oi.GroupId);

        modelBuilder.Entity<OrderItem>()
            .HasIndex(oi => oi.UserId);

        // Configure Unicode for string properties (fix Chinese encoding issue)
        modelBuilder.Entity<Store>()
            .Property(s => s.Name)
            .IsUnicode(true)
            .HasMaxLength(100);

        modelBuilder.Entity<Store>()
            .Property(s => s.Category)
            .IsUnicode(true)
            .HasMaxLength(50);

        modelBuilder.Entity<Store>()
            .Property(s => s.Phone)
            .IsUnicode(true)
            .HasMaxLength(20);

        modelBuilder.Entity<Store>()
            .Property(s => s.Address)
            .IsUnicode(true)
            .HasMaxLength(200);

        modelBuilder.Entity<MenuItem>()
            .Property(m => m.Name)
            .IsUnicode(true)
            .HasMaxLength(100);

        modelBuilder.Entity<MenuItem>()
            .Property(m => m.Category)
            .IsUnicode(true)
            .HasMaxLength(50);

        modelBuilder.Entity<MenuItem>()
            .Property(m => m.PriceRules)
            .IsUnicode(true);

        modelBuilder.Entity<MenuItem>()
            .Property(m => m.Options)
            .IsUnicode(true);

        modelBuilder.Entity<User>()
            .Property(u => u.Name)
            .IsUnicode(true)
            .HasMaxLength(100);

        modelBuilder.Entity<User>()
            .Property(u => u.Department)
            .IsUnicode(true)
            .HasMaxLength(100);

        modelBuilder.Entity<Event>()
            .Property(e => e.Title)
            .IsUnicode(true)
            .HasMaxLength(100);

        modelBuilder.Entity<Event>()
            .Property(e => e.Notes)
            .IsUnicode(true)
            .HasMaxLength(500);
    }
    }
}
