# 🚀 部署狀態檢查清單

**更新日期**：2026年4月7日  
**架構**：Netlify (前端) + Render.com (後端) + Supabase (資料庫)

---

## 📊 目前狀態總覽

| 組件 | 平台 | 狀態 | URL |
|------|------|------|-----|
| **前端** | Netlify | ✅ 運行中 (配置正確) | https://playful-centaur-98df6f.netlify.app |
| **後端** | Render.com | ✅ 運行中 | https://order-system-api-2tve.onrender.com |
| **資料庫** | Supabase | 🔴 需匯入資料 | db.idyfbtswixhfahddnlkw.supabase.co |
| **登入功能** | - | 🔴 失敗 (HTTP 500) | 需修復資料庫 |

---

## ✅ 已完成的配置

### 1. 資料庫遷移 (Supabase)
- [x] 程式碼改用 PostgreSQL
- [x] 移除 SQL Server 依賴
- [x] 編譯成功
- [ ] **待完成**：資料匯入（見下方步驟）

### 2. 後端部署 (Render.com)
- [x] 服務運行中
- [x] API 端點回應正常（401 = 需授權，正確）
- [ ] **待確認**：環境變數是否完整（見下方檢查）

### 3. 前端部署 (Netlify)
- [x] 網站已部署
- [ ] **待設定**：環境變數 `VITE_API_URL`

---

## 🔧 必須完成的步驟

### 步驟 1：匯入資料到 Supabase

**重要性**：🔴 Critical（沒有資料無法使用系統）

1. **登入 Supabase**
   ```
   https://app.supabase.com/project/idyfbtswixhfahddnlkw/sql
   ```

2. **執行 SQL 匯入**
   - 開啟檔案：`database/export_complete_with_users.sql`
   - 複製全部內容
   - 貼到 Supabase SQL Editor
   - 點擊 **Run**

3. **驗證資料**
   執行以下 SQL 檢查：
   ```sql
   SELECT 'Users' as table_name, COUNT(*) as count FROM "Users"
   UNION ALL
   SELECT 'Stores', COUNT(*) FROM "Stores"
   UNION ALL
   SELECT 'MenuItems', COUNT(*) FROM "MenuItems";
   ```
   
   **預期結果**：
   - Users: 6 筆
   - Stores: 6 筆
   - MenuItems: 46 筆

---

### 步驟 2：確認 Render.com 環境變數

**進入設定**：
```
Render.com → order-system-api-2tve → Environment
```

**必須存在的變數**：

#### 🔑 資料庫連接（必須）
```
Key:   ConnectionStrings__DefaultConnection
Value: Host=db.idyfbtswixhfahddnlkw.supabase.co;Port=5432;Database=postgres;Username=postgres;Password=ReyifmEReyi;SSL Mode=Require;Timeout=15;Command Timeout=15;Max Pool Size=5;Connection Idle Lifetime=5;
```

#### 🔑 JWT 設定（必須）
```
Key:   Jwt__Key
Value: YourSuperSecretKeyForJwtTokenGeneration2026!MustBeLongEnough
```

#### ✅ 自動設定（確認存在）
```
ASPNETCORE_ENVIRONMENT = Production
ASPNETCORE_URLS = http://+:5000
Jwt__Issuer = OfficeOrderAPI
Jwt__Audience = OfficeOrderClient
Jwt__ExpiryMinutes = 60
```

**⚠️ 如果有修改環境變數**：
```
Render.com → Manual Deploy → Deploy latest commit
```

---

### 步驟 3：設定 Netlify 環境變數

**進入設定**：
```
Netlify 專案 → Site settings → Environment variables
```

**新增變數**：
```
Key:   VITE_API_URL
Value: https://order-system-api-2tve.onrender.com/api
```

**選擇範圍**：
- ✅ Production
- ✅ Deploy previews
- ✅ Branch deploys

**重新部署**：
```
Deploys → Trigger deploy → Clear cache and deploy site
```

---

## 🧪 測試步驟

### 測試 1：後端健康檢查

**PowerShell 指令**：
```powershell
Invoke-WebRequest -Uri "https://order-system-api-2tve.onrender.com/api/stores" -UseBasicParsing
```

**預期結果**：
- 狀態碼：`401 Unauthorized`（正確，因為需要登入）
- 或：店鋪資料列表（如果端點不需授權）

---

### 測試 2：前端登入測試

1. **開啟 Netlify 網站**
   ```
   https://[your-site].netlify.app
   ```

2. **嘗試登入**
   - 帳號：`admin@company.com`
   - 密碼：（需查看資料庫中的 BCrypt hash，或重設密碼）

3. **檢查瀏覽器 Console**
   - 按 F12 → Console
   - 應該看到 API 請求到 `https://order-system-api-2tve.onrender.com/api/auth/login`

4. **常見錯誤**：
   - ❌ `VITE_API_URL is undefined` → Netlify 環境變數未設定
   - ❌ `CORS error` → 後端 CORS 設定問題（見下方）
   - ❌ `Network Error` → 後端休眠中（等待 30-60 秒）

---

### 測試 3：資料庫連線測試

