using System;
using System.Data.SqlClient;

namespace InsertMilkshopMenu
{
    class Program
    {
        static void Main(string[] args)
        {
            string connectionString = "Server=192.168.207.52;Database=L_DBII;User Id=reyi;Password=ReyifmE;";
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                Console.WriteLine("資料庫連線成功");
                
                // 先刪除現有的迷克夏菜單項目
                using (SqlCommand deleteCmd = new SqlCommand("DELETE FROM MenuItems WHERE StoreId = 6", conn))
                {
                    int deleted = deleteCmd.ExecuteNonQuery();
                    Console.WriteLine($"已刪除 {deleted} 個舊項目");
                }
                
                // 定義菜單項目
                var menuItems = new[]
                {
                    new { Name = "迷克珍珠", Category = "珍奶系列", PriceRules = "{\"小杯\":45,\"中杯\":50,\"大杯\":60}", Options = "{\"sweetness\":[\"正常\",\"少糖\",\"半糖\",\"微糖\",\"無糖\"],\"temperature\":[\"正常冰\",\"少冰\",\"微冰\",\"去冰\",\"溫\",\"熱\"],\"toppings\":[{\"name\":\"珍珠\",\"price\":0},{\"name\":\"椰果\",\"price\":5}]}" },
                    new { Name = "迷克奶茶", Category = "奶茶系列", PriceRules = "{\"小杯\":40,\"中杯\":45,\"大杯\":55}", Options = "{\"sweetness\":[\"正常\",\"少糖\",\"半糖\",\"微糖\",\"無糖\"],\"temperature\":[\"正常冰\",\"少冰\",\"微冰\",\"去冰\",\"溫\",\"熱\"],\"toppings\":[{\"name\":\"珍珠\",\"price\":10},{\"name\":\"椰果\",\"price\":5}]}" },
                    new { Name = "觀音拿鐵", Category = "拿鐵系列", PriceRules = "{\"中杯\":55,\"大杯\":65}", Options = "{\"sweetness\":[\"正常\",\"少糖\",\"半糖\",\"微糖\",\"無糖\"],\"temperature\":[\"正常冰\",\"少冰\",\"微冰\",\"去冰\",\"溫\",\"熱\"],\"toppings\":[{\"name\":\"珍珠\",\"price\":10}]}" },
                    new { Name = "烏龍奶茶", Category = "奶茶系列", PriceRules = "{\"小杯\":40,\"中杯\":45,\"大杯\":55}", Options = "{\"sweetness\":[\"正常\",\"少糖\",\"半糖\",\"微糖\",\"無糖\"],\"temperature\":[\"正常冰\",\"少冰\",\"微冰\",\"去冰\",\"溫\",\"熱\"],\"toppings\":[{\"name\":\"珍珠\",\"price\":10}]}" },
                    new { Name = "紅茶拿鐵", Category = "拿鐵系列", PriceRules = "{\"中杯\":50,\"大杯\":60}", Options = "{\"sweetness\":[\"正常\",\"少糖\",\"半糖\",\"微糖\",\"無糖\"],\"temperature\":[\"正常冰\",\"少冰\",\"微冰\",\"去冰\",\"溫\",\"熱\"],\"toppings\":[{\"name\":\"珍珠\",\"price\":10}]}" },
                    new { Name = "綠茶拿鐵", Category = "拿鐵系列", PriceRules = "{\"中杯\":50,\"大杯\":60}", Options = "{\"sweetness\":[\"正常\",\"少糖\",\"半糖\",\"微糖\",\"無糖\"],\"temperature\":[\"正常冰\",\"少冰\",\"微冰\",\"去冰\",\"溫\",\"熱\"]}" },
                    new { Name = "冬瓜檸檬", Category = "果茶系列", PriceRules = "{\"中杯\":45,\"大杯\":55}", Options = "{\"sweetness\":[\"正常\",\"少糖\",\"微糖\"],\"temperature\":[\"正常冰\",\"少冰\",\"微冰\",\"去冰\"]}" },
                    new { Name = "金萱青茶", Category = "茶飲系列", PriceRules = "{\"中杯\":30,\"大杯\":35,\"瓶裝\":40}", Options = "{\"sweetness\":[\"正常\",\"少糖\",\"半糖\",\"微糖\",\"無糖\"],\"temperature\":[\"正常冰\",\"少冰\",\"微冰\",\"去冰\",\"溫\",\"熱\"]}" },
                    new { Name = "茉莉綠茶", Category = "茶飲系列", PriceRules = "{\"中杯\":25,\"大杯\":30,\"瓶裝\":35}", Options = "{\"sweetness\":[\"正常\",\"少糖\",\"半糖\",\"微糖\",\"無糖\"],\"temperature\":[\"正常冰\",\"少冰\",\"微冰\",\"去冰\",\"溫\",\"熱\"]}" },
                    new { Name = "蜂蜜檸檬", Category = "果茶系列", PriceRules = "{\"中杯\":50,\"大杯\":60}", Options = "{\"sweetness\":[\"正常\",\"少糖\"],\"temperature\":[\"正常冰\",\"少冰\",\"微冰\",\"去冰\"]}" }
                };
                
                // 插入每個菜單項目
                string insertSql = @"INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable)
                                    VALUES (@StoreId, @Name, @Category, @PriceRules, @Options, @IsAvailable)";
                
                int count = 0;
                foreach (var item in menuItems)
                {
                    using (SqlCommand cmd = new SqlCommand(insertSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@StoreId", 6);
                        cmd.Parameters.AddWithValue("@Name", item.Name);
                        cmd.Parameters.AddWithValue("@Category", item.Category);
                        cmd.Parameters.AddWithValue("@PriceRules", item.PriceRules);
                        cmd.Parameters.AddWithValue("@Options", item.Options);
                        cmd.Parameters.AddWithValue("@IsAvailable", true);
                        
                        cmd.ExecuteNonQuery();
                        count++;
                        Console.WriteLine($"✓ 已插入: {item.Name}");
                    }
                }
                
                Console.WriteLine($"\n總共插入 {count} 個菜單項目");
                
                // 查詢確認
                Console.WriteLine("\n=== 查詢結果確認 ===");
                using (SqlCommand selectCmd = new SqlCommand("SELECT ItemId, Name, Category FROM MenuItems WHERE StoreId = 6 ORDER BY ItemId", conn))
                using (SqlDataReader reader = selectCmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Console.WriteLine($"{reader["ItemId"]}\t{reader["Name"]}\t{reader["Category"]}");
                    }
                }
            }
            
            Console.WriteLine("\n完成！");
        }
    }
}
