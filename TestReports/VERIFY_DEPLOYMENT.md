# 後端部署成功，但登入返回 500 錯誤 - 診斷步驟

## 現在的情況

✅ **Render.com 部署**: 成功  
❌ **登入 API**: 返回 HTTP 500 錯誤  

---

## 🔍 下一步：檢查 Render.com Logs

### STEP 1: 打開 Render Dashboard
```
https://dashboard.render.com
```

### STEP 2: 進入 order-system-api 服務

### STEP 3: 點擊 **Logs** 標籤

### STEP 4: 查看最後的錯誤訊息

應該看到類似的內容（查看錯誤):
```
Microsoft.EntityFrameworkCore.Database.Command[20101]
fail: Npgsql.EntityFrameworkCore.PostgreSQL[...]
Executed DbCommand (###ms) [Parameters=...]
SELECT ...
```

或者：
```
error: failed to connect to database
error: invalid connection string
```

---

## 🎯 常見原因

### 問題 1: 資料庫連接失敗

**症狀**: Logs 中看到 "failed to connect" 或 "Connection timeout"

**檢查**:
1. 確認環境變數 `ConnectionStrings__DefaultConnection` 正確
2. 確認 Supabase 資料庫仍然線上
3. Supabase IP 是否允許 Render.com 連接

**測試 Supabase**:
```sql
SELECT COUNT(*) FROM "Users";
```

### 問題 2: 環境變數缺失或錯誤

**症狀**: Logs 中看到 "environment variable not found" 或值為空

**檢查**:
1. Render Dashboard → Environment 標籤
2. 確認所有必需的變數都存在
3. 特別檢查 `Jwt__Key` 是否設定

### 問題 3: 應用程式啟動失敗

**症狀**: Logs 中看到異常堆棧跟蹤

**檢查**:
1. 查看完整的错误讯息
2. 告訴我具體的錯誤

---

## 📋 立即行動

1. **打開 Render.com Logs**
2. **複製最後 20-30 行的錯誤訊息**
3. **告訴我具體看到什麼錯誤**

---

## 可能的快速修復

如果是環境變數問題，可以：
1. 進入 Render Dashboard
2. order-system-api → Environment
3. 檢查並修改有問題的變數
4. 返回服務頁面，點擊 **Manual Deploy** → 重新部署

---

**現在就查看 Render.com Logs，告訴我具體的錯誤訊息吧！**