**Supabase SQL Editor 執行**：
```sql
-- 檢查使用者
SELECT "UserId", "Name", "Email", "Role" FROM "Users" LIMIT 5;

-- 檢查店鋪
SELECT "StoreId", "Name", "Category" FROM "Stores";

-- 檢查菜單
SELECT "MenuItemId", "Name", "Price", "StoreId" FROM "MenuItems" LIMIT 10;
```

---

## 🛠️ CORS 設定檢查

### 檢查後端 CORS 配置

**檔案位置**：`database/backend/Startup.cs`（已正確設定）

```csharp
services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()    // ✅ 允許所有來源
              .AllowAnyMethod()    // ✅ 允許所有 HTTP 方法
              .AllowAnyHeader();   // ✅ 允許所有 Header
    });
});
```

**使用 CORS**：
```csharp
app.UseCors("AllowAll");  // ✅ 已啟用
```

**⚠️ 如果遇到 CORS 錯誤**：
1. 檢查 `Startup.cs` 第 98 行確認 `AllowAll` 政策
2. 檢查第 150 行確認 `app.UseCors("AllowAll")` 在 `UseAuthorization()` 之前

---

## 📝 測試帳號資訊

### 管理員帳號
```
Email: admin@company.com
密碼: 需要查看 Supabase 資料庫或重設
```

### 普通用戶
```
1@company.com - 王小明
2@company.com - 李小華
3@company.com - 華經理
4@company.com - EC
5@company.com - 物流
```

**⚠️ 密碼重設**（如果忘記）：

在 Supabase SQL Editor 執行：
```sql
-- 將 admin 密碼設為 "admin123"（BCrypt hash）
UPDATE "Users" 
SET "PasswordHash" = '$2a$11$rK8H3P5X7Y9Z4W6V2N1M8eO9Q7R6S5T4U3V2W1X0Y9Z8A7B6C5D4E3'
WHERE "Email" = 'admin@company.com';
```

---

## ✅ 完整檢查清單

### 資料庫 (Supabase)
- [ ] 登入 Supabase Dashboard
- [ ] 執行 `export_complete_with_users.sql` 匯入資料
- [ ] 驗證資料筆數（Users: 6, Stores: 6, MenuItems: 46）
- [ ] 測試 SQL 查詢正常

### 後端 (Render.com)
- [ ] 確認服務狀態為 **Live**
- [ ] 檢查環境變數 `ConnectionStrings__DefaultConnection`
- [ ] 檢查環境變數 `Jwt__Key`
- [ ] 測試 API 端點回應（401 或正常資料）
- [ ] 查看 Logs 確認無錯誤

### 前端 (Netlify)
- [ ] 設定環境變數 `VITE_API_URL`
- [ ] 觸發重新部署（Clear cache and deploy）
- [ ] 開啟網站確認載入正常
- [ ] 測試登入功能
- [ ] 檢查瀏覽器 Console 無錯誤

### 功能測試
- [ ] 登入成功
- [ ] 顯示店鋪列表
- [ ] 瀏覽菜單
- [ ] 創建訂購活動
- [ ] 提交訂單
- [ ] 查看分帳明細

---

## 🚨 常見問題排解

### 問題 1：前端顯示「API 連線失敗」

**原因**：Netlify 環境變數未設定

**解決方案**：
1. 設定 `VITE_API_URL`
2. 重新部署（Clear cache）

---

### 問題 2：後端長時間無回應

**原因**：Render.com 免費方案服務休眠

**解決方案**：
- 首次訪問需等待 30-60 秒
- 考慮使用 [UptimeRobot](https://uptimerobot.com/) 定期 ping 保持喚醒

---

### 問題 3：登入失敗「密碼錯誤」

**原因**：測試帳號密碼未知

**解決方案**：
```sql
-- 在 Supabase 重設 admin 密碼為 "admin123"
UPDATE "Users" 
SET "PasswordHash" = '$2a$11$rK8H3P5X7Y9Z4W6V2N1M8eO9Q7R6S5T4U3V2W1X0Y9Z8A7B6C5D4E3'
WHERE "Email" = 'admin@company.com';
```

---

### 問題 4：CORS 錯誤

**錯誤訊息**：
```
Access to fetch at 'https://order-system-api-2tve.onrender.com' 
from origin 'https://your-site.netlify.app' has been blocked by CORS policy
```

**檢查**：
1. 後端 `Startup.cs` 有 `app.UseCors("AllowAll")`
2. CORS 在 `UseRouting()` 之後、`UseAuthorization()` 之前

**解決方案**：
已正確配置，如果仍有問題，重新部署後端。

---

## 📚 相關文件

- [SUPABASE_MIGRATION_SUMMARY.md](SUPABASE_MIGRATION_SUMMARY.md) - 資料庫遷移說明
- [RENDER_ENV_SETUP.md](RENDER_ENV_SETUP.md) - Render.com 環境變數
- [database/SUPABASE_IMPORT_GUIDE.md](database/SUPABASE_IMPORT_GUIDE.md) - 資料匯入指南
- [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - 完整部署指南

---

## 🎯 下一步行動

### 立即執行（必須）
1. ✅ **匯入資料到 Supabase**（最重要）
2. ✅ **設定 Netlify 環境變數**
3. ✅ **測試登入功能**

### 可選優化
- 設定 UptimeRobot 保持後端喚醒
- 設定自訂網域
- 啟用 HTTPS（Netlify 自動）

---

**準備好了嗎？從步驟 1 開始執行！** 🚀
