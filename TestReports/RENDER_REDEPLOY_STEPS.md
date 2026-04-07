# Render.com 重新部署步驟

## ✅ 代碼已推送

**提交訊息**: `Optimize Dockerfile for Render.com`  
**狀態**: ✅ GitHub 已更新

---

## 🚀 Render.com 重新部署步驟

### STEP 1: 進入 Render Dashboard

**URL**:
```
https://dashboard.render.com
```

---

### STEP 2: 找到 order-system-api 服務

1. 登入 Render Dashboard
2. 在服務列表中尋找：**order-system-api** (或 order-system-api-2tve)
3. 點擊進入服務頁面

---

### STEP 3: 執行重新部署

在服務頁面上，您會看到幾個選項：

#### 選項 A: Redeploy（推薦）

1. 找到頁面頂部的 **Redeploy** 按鈕
2. 點擊並選擇：**Clear build cache & deploy**
3. 確認部署開始

#### 選項 B: Manual Deploy

1. 點擊 **Manual Deploy** 按鈕
2. 選擇 **Deploy latest commit**

#### 選項 C: 直接推送部署

由於代碼已推送，Render 應該會自動檢測並部署。
- 如果沒有自動部署，使用選項 A 或 B

---

### STEP 4: 監控部署進度

1. 進入 **Logs** 標籤
2. 實時監控構建過程

**應該看到的進度**:
```
[Build] Starting build...
[Build] Installing packages...        ← 關鍵步驟
[Build] Building application...
[Build] Creating container...
[Deploy] Starting service...
✓ Your service is live!
```

**完成時間**: 通常 5-15 分鐘

---

### STEP 5: 驗證部署成功

部署完成後，您會看到：
```
✓ Your service is live!
✓ Access your service at: https://order-system-api-2tve.onrender.com
```

---

## 🧪 測試部署是否成功

### 方法 1: 檢查服務狀態

在 Render Dashboard 中：
- **Status** 應該顯示為 **Live**（綠色）
- **Last Deploy** 應該是剛才的時間

### 方法 2: 測試 API

```powershell
# 測試登入 API
$body = @{
    email = "admin@company.com"
    password = "admin123"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://order-system-api-2tve.onrender.com/api/auth/login" `
    -Method Post `
    -Body $body `
    -ContentType "application/json"
```

**預期結果**:
```json
{
  "success": true,
  "message": "登入成功",
  "data": {
    "token": "eyJ0eXAi...",
    "user": {
      "userId": 5,
      "email": "admin@company.com",
      "name": "管理員",
      "role": "Admin"
    }
  }
}
```

### 方法 3: 在前端測試登入

1. 開啟 https://playful-centaur-98df6f.netlify.app/login
2. 輸入帳號: `admin@company.com`
3. 輸入密碼: `admin123`
4. 點擊登入

**預期**: 登入成功，進入主頁面

---

## ⚠️ 完整檢查清單

### 部署前
- [x] 代碼已推送到 GitHub
- [x] Dockerfile 已優化

### 部署中
- [ ] 進入 Render Dashboard
- [ ] 選擇 order-system-api 服務
- [ ] 點擊 Redeploy
- [ ] 選擇 "Clear build cache & deploy"
- [ ] 監控 Logs 觀察進度

### 部署後
- [ ] Status 顯示為 "Live"（綠色）
- [ ] Logs 最後顯示 "Your service is live!"
- [ ] API 測試返回正確的 token

### 功能測試
- [ ] 前端登入成功
- [ ] 可以訪問儀表板
- [ ] 可以創建訂購活動

---

## 💡 常見問題

### 問題 1: 部署仍然失敗

**檢查 Logs 中的錯誤**:
- 如果仍是 NuGet 超時 → 再次清除緩存並部署
- 如果是其他錯誤 → 記錄錯誤訊息

### 問題 2: 部署成功但登入仍然失敗

**可能原因**:
- Render 服務容器未完全啟動（等 1-2 分鐘）
- 環保變數配置丟失

**解決方案**:
1. 等待 2 分鐘後重試
2. 檢查 Environment 標籤確認環保變數
3. 如果缺失，添加並重新部署

---

## ✨ 預期結果

部署成功後，您應該能夠：
- ✅ 訪問 https://playful-centaur-98df6f.netlify.app
- ✅ 以 admin@company.com 登入
- ✅ 查看和管理訂購活動
- ✅ 正常使用整個系統

---

**現在就打開 Render Dashboard 開始部署吧！** 🚀

部署時間通常是 5-15 分鐘。部署期間您可以監控 Logs 標籤查看進度。
