# 登入問題診斷報告

**診斷日期**: 2026年4月7日  
**問題狀態**: 🔴 Critical - 無法登入  
**錯誤訊息**: "伺服器錯誤" (HTTP 500)

---

## 📊 診斷結果摘要

### ✅ 正常項目
1. **後端 API 運行正常** - https://order-system-api-2tve.onrender.com 可訪問
2. **前端網站正常** - https://playful-centaur-98df6f.netlify.app 可訪問  
3. **前端配置正確** - .env.production 已正確設定 VITE_API_URL

### ❌ 異常項目
1. **登入 API 返回 500 錯誤** - POST /api/auth/login 失敗
2. **後端內部錯誤** - 可能是資料庫連線或查詢失敗

---

## 🔍 根本原因分析

根據測試結果，**最可能的原因是**：

### 問題 1: Supabase 資料庫沒有匯入使用者資料 (90% 機率)

**症狀**:
- 登入 API 返回 500 錯誤
- 錯誤發生在 `AuthService.LoginAsync()` 查詢用戶時

**證據**:
- 資料匯入檔案存在: `database/export_complete_with_users.sql`
- 但可能尚未執行到 Supabase

**驗證方法**:
```sql
-- 在 Supabase SQL Editor 執行
SELECT COUNT(*) FROM "Users";
SELECT * FROM "Users" WHERE "Email" = 'admin@company.com';
```

**預期結果**:
- 如果返回 0 或錯誤 → 確認是此問題
- 如果返回 6 筆使用者 → 排除此問題，繼續檢查下一個

---

### 問題 2: Render.com 資料庫連接字串錯誤 (8% 機率)

**症狀**:
- 後端無法連接到 Supabase
- 環境變數配置不正確

**驗證方法**:
1. 進入 Render.com Dashboard
2. 查看 order-system-api-2tve → Logs
3. 尋找錯誤訊息，例如:
   - "Connection timeout"
   - "Authentication failed"
   - "Database does not exist"

**檢查項目**:
- `ConnectionStrings__DefaultConnection` 是否存在
- 連接字串格式是否正確
- Supabase 密碼是否正確

---

### 問題 3: 前端打包時未使用生產環境變數 (2% 機率)

**症狀**:
- 前端請求仍然指向 localhost

**驗證方法**:
1. 開啟 https://playful-centaur-98df6f.netlify.app
2. 按 F12 開啟開發者工具 → Network
3. 嘗試登入
4. 查看請求的 URL

**預期結果**:
- ✅ 正確: `https://order-system-api-2tve.onrender.com/api/auth/login`
- ❌ 錯誤: `http://localhost:5000/api/auth/login`

---

## 🔧 解決方案

### 解決方案 1: 匯入資料到 Supabase (建議優先執行)

#### Step 1: 登入 Supabase
```
URL: https://app.supabase.com/project/idyfbtswixhfahddnlkw/sql
```

#### Step 2: 執行資料匯入
1. 開啟檔案: `database/export_complete_with_users.sql`
2. 複製全部內容 (約 400 行)
3. 貼到 Supabase SQL Editor
4. 點擊 **Run** 按鈕

#### Step 3: 驗證資料
```sql
-- 檢查使用者數量
SELECT COUNT(*) FROM "Users";  -- 應該返回 6

-- 檢查管理員帳號
SELECT "UserId", "Email", "Name", "Role" 
FROM "Users" 
WHERE "Email" = 'admin@company.com';

-- 檢查店鋪數量
SELECT COUNT(*) FROM "Stores";  -- 應該返回 6

-- 檢查菜單數量
SELECT COUNT(*) FROM "MenuItems";  -- 應該返回 46
```

#### Step 4: 重新測試登入
在 PowerShell 執行:
```powershell
cd D:\github\ORDERS\A_order

$body = @{
    email = "admin@company.com"
    password = "admin123"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://order-system-api-2tve.onrender.com/api/auth/login" `
    -Method Post `
    -Body $body `
    -ContentType "application/json"
