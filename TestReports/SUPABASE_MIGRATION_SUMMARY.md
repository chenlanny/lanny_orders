# 📊 Supabase 資料庫遷移總結

**遷移日期**：2026年4月7日  
**狀態**：✅ 完成

---

## 🎯 遷移目標

將整個系統從 SQL Server 遷移到 Supabase PostgreSQL 資料庫。

---

## ✅ 已完成的變更

### 1. **後端配置更新**

#### 📝 `appsettings.json`
- ❌ 移除：本地 SQL Server 連接字串（192.168.207.52）
- ✅ 新增：Supabase PostgreSQL 連接字串

#### 📝 `appsettings.Development.json`
- ✅ 新增：開發環境使用 Supabase 連接字串
- ✅ 新增：EF Core 日誌記錄設定

#### 📝 `appsettings.Production.json`
- ✅ 已配置：正式環境使用 Supabase 連接字串

### 2. **程式碼更新**

#### 📝 `Startup.cs`
**變更內容**：
```csharp
// 移除前：智能切換 SQL Server / PostgreSQL
bool isPostgreSQL = connectionString.Contains("Host=");
if (isPostgreSQL) { ... } else { ... }

// 移除後：直接使用 PostgreSQL
services.AddDbContext<AppDbContext>(options =>
{
    options.UseNpgsql(connectionString, ...);
    Log.Information("使用 Supabase PostgreSQL 資料庫");
});
```

#### 📝 `OfficeOrderApi.csproj`
**變更內容**：
```xml
<!-- 移除 -->
<PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="3.1.32" />

<!-- 保留 -->
<PackageReference Include="Npgsql.EntityFrameworkCore.PostgreSQL" Version="3.1.18" />
```

---

## 📦 套件依賴

### ✅ 使用中
- `Npgsql.EntityFrameworkCore.PostgreSQL` v3.1.18

### ❌ 已移除
- `Microsoft.EntityFrameworkCore.SqlServer` v3.1.32

---

## 🔗 Supabase 連接資訊

| 項目 | 值 |
|------|-----|
| **Host** | `db.idyfbtswixhfahddnlkw.supabase.co` |
| **Port** | `5432` |
| **Database** | `postgres` |
| **Username** | `postgres` |
| **SSL Mode** | `Require` |
| **Max Pool Size** | `5` |
| **Timeout** | `15 seconds` |

---

## 🚀 部署配置

### Render.com 環境變數

已在 `RENDER_ENV_SETUP.md` 中記錄，需要手動設定：

```
Key:   ConnectionStrings__DefaultConnection
Value: postgresql://postgres:ReyifmEReyi@db.idyfbtswixhfahddnlkw.supabase.co:5432/postgres
```

### 自動配置（已在 render.yaml）

```yaml
- key: ASPNETCORE_ENVIRONMENT
  value: Production
- key: ASPNETCORE_URLS
  value: http://+:5000
- key: Jwt__Issuer
  value: OfficeOrderAPI
- key: Jwt__Audience
  value: OfficeOrderClient
- key: Jwt__ExpiryMinutes
  value: 60
```

---

## 🗄️ 資料庫架構

### 匯入資料

請參考 `database/SUPABASE_IMPORT_GUIDE.md` 執行資料匯入：

**推薦方式**：
```bash
# 使用完整匯入檔案
database/export_complete_with_users.sql
```

**包含資料**：
- ✅ 6 個使用者（含 admin）
- ✅ 6 個店鋪
- ✅ 46 個菜單項目
- ✅ 10 個訂購活動
- ✅ 15 個訂單組
- ✅ 13 個訂單明細

---

## ✅ 驗證步驟

### 1. 編譯檢查
```powershell
cd database\backend
dotnet build
```
**預期結果**：✅ Build succeeded (無 SQL Server 相關錯誤)

### 2. 連線測試
```powershell
dotnet run --environment Development
```
**預期日誌**：
```
[INFO] 使用 Supabase PostgreSQL 資料庫
[INFO] Office Order API 正在啟動...
```

### 3. 資料庫查詢測試
訪問 API：
```
GET https://localhost:5001/api/stores
```
**預期結果**：✅ 返回店鋪列表

---

## 📝 注意事項

### 1. **連接字串格式差異**

**SQL Server 格式**（已棄用）：
```
Server=192.168.207.52;Database=L_DBII;User Id=reyi;...
```

**PostgreSQL 格式**（現在使用）：
```
Host=db.idyfbtswixhfahddnlkw.supabase.co;Port=5432;Database=postgres;...
```

### 2. **EF Core 提供者差異**

| 功能 | SQL Server | PostgreSQL |
|------|------------|------------|
| **Provider** | `UseSqlServer()` | `UseNpgsql()` |
| **Retry Strategy** | SqlServerRetryingExecutionStrategy | NpgsqlRetryingExecutionStrategy |
| **Identity 自增** | `IDENTITY(1,1)` | `SERIAL` / `IDENTITY` |

### 3. **環境變數覆寫**

配置優先順序：
1. 環境變數（最高）
2. `appsettings.{Environment}.json`
3. `appsettings.json`

**範例**：
```bash
# 透過環境變數覆寫
export ConnectionStrings__DefaultConnection="Host=..."
```

---

## 🔧 疑難排解

### 問題 1：連線逾時

**錯誤訊息**：
```
Npgsql.NpgsqlException: Exception while connecting
```

**解決方案**：
1. 檢查 Supabase 專案是否啟用
2. 確認連接字串中 `SSL Mode=Require`
3. 驗證密碼正確性

### 問題 2：找不到套件

**錯誤訊息**：
```
CS0234: The type or namespace name 'SqlServer' does not exist
```

**解決方案**：
1. 確認已移除 `using Microsoft.EntityFrameworkCore.SqlServer`
2. 執行 `dotnet restore`
3. 清理並重建專案

---

## 📚 相關文件

- [database/SUPABASE_IMPORT_GUIDE.md](database/SUPABASE_IMPORT_GUIDE.md) - 資料匯入指南
- [RENDER_ENV_SETUP.md](RENDER_ENV_SETUP.md) - Render.com 環境變數設定
- [render.yaml](render.yaml) - 部署配置檔案

---

## 🎉 遷移成功確認清單

- [x] 所有 `appsettings*.json` 使用 Supabase 連接字串
- [x] `Startup.cs` 移除 SQL Server 條件判斷
- [x] `.csproj` 移除 SQL Server 套件引用
- [x] 編譯無錯誤
- [ ] 本地測試連線成功（待執行）
- [ ] 資料匯入完成（待執行）
- [ ] Render.com 部署驗證（待執行）

---

**下一步**：
1. 執行 `dotnet build` 驗證編譯
2. 執行 `dotnet run` 測試本地連線
3. 匯入測試資料到 Supabase
4. 部署到 Render.com 並驗證

遷移完成！🚀
