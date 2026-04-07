# 🔴 500 登入錯誤 - 問題診斷

## 根本原因可能

### 1️⃣ **最可能：資料庫連接失敗**
appsettings.json 中的密碼是硬編碼：
```
Password=ReyifmEReyi
```

在 Render.com 環境中：
- 硬編碼密碼可能已過期或無效
- Supabase 可能已更改密碼
- 需要透過環境變數覆蓋

---

## 🛠️ 立即修復步驟

### 步驟 1：在 Render.com Dashboard 中檢查環境變數

**進入流程：**
1. Render Dashboard → **order-system-api** → **Environment**
2. 尋找以下環境變數並記錄值：
   ```
   ConnectionStrings__DefaultConnection
   Jwt__Key
   Jwt__Issuer
   Jwt__Audience
   ```

### 步驟 2：取得最新 Supabase 連接字串

1. 登入 Supabase Dashboard
2. 專案 → **Settings** → **Database** → **Connection String**
3. 複製 **PostgreSQL** 版本的連接字串
4. 確保包含最新密碼

### 步驟 3：更新 Render.com 環境變數

**修改連接字串格式**：
```
ConnectionStrings__DefaultConnection=Host=db.idyfbtswixhfahddnlkw.supabase.co;Port=5432;Database=postgres;Username=postgres;Password=<LATEST_PASSWORD>;SSL Mode=Require;Timeout=15;Command Timeout=15;Max Pool Size=5;Connection Idle Lifetime=5;
```

### 步驟 4：重新部署

Render Dashboard → **order-system-api** → **Redeploy** → **Clear Build Cache & Deploy**

---

## 📝 請告訴我：

1. **Render.com Environment 中目前的 `ConnectionStrings__DefaultConnection` 值是什麼？**
   - 尤其是 `Password=` 部分後面的值

2. **Logs 中 08:45:29 前後有沒有看到以下關鍵字？**
   ```
   Npgsql
   Database
   Connection
   Timeout
   failed to connect
   ```

3. **能否複製 Logs 中完整的異常堆棧？** 
   （不只是 "登入失敗" 這一行）

---

## 🐛 更詳細的除錯

如果仍有問題，請執行以下檢查：

### A. 驗證 Supabase 密碼是否正確
```powershell
# 測試 Supabase 連接
$connectionString = "Host=db.idyfbtswixhfahddnlkw.supabase.co;Port=5432;Database=postgres;Username=postgres;Password=ReyifmEReyi;SSL Mode=Require;"
# 用 psql 或其他 PostgreSQL 工具測試
```

### B. 檢查 Render.com 是否能訪問 Supabase
- Supabase 可能有 IP 白名單限制
- 需要檢查 Supabase Database Settings 中的網路設定

### C. 查看更詳細的 Logs

在 Render.com Logs 中搜尋：
- `Exception:`  
- `NpgsqlException:`
- `Connection timeout`
- `failed to connect`

---

## 📍 下一步

請提供 Render.com Environment 中的 **ConnectionStrings__DefaultConnection** 的值，我會協助驗證並修復！
