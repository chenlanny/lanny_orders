# Render.com 原生 .NET 部署步驟

由於 Docker 構建在 Render.com 上持續失敗，我們改用 **Render.com 的原生 .NET 支持**。

---

## 🚀 立即執行步驟

### STEP 1: 進入 Render Dashboard
```
https://dashboard.render.com
```

### STEP 2: 刪除舊的 Docker 服務
1. 找到 **order-system-api** 服務
2. 進入服務設定
3. 點擊頁面底部 **Delete service**
4. 輸入服務名稱確認刪除

⏱️ 刪除需要 1-2 分鐘

### STEP 3: 創建新服務

1. 點擊 **New +** 按鈕
2. 選擇 **Web Service**

### STEP 4: 連接 GitHub 倉庫

1. 選擇 **GitHub** 作為來源
2. 搜尋倉庫：**lanny_orders**（或您的倉庫名）
3. 點擊連接

### STEP 5: 配置服務

**基本設定**:
- **Name**: `order-system-api`
- **Region**: `Singapore` (或其他)
- **Branch**: `main`

**Build 命令** (重要！):
```
cd database/backend && dotnet publish -c Release
```

**Start 命令** (重要！):
```
cd database/backend/bin/Release/netcoreapp3.1/publish && dotnet OfficeOrderApi.dll
```

### STEP 6: 設定環境變數

在 **Environment** 部分新增以下變數：

```
ASPNETCORE_ENVIRONMENT = Production
ASPNETCORE_URLS = http://+:5000
ConnectionStrings__DefaultConnection = Host=db.idyfbtswixhfahddnlkw.supabase.co;Port=5432;Database=postgres;Username=postgres;Password=ReyifmEReyi;SSL Mode=Require;Timeout=15;Command Timeout=15;Max Pool Size=5;Connection Idle Lifetime=5;
Jwt__Key = YourSuperSecretKeyForJwtTokenGeneration2026!MustBeLongEnough
Jwt__Issuer = OfficeOrderAPI
Jwt__Audience = OfficeOrderClient
Jwt__ExpiryMinutes = 60
```

### STEP 7: 創建服務

1. 確認所有設定正確
2. 點擊 **Create Web Service**
3. 等待構建完成

⏱️ 構建和部署通常需要 **5-10 分鐘**

---

## 📊 監控部署進度

進入服務後，查看 **Logs** 標籤：

**成功跡象**:
```
Starting build...
Downloading packages...
Building project...
✓ Your service is live
```

**失敗跡象**:
```
error: failed to...
NuGet timeout...
```

---

## ✅ 部署完成驗證

### 檢查 1: 服務狀態
- Status 應顯示 **Live**（綠色）

### 檢查 2: 測試 API
```powershell
$body = @{email="admin@company.com";password="admin123"} | ConvertTo-Json
Invoke-RestMethod -Uri "https://order-system-api-2tve.onrender.com/api/auth/login" `
    -Method Post -Body $body -ContentType "application/json"
```

### 檢查 3: 前端登入
https://playful-centaur-98df6f.netlify.app/login
- 帳號: admin@company.com
- 密碼: admin123

---

## ⚠️ 如果仍然失敗

1. 檢查 Logs 中的具體錯誤
2. 確認環保變數都正確設定（特別是 ConnectionStrings）
3. 檢查倉庫是否有推送最新的代碼

---

## 另一種方式：使用 render.yaml

如果 Render.com 支援 render.yaml，新加入的文件會自動偵測配置！

---

**立即按照上述步驟執行！**

如果遇到任何問題，告訴我 Logs 中的具體錯誤訊息。
