# 🔑 Render.com 環境變數設定清單

> **專案**：飲料訂購系統後端 (order-system-api)  
> **日期**：2026年4月6日

---

## 📋 必須設定的環境變數（2個）

請在 Render.com → order-system-api → Environment 頁面中新增以下環境變數：

### 1. 資料庫連接字串

```
Key:   ConnectionStrings__DefaultConnection
Value: postgresql://postgres:ReyifmEReyi@db.idyfbtswixhfahddnlkw.supabase.co:5432/postgres
```

**說明**：連接到 Supabase PostgreSQL 資料庫


### 2. JWT 密鑰

```
Key:   Jwt__Key
Value: QlqwWDA50K6mzSMiTUv7tYcgp2EXnGOa
```

**說明**：用於 JWT Token 加密的密鑰（已自動產生）

---

## ✅ 應該已自動設定的環境變數（5個）

這些變數應該在 render.yaml 中已定義，請確認是否存在：

```
ASPNETCORE_ENVIRONMENT = Production
ASPNETCORE_URLS = http://+:5000
Jwt__Issuer = OfficeOrderAPI
Jwt__Audience = OfficeOrderClient
Jwt__ExpiryMinutes = 60
```

---

## 🎯 操作步驟

### 第 1 步：進入環境變數頁面

1. 前往 [Render.com Dashboard](https://dashboard.render.com)
2. 找到 `order-system-api` 服務
3. 點擊進入
4. 左側選單點擊 **「Environment」**

### 第 2 步：新增環境變數

1. 點擊 **「Add Environment Variable」** 或 **「+ Add」** 按鈕

2. **第一個變數**：
   - Key: `ConnectionStrings__DefaultConnection`
   - Value: `postgresql://postgres:ReyifmEReyi@db.idyfbtswixhfahddnlkw.supabase.co:5432/postgres`
   - 點擊 **「Add」**

3. **第二個變數**：
   - Key: `Jwt__Key`
   - Value: `QlqwWDA50K6mzSMiTUv7tYcgp2EXnGOa`
   - 點擊 **「Add」**

### 第 3 步：儲存變更

1. 點擊頁面底部的 **「Save Changes」** 按鈕
2. Render.com 會自動重新部署服務
3. ⏳ 等待 5-10 分鐘建置完成

---

## 📋 完整環境變數檢查清單

設定完成後，Environment 頁面應該顯示以下 7 個變數：

- [x] `ASPNETCORE_ENVIRONMENT` = `Production`
- [x] `ASPNETCORE_URLS` = `http://+:5000`
- [x] `ConnectionStrings__DefaultConnection` = `postgresql://postgres:ReyifmE...`
- [x] `Jwt__Key` = `QlqwWDA50K6mzS...`
- [x] `Jwt__Issuer` = `OfficeOrderAPI`
- [x] `Jwt__Audience` = `OfficeOrderClient`
- [x] `Jwt__ExpiryMinutes` = `60`

---

## ⚠️ 重要提醒

### 安全性注意事項

- ✅ JWT Key 已產生：`QlqwWDA50K6mzSMiTUv7tYcgp2EXnGOa`
- 🔒 請勿將此密鑰公開分享
- 🔒 建議定期更換（每 3-6 個月）

### 資料庫連接字串

- ✅ 已包含 Supabase 資料庫密碼：`ReyifmEReyi`
- ✅ 已包含正確的資料庫地址：`db.idyfbtswixhfahddnlkw.supabase.co`

---

## 🎉 設定完成後

### 確認部署成功

1. 點擊左側選單 **「Logs」**
2. 查看建置進度
3. 看到 `Your service is live 🎉` 表示成功

### 取得後端 URL

在服務頁面頂部找到類似這樣的 URL：
```
https://order-system-api-xxxx.onrender.com
```
https://order-system-api-2tve.onrender.com
📋 **複製此 URL**，下一步前端部署會用到！

---

**設定完成後請告訴我，我會協助您進行下一步！** ✨
