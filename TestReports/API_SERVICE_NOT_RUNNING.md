# Render.com API Service Not Running - 解決方案

## 📊 目前狀態

❌ **order-system-api** - NOT Running (未運行)
✅ **order-system-db** - Live (運行中)

---

## 🔧 解決方案步驟

### STEP 1: 查看 order-system-api 服務狀態

**進入 Render Dashboard:**
```
https://dashboard.render.com/services
```

**選擇服務:**
```
order-system-api (或 order-system-api-2tve)
```

**查看欄位:**
- Status: 應該是 "Live"（但目前不是）
- 查看 Logs 標籤，看是否有錯誤訊息

---

### STEP 2: 檢查服務為何未運行

在 Logs 中尋找任何錯誤，例如：
- Build failed（構建失敗）
- Startup error（啟動錯誤）
- Out of memory（記憶體不足）
- Port conflict（端口衝突）

---

### STEP 3: 重新啟動或重新部署服務

**選項 A: 簡單重新啟動**
1. 在 Render Dashboard 中找到 order-system-api
2. 點擊頁面頂部的 **Redeploy** 按鈕
3. 選擇 **"Clear build cache & deploy"**
4. 等待部署完成（5-10 分鐘）

**選項 B: 手動部署**
1. 點擊 **Manual Deploy** 
2. 選擇 **"Deploy latest commit"**
3. 等待部署完成

**選項 C: 停止並重新啟動**
1. 點擊 **Suspend service** 停止
2. 等 30 秒
3. 點擊 **Resume service** 重新啟動

---

### STEP 4: 監控部署進度

1. 開啟 **Logs** 標籤
2. 監控部署過程：
   ```
   Building service...
   Installing packages...
   Starting service...
   ```

3. 完成時應看到：
   ```
   Your service is live!
   ```

---

### STEP 5: 驗證服務已啟動

部署完成後，執行測試：

```powershell
# 等待 1-2 分鐘讓服務完全啟動

# 測試健康檢查
Invoke-WebRequest -Uri "https://order-system-api-2tve.onrender.com/api/auth/status" `
    -UseBasicParsing

# 測試登入
$body = @{
    email = "admin@company.com"
    password = "admin123"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://order-system-api-2tve.onrender.com/api/auth/login" `
    -Method Post -Body $body -ContentType "application/json"
```

**預期結果:**
- ✅ 返回 token 和用戶資訊 → 問題解決！
- ❌ 仍然出錯 → 查看 Logs 找出錯誤

---

## 💡 常見原因

| 原因 | 狀況 | 解決方案 |
|------|------|--------|
| 部署失敗 | Logs 顯示 build error | 檢查代碼是否有編譯錯誤 |
| 記憶體不足 | Logs 顯示 out of memory | 升級 plan 或優化代碼 |
| 連接超時 | 啟動時超時 | 增加 Startup Timeout |
| 端口被佔用 | Port already in use | 檢查環境變數 ASPNETCORE_URLS |
| 環境變數缺失 | Application crash | 確認所有環保變數已設定 |

---

## 📝 快速檢查清單

- [ ] 開啟 Render Dashboard
- [ ] 進入 order-system-api 服務
- [ ] 確認 Status 欄位
- [ ] 檢查 Logs 找出問題原因
- [ ] 執行重新部署
- [ ] 等待 5-10 分鐘完成
- [ ] 再次測試登入
- [ ] 確認返回 token（登入成功）

---

## 🚀 建議優先執行順序

1. **打開 Render Dashboard，點擊 Redeploy**（1 分鐘）
2. **選擇 "Clear build cache & deploy"**（1 分鐘）
3. **監控 Logs，等待完成**（5-10 分鐘）
4. **執行登入測試**（1 分鐘）
5. **如果成功，嘗試在前端登入**（1 分鐘）

---

**預期結果:**
- ✅ 部署成功後，order-system-api status 應變為 "Live"
- ✅ 登入 API 返回正常響應
- ✅ 前端可成功登入
