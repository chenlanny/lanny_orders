using System;
using System.Data.SqlClient;

namespace FixStores
{
    class Program
    {
        static void Main(string[] args)
        {
            string connectionString = "Server=192.168.207.52;Database=L_DBII;User Id=reyi;Password=ReyifmE;";
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                Console.WriteLine("=== 修正店家資料 ===\n");
                
                // 刪除 StoreId 5（測試用店家）
                Console.WriteLine("1. 檢查 StoreId 5 是否有相關訂單...");
                string checkOrdersSql = "SELECT COUNT(*) FROM OrderGroups WHERE StoreId = 5";
                using (SqlCommand checkCmd = new SqlCommand(checkOrdersSql, conn))
                {
                    int orderCount = (int)checkCmd.ExecuteScalar();
                    if (orderCount > 0)
                    {
                        Console.WriteLine($"   ⚠ StoreId 5 有 {orderCount} 筆訂單，無法刪除");
                    }
                    else
                    {
                        Console.WriteLine("   ✓ StoreId 5 無訂單，可以刪除");
                        
                        // 先刪除菜單項目
                        string deleteMenuSql = "DELETE FROM MenuItems WHERE StoreId = 5";
                        using (SqlCommand deleteMenuCmd = new SqlCommand(deleteMenuSql, conn))
                        {
                            int menuDeleted = deleteMenuCmd.ExecuteNonQuery();
                            Console.WriteLine($"   已刪除 {menuDeleted} 個菜單項目");
                        }
                        
                        // 刪除店家
                        string deleteStoreSql = "DELETE FROM Stores WHERE StoreId = 5";
                        using (SqlCommand deleteStoreCmd = new SqlCommand(deleteStoreSql, conn))
                        {
                            deleteStoreCmd.ExecuteNonQuery();
                            Console.WriteLine("   ✓ 已刪除 StoreId 5\n");
                        }
                    }
                }
                
                // 更新 StoreId 6 為迷克夏
                Console.WriteLine("2. 更新 StoreId 6 為迷克夏...");
                string updateSql = @"UPDATE Stores 
                                    SET Name = @Name, 
                                        Phone = @Phone, 
                                        Address = @Address 
                                    WHERE StoreId = 6";
                
                using (SqlCommand cmd = new SqlCommand(updateSql, conn))
                {
                    cmd.Parameters.AddWithValue("@Name", "迷克夏");
                    cmd.Parameters.AddWithValue("@Phone", "02-2345-6789");
                    cmd.Parameters.AddWithValue("@Address", "台北市大安區");
                    
                    int affected = cmd.ExecuteNonQuery();
                    Console.WriteLine($"   ✓ 已更新 {affected} 筆店家資料\n");
                }
                
                // 顯示最終結果
                Console.WriteLine("=== 更新後的店家清單 ===");
                string selectSql = "SELECT StoreId, Name, Category, Phone FROM Stores ORDER BY StoreId";
                using (SqlCommand cmd = new SqlCommand(selectSql, conn))
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Console.WriteLine($"{reader["StoreId"]}\t{reader["Name"]}\t{reader["Category"]}\t{reader["Phone"]}");
                    }
                }
            }
            
            Console.WriteLine("\n完成！");
        }
    }
}
