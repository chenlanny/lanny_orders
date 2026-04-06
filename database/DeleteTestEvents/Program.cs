using System;
using System.Data.SqlClient;

namespace DeleteTestEvents
{
    class Program
    {
        static void Main(string[] args)
        {
            // 連接字串（從 appsettings.json 複製）
            string connectionString = "Server=192.168.207.52;Database=L_DBII;User Id=reyi;Password=ReyifmE;TrustServerCertificate=True;Encrypt=False;";
            
            Console.WriteLine("正在連接資料庫...");
            
            try
            {
                using (var conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    Console.WriteLine("資料庫連接成功！\n");
                    
                    // 只刪除 EventId = 5（午夜快閃）
                    DeleteEvent(conn, 5, "午夜快閃");
                    
                    Console.WriteLine("\n測試資料已成功刪除！");
                    Console.WriteLine("EventId=6（快閃團）已保留。");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"錯誤: {ex.Message}");
            }
            
            Console.WriteLine("\n按任意鍵結束...");
            Console.ReadKey();
        }
        
        static void DeleteEvent(SqlConnection conn, int eventId, string title)
        {
            Console.WriteLine($"正在刪除活動: {title} (EventId={eventId})");
            
            try
            {
                // 刪除訂單項目
                string deleteItems = @"
                    DELETE FROM OrderItems 
                    WHERE GroupId IN (SELECT GroupId FROM OrderGroups WHERE EventId = @EventId)";
                using (var cmd = new SqlCommand(deleteItems, conn))
                {
                    cmd.Parameters.AddWithValue("@EventId", eventId);
                    int itemsDeleted = cmd.ExecuteNonQuery();
                    Console.WriteLine($"  - 已刪除 {itemsDeleted} 個訂單項目");
                }
                
                // 刪除訂單群組
                string deleteGroups = "DELETE FROM OrderGroups WHERE EventId = @EventId";
                using (var cmd = new SqlCommand(deleteGroups, conn))
                {
                    cmd.Parameters.AddWithValue("@EventId", eventId);
                    int groupsDeleted = cmd.ExecuteNonQuery();
                    Console.WriteLine($"  - 已刪除 {groupsDeleted} 個訂單群組");
                }
                
                // 刪除活動
                string deleteEvent = "DELETE FROM Events WHERE EventId = @EventId";
                using (var cmd = new SqlCommand(deleteEvent, conn))
                {
                    cmd.Parameters.AddWithValue("@EventId", eventId);
                    int eventsDeleted = cmd.ExecuteNonQuery();
                    Console.WriteLine($"  - 已刪除活動 (影響 {eventsDeleted} 筆記錄)\n");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"  錯誤: {ex.Message}\n");
            }
        }
    }
}
