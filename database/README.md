# 資料庫建立指引

## 伺服器資訊

- **伺服器：** 192.168.207.52
- **帳號：** reyi
- **密碼：** ReyifmE
- **資料庫名稱：** L_DBII

## 快速開始

### 方法 1：使用批次檔（最簡單）

1. 執行 `execute.bat`
2. 選擇選項 4「執行完整建置」
3. 等待完成

### 方法 2：手動執行 SQL 腳本

```bash
# 1. 建立資料庫
sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -i create-database.sql

# 2. 建立資料表結構
sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -d L_DBII -i create-full-schema.sql

# 3. 插入測試資料
sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -d L_DBII -i seed-data.sql
```

### 方法 3：使用 PowerShell

```powershell
# 測試連線
sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -Q "SELECT @@VERSION"

# 完整建置
Get-Content create-database.sql | sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE
Get-Content create-full-schema.sql | sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -d L_DBII
Get-Content seed-data.sql | sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -d L_DBII
```

## 連線字串

### ASP.NET Core (appsettings.json)

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=192.168.207.52;Database=L_DBII;User Id=reyi;Password=ReyifmE;TrustServerCertificate=True;Encrypt=False;"
  }
}
```

### Entity Framework Core (DbContext)

```csharp
protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
{
    optionsBuilder.UseSqlServer(
        "Server=192.168.207.52;Database=L_DBII;User Id=reyi;Password=ReyifmE;TrustServerCertificate=True;Encrypt=False;"
    );
}
```

## 資料庫結構

### 資料表清單

1. **Users** - 使用者
2. **Stores** - 店家
3. **MenuItems** - 菜單品項（支援尺寸定價、客製化選項）
4. **Events** - 揪團活動
5. **OrderGroups** - 各店訂單群組
6. **OrderItems** - 訂單項目（支援加料）
7. **Notifications** - 通知紀錄

### 檢視

- **vw_OrderSummary** - 分帳明細檢視

## 測試資料

### 測試帳號

| 角色 | Email | 密碼 | 部門 |
|------|-------|------|------|
| 管理員 | admin@company.com | password123 | 管理部 |
| 一般使用者 | wang@company.com | password123 | 業務部 |
| 一般使用者 | lee@company.com | password123 | 研發部 |

### 測試店家

- 50嵐（4 項飲料）
- 清心福全（2 項飲料）
- 池上便當（4 項便當）
- 悟饕便當（3 項便當）

## 驗證資料庫

```sql
-- 檢查資料庫是否存在
SELECT name FROM sys.databases WHERE name = 'L_DBII';

-- 檢查資料表
USE L_DBII;
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';

-- 統計資料數量
SELECT 'Users' AS [Table], COUNT(*) AS [Count] FROM Users
UNION ALL
SELECT 'Stores', COUNT(*) FROM Stores
UNION ALL
SELECT 'MenuItems', COUNT(*) FROM MenuItems;
```

## 常見問題

### Q: 無法連線到伺服器？

**A:** 檢查以下項目：
1. 伺服器 IP 是否正確（192.168.207.52）
2. SQL Server 是否啟用 TCP/IP 連線
3. 防火牆是否開放 1433 埠
4. 帳號密碼是否正確

### Q: 資料庫已存在？

**A:** 執行以下 SQL 刪除舊資料庫：
```sql
USE master;
ALTER DATABASE L_DBII SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE L_DBII;
```

### Q: 權限不足？

**A:** 確認帳號 `reyi` 擁有建立資料庫的權限：
```sql
-- 以 sa 帳號執行
ALTER LOGIN reyi WITH DEFAULT_DATABASE = master;
ALTER SERVER ROLE sysadmin ADD MEMBER reyi;
```

## 檔案說明

| 檔案 | 說明 |
|------|------|
| create-database.sql | 建立 L_DBII 資料庫 |
| create-full-schema.sql | 建立所有資料表和檢視 |
| seed-data.sql | 插入測試資料 |
| execute.bat | 批次執行工具（互動式選單）|
| README.md | 本說明文件 |

## 下一步

資料庫建立完成後：

1. 更新後端專案的連線字串
2. 執行 `dotnet ef migrations add InitialCreate`
3. 測試 API 連線
4. 開始開發功能

## 支援

如有問題，請聯絡專案負責人。