```

**預期結果**: 返回 JWT token 和使用者資訊

---

### 解決方案 2: 檢查並修復 Render.com 配置

#### Step 1: 查看後端 Logs
1. 進入 https://dashboard.render.com
2. 選擇 `order-system-api-2tve`
3. 點擊 **Logs** 標籤
4. 查看最近的錯誤訊息

#### Step 2: 檢查環境變數
進入 `order-system-api-2tve` → **Environment** 標籤

**必須存在的變數**:
```
ConnectionStrings__DefaultConnection
= Host=db.idyfbtswixhfahddnlkw.supabase.co;Port=5432;Database=postgres;Username=postgres;Password=ReyifmEReyi;SSL Mode=Require;Timeout=15;Command Timeout=15;Max Pool Size=5;Connection Idle Lifetime=5;

Jwt__Key
= YourSuperSecretKeyForJwtTokenGeneration2026!MustBeLongEnough

ASPNETCORE_ENVIRONMENT
= Production

Jwt__Issuer
= OfficeOrderAPI

Jwt__Audience
= OfficeOrderClient
```

#### Step 3: 如有修改，手動重新部署
點擊 **Manual Deploy** → **Deploy latest commit**

---

### 解決方案 3: 修復前端配置 (如果是前端問題)

#### 選項 A: 在 Netlify 設定環境變數 (推薦)
1. 登入 Netlify
2. 進入專案 Configuration for playful-centaur-98df6f
3. 選擇 **Site settings** → **Environment variables**
4. 新增變數:
   ```
   Key: VITE_API_URL
   Value: https://order-system-api-2tve.onrender.com/api
   ```
5. 選擇所有範圍:
   - ✅ Production
   - ✅ Deploy previews  
   - ✅ Branch deploys
6. 點擊 **Deploys** → **Trigger deploy** → **Clear cache and deploy site**

#### 選項 B: 本地重新打包上傳
```powershell
cd frontend

# 確認 .env.production 內容正確
Get-Content .env.production
# 應該看到: VITE_API_URL=https://order-system-api-2tve.onrender.com/api

# 重新打包
npm install
npm run build

# 上傳 dist 資料夾到 Netlify
```

---

## 🧪 完整測試流程

執行以下 PowerShell 命令進行完整測試:

```powershell
# 切換到專案目錄
cd D:\github\ORDERS\A_order\TestEvents

# 測試後端健康狀態
.\test-render-login.ps1

# 或手動測試登入
$body = @{email="admin@company.com"; password="admin123"} | ConvertTo-Json
Invoke-RestMethod -Uri "https://order-system-api-2tve.onrender.com/api/auth/login" `
    -Method Post -Body $body -ContentType "application/json"
```

---

## 📝 測試帳號資訊

### 管理員帳號
```
Email: admin@company.com
密碼: admin123
```

### 其他測試帳號
```
1@company.com - 王小明
2@company.com - 李小華  
3@company.com - 華經理
4@company.com - EC
5@company.com - 物流
```

**注意**: 如果 admin123 無法登入，可能需要執行密碼重設腳本。

---

## ⚡ 快速修復步驟 (推薦執行順序)

1. **立即執行** - 匯入資料到 Supabase (5 分鐘)
2. **確認環境變數** - 檢查 Render.com 配置 (2 分鐘)
3. **測試登入** - 驗證問題是否解決 (1 分鐘)
4. **如仍失敗** - 查看 Render.com Logs 找出具體錯誤 (5 分鐘)

---

## 📞 需要進一步協助?

如果執行上述步驟後問題仍未解決，請提供以下資訊:

1. Supabase 查詢 `SELECT COUNT(*) FROM "Users"` 的結果
2. Render.com Logs 中的錯誤訊息
3. 瀏覽器 F12 Network 中登入請求的完整錯誤

---

**最後更新**: 2026年4月7日  
**建議優先級**: 🔴 Critical - 立即執行解決方案 1
