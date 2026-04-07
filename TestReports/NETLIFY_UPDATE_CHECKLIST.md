# ✅ Netlify 現有部署更新清單

**日期**：2026年4月7日  
**狀態**：後端已遷移到 Supabase，前端需要確認配置

---

## 🎯 背景說明

您已經部署到 Netlify，但後端剛剛從 SQL Server 遷移到 Supabase。
需要確認 Netlify 的環境變數是否正確指向後端 API。

---

## 📋 必須檢查的項目

### ✅ 步驟 1：檢查 Netlify 環境變數

1. **登入 Netlify Dashboard**
   ```
   https://app.netlify.com
   ```

2. **進入您的網站專案**
   - 找到並點擊您的網站

3. **前往環境變數設定**
   ```
   Site settings → Environment variables
   ```

4. **檢查 VITE_API_URL**
   
   **應該是**：
   ```
   VITE_API_URL = https://order-system-api-2tve.onrender.com/api
   ```

   **如果不是或不存在**：
   - 點擊 "Add variable" 或 "Edit"
   - 設定正確的值
   - 保存

---

### ✅ 步驟 2：重新部署

**為什麼需要重新部署？**
- 環境變數的更改不會自動套用到已部署的網站
- 需要重新建置才能讀取新的環境變數

**如何重新部署**：

1. **前往 Deploys 頁面**
   ```
   Deploys (頂部導航)
   ```

2. **觸發新部署**
   ```
   點擊 "Trigger deploy" 按鈕
   → 選擇 "Clear cache and deploy site"
   ```

3. **等待建置完成**
   - 約 1-3 分鐘
   - 觀察建置日誌確認無錯誤

---

### ✅ 步驟 3：測試功能

部署完成後，測試網站功能：

1. **開啟您的 Netlify 網站**
   ```
   https://your-site.netlify.app
   ```

2. **按 F12 開啟開發者工具**
   - 切換到 **Console** 標籤

3. **嘗試登入**
   - Email: `admin@company.com`
   - 密碼: （需從 Supabase 查詢）

4. **檢查 API 請求**
   
   在 Console 或 Network 標籤中，應該看到：
   ```
   POST https://order-system-api-2tve.onrender.com/api/auth/login
   ```

   **正常回應**：
   - ✅ 200 OK（登入成功）
   - ✅ 401 Unauthorized（密碼錯誤，但 API 連線正常）
   - ⚠️  503 Service Unavailable（後端休眠，等待 30-60 秒）

   **異常回應**：
   - ❌ Network Error → 環境變數設定錯誤
   - ❌ CORS Error → 後端 CORS 問題（已確認正確）

---

## 🔍 如何查看當前環境變數

### 方式 1：在 Netlify 查看

```
Site settings → Environment variables → 查看 VITE_API_URL
```

---

### 方式 2：在網站 Console 查看

在您的 Netlify 網站上：

1. **按 F12** 開啟開發者工具
2. **Console 標籤**輸入：
   ```javascript
   console.log(import.meta.env.VITE_API_URL)
   ```

**預期結果**：
```
https://order-system-api-2tve.onrender.com/api
```

**如果顯示 undefined**：
- 環境變數未設定
- 或設定後未重新部署

---

## 🚨 常見問題

### 問題 1：API 請求到錯誤的 URL

**症狀**：
```
POST http://localhost:5000/api/auth/login
```

**原因**：環境變數未設定或未生效

**解決方案**：
1. 確認 Netlify 環境變數設定正確
2. 重新部署（Clear cache）

---

### 問題 2：後端無回應 (503)

**症狀**：
```
GET https://order-system-api-2tve.onrender.com/api/stores 503
```

**原因**：Render.com 免費方案服務休眠

**解決方案**：
- 等待 30-60 秒
- 重新整理頁面
- 服務會自動喚醒

---

### 問題 3：資料庫無資料

**症狀**：登入成功但看不到店鋪或菜單

**原因**：Supabase 資料未匯入

**解決方案**：
1. 登入 Supabase
   ```
   https://app.supabase.com/project/idyfbtswixhfahddnlkw/sql
   ```

2. 執行匯入腳本
   ```
   開啟：database/export_complete_with_users.sql
   複製全部 → 貼到 SQL Editor → Run
   ```

3. 驗證資料
   ```sql
   SELECT COUNT(*) FROM "Users";    -- 應該有 6 筆
   SELECT COUNT(*) FROM "Stores";   -- 應該有 6 筆
   SELECT COUNT(*) FROM "MenuItems"; -- 應該有 46 筆
   ```

---

## ✅ 完整檢查清單

### Netlify 配置
- [ ] 登入 Netlify Dashboard
- [ ] 前往您的網站專案
- [ ] 檢查環境變數 `VITE_API_URL`
- [ ] 確認值為 `https://order-system-api-2tve.onrender.com/api`
- [ ] 如有更改，重新部署（Clear cache）

### 後端配置 (Render.com)
- [ ] 檢查服務狀態為 **Live**
- [ ] 確認環境變數 `ConnectionStrings__DefaultConnection` 指向 Supabase
- [ ] 查看 Logs 確認無錯誤

### 資料庫 (Supabase)
- [ ] 資料已匯入（Users, Stores, MenuItems）
- [ ] 可以執行 SQL 查詢
- [ ] 測試帳號密碼已設定

### 功能測試
- [ ] 網站可以正常開啟
- [ ] API 請求正確指向 Render.com
- [ ] 可以登入
- [ ] 可以查看店鋪和菜單
- [ ] 可以下單

---

## 🔗 相關資源

### Netlify
- **您的網站**: https://app.netlify.com/sites/YOUR-SITE
- **環境變數**: Site settings → Environment variables
- **部署記錄**: Deploys

### 後端 API
- **URL**: https://order-system-api-2tve.onrender.com
- **Dashboard**: https://dashboard.render.com

### 資料庫
- **Supabase**: https://app.supabase.com/project/idyfbtswixhfahddnlkw
- **SQL Editor**: https://app.supabase.com/project/idyfbtswixhfahddnlkw/sql

---

## 🎯 快速行動

### 如果一切正常
- ✅ 繼續使用，不需要更改

### 如果 API 連線錯誤
1. ✅ 檢查 Netlify 環境變數
2. ✅ 重新部署（Clear cache）
3. ✅ 測試登入

### 如果看不到資料
1. ✅ 匯入資料到 Supabase
2. ✅ 檢查後端 Logs
3. ✅ 測試 API 端點

---

## 📞 需要協助？

參考詳細文件：
- [DEPLOYMENT_STATUS.md](../DEPLOYMENT_STATUS.md) - 完整部署檢查
- [NETLIFY_DEPLOY.md](NETLIFY_DEPLOY.md) - Netlify 部署指南
- [SUPABASE_MIGRATION_SUMMARY.md](../SUPABASE_MIGRATION_SUMMARY.md) - 資料庫遷移說明

---

**開始檢查吧！** 🚀
