using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using OfficeOrderApi.Data;

namespace TestEFCore
{
    class Program
    {
        static void Main(string[] args)
        {
            // 設定連接字串
            string connectionString = "Server=192.168.207.52;Database=L_DBII;User Id=reyi;Password=ReyifmE;TrustServerCertificate=True;Encrypt=False;";
            
            var options = new DbContextOptionsBuilder<AppDbContext>()
                .UseSqlServer(connectionString)
                .Options;
            
            using (var context = new AppDbContext(options))
            {
                Console.WriteLine("=== 使用 Entity Framework Core 查詢店家 ===\n");
                
                var stores = context.Stores.ToList();
                
                Console.WriteLine($"總共找到 {stores.Count} 個店家\n");
                
                foreach (var store in stores)
                {
                    Console.WriteLine($"StoreId: {store.StoreId}");
                    Console.WriteLine($"  Name: '{store.Name}' (長度: {store.Name?.Length ?? 0})");
                    Console.WriteLine($"  Category: {store.Category}");
                    Console.WriteLine($"  Phone: {store.Phone}");
                    Console.WriteLine($"  Address: {store.Address}");
                    
                    // 顯示 Name 的 Unicode
                    if (!string.IsNullOrEmpty(store.Name))
                    {
                        Console.Write($"  Name Unicode: ");
                        foreach (char c in store.Name.Take(10))
                        {
                            Console.Write($"U+{((int)c):X4} ");
                        }
                        Console.WriteLine();
                    }
                    Console.WriteLine();
                }
            }
            
            Console.WriteLine("完成！");
        }
    }
}
