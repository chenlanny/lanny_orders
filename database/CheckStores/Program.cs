using System;
using System.Data.SqlClient;
using System.Linq;

namespace CheckStores
{
    class Program
    {
        static void Main(string[] args)
        {
            string connectionString = "Server=192.168.207.52;Database=L_DBII;User Id=reyi;Password=ReyifmE;";
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                Console.WriteLine("=== 店家資料檢查 ===\n");
                
                string query = "SELECT StoreId, Name, Category, Phone, Address FROM Stores ORDER BY StoreId";
                
                using (SqlCommand cmd = new SqlCommand(query, conn))
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        int storeId = reader.GetInt32(0);
                        string name = reader.IsDBNull(1) ? "[NULL]" : reader.GetString(1);
                        string category = reader.IsDBNull(2) ? "[NULL]" : reader.GetString(2);
                        string phone = reader.IsDBNull(3) ? "[NULL]" : reader.GetString(3);
                        string address = reader.IsDBNull(4) ? "[NULL]" : reader.GetString(4);
                        
                        Console.WriteLine($"StoreId: {storeId}");
                        Console.WriteLine($"  名稱: {name}");
                        Console.WriteLine($"  分類: {category}");
                        Console.WriteLine($"  電話: {phone}");
                        Console.WriteLine($"  地址: {address}");
                        Console.WriteLine($"  名稱長度: {name.Length} 字元");
                        
                        // 顯示 Unicode 碼點
                        if (name.Length > 0 && name != "[NULL]")
                        {
                            Console.Write($"  Unicode: ");
                            foreach (char c in name.Take(10))
                            {
                                Console.Write($"U+{((int)c):X4} ");
                            }
                            Console.WriteLine();
                        }
                        Console.WriteLine();
                    }
                }
            }
        }
    }
}
