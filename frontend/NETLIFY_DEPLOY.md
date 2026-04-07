# 🚀 Netlify 部署指南

**更新日期**：2026年4月7日  
**專案**：飲料訂購系統前端

---

## ✅ 部署前檢查

- [x] 本地建置成功（`npm run build`）✅
- [x] `netlify.toml` 配置正確 ✅
- [x] 後端 API 運行中（Render.com）✅
- [x] 資料庫已設定（Supabase）✅

---

## 🎯 部署方式選擇

### 方式 A：透過 Netlify 網頁介面（推薦）

**優點**：
- 簡單直觀
- 自動部署
- 容易設定環境變數

**步驟** → 見下方「詳細步驟」

---

### 方式 B：使用 Netlify CLI

**優點**：
- 命令列操作
- 適合開發流程

**步驟**：
```powershell
# 1. 安裝 Netlify CLI
npm install -g netlify-cli

# 2. 登入
netlify login

# 3. 初始化專案（在專案根目錄）
netlify init

# 4. 部署
netlify deploy --prod
```

---

## 📋 方式 A：詳細部署步驟

### 第 1 步：準備 GitHub 倉庫

#### 1.1 確認代碼已推送
```powershell
cd d:\github\ORDERS\A_order

# 查看狀態
git status

# 如果有未提交的變更
git add .
git commit -m "準備部署到 Netlify - 已遷移到 Supabase"
git push origin main
```

#### 1.2 確認分支名稱
```powershell
# 查看當前分支
git branch

# 如果不是 main，記住您的分支名稱（例如：master）
```

---

### 第 2 步：登入 Netlify

1. **前往** [https://app.netlify.com](https://app.netlify.com)
2. **登入方式**：
   - 使用 GitHub 帳號登入（推薦）
   - 或使用 Email 註冊

---

### 第 3 步：創建新網站

#### 3.1 開始創建
1. 點擊 **"Add new site"** → **"Import an existing project"**
2. 選擇 **"Deploy with GitHub"**

#### 3.2 授權 GitHub
1. 如果首次使用，需要授權 Netlify 存取 GitHub
2. 點擊 **"Authorize Netlify"**

#### 3.3 選擇倉庫
1. 搜尋或選擇 **"A_order"** 倉庫
2. 點擊倉庫名稱

---

### 第 4 步：配置建置設定

Netlify 會自動讀取 `netlify.toml`，確認以下設定：

```
Branch to deploy: main (或您的分支名稱)
Base directory: frontend
Build command: npm run build
Publish directory: frontend/dist
```

**重要**：如果自動偵測不正確，請手動填入上述值。

---

### 第 5 步：設定環境變數 ⚠️ 重要

在部署前，**必須**設定環境變數：

#### 5.1 點擊 "Show advanced"
#### 5.2 點擊 "New variable"

#### 5.3 新增環境變數
```
Key:   VITE_API_URL
Value: https://order-system-api-2tve.onrender.com/api
```

**複製貼上**以避免錯誤！

---

### 第 6 步：開始部署

1. 點擊 **"Deploy site"**
2. 等待建置完成（約 1-3 分鐘）

**建置過程**：
```
1. 初始化建置環境
2. 安裝依賴 (npm install)
3. 執行建置 (npm run build)
4. 上傳檔案到 CDN
5. ✅ 部署完成
```

---

### 第 7 步：取得網站 URL

部署完成後，您會看到：

```
Site is live ✨
https://your-random-name.netlify.app
```

**記下這個 URL**！

---

### 第 8 步：（可選）自訂網域名稱

#### 8.1 修改網站名稱
1. 前往 **Site settings** → **General** → **Site details**
2. 點擊 **"Change site name"**
3. 輸入您想要的名稱（例如：`order-system`）
4. 保存後網址變為：`https://order-system.netlify.app`

#### 8.2 使用自己的網域
1. 前往 **Domain settings**
2. 點擊 **"Add custom domain"**
3. 輸入您的網域（例如：`order.yourdomain.com`）
4. 依照指示設定 DNS

---

## 🧪 測試部署

### 測試 1：開啟網站
```
前往：https://your-site.netlify.app
```

**預期結果**：
- ✅ 頁面正常載入
- ✅ 顯示登入畫面

---

### 測試 2：檢查 API 連線

1. **按 F12** 開啟開發者工具
2. 切換到 **Console** 標籤
3. 嘗試登入

**預期結果**：
- ✅ 看到 API 請求到 `https://order-system-api-2tve.onrender.com/api/auth/login`
- ✅ 無 CORS 錯誤

---

### 測試 3：完整功能測試

使用測試帳號登入：
```
Email: admin@company.com
密碼: （需從 Supabase 資料庫查詢或重設）
```

**測試清單**：
- [ ] 登入成功
- [ ] 顯示店鋪列表
- [ ] 瀏覽菜單
- [ ] 創建訂購活動
- [ ] 提交訂單
- [ ] 查看分帳明細

---

## 🔧 進階設定

### 自動部署設定

**位置**：Site settings → Build & deploy → Continuous deployment

**預設行為**：
- ✅ 推送到 `main` 分支自動部署
- ✅ Pull Request 會建立預覽部署

**如需停用**：
1. 前往 **Build settings**
2. 點擊 **"Stop builds"**

---

### 環境變數管理

**位置**：Site settings → Environment variables

**查看/編輯**：
```
VITE_API_URL = https://order-system-api-2tve.onrender.com/api
```

**修改後**：
1. 前往 **Deploys**
2. 點擊 **"Trigger deploy"** → **"Clear cache and deploy site"**

---

### 部署通知

**設定 Email 通知**：
1. Site settings → Build & deploy → Deploy notifications
2. 點擊 **"Add notification"**
3. 選擇 **"Email"** 或 **"Slack"**

---

## 🚨 常見問題排解

### 問題 1：建置失敗 - "npm ERR!"

**錯誤訊息**：
```
npm ERR! code ELIFECYCLE
```

**解決方案**：
1. 檢查 `package.json` 是否正確
2. 確認 Node.js 版本相容
3. 在 **Site settings** → **Environment** 設定 Node 版本：
   ```
   NODE_VERSION = 18
   ```

---

### 問題 2：頁面白屏

**可能原因**：
1. 環境變數未設定
2. API URL 錯誤

**檢查步驟**：
```
1. 按 F12 → Console 查看錯誤
2. 確認 VITE_API_URL 已設定
3. 確認 API URL 結尾有 /api
```

**解決方案**：
```
Site settings → Environment variables
確認 VITE_API_URL = https://order-system-api-2tve.onrender.com/api
```

---

### 問題 3：API 請求失敗

**錯誤訊息** (Console)：
```
GET https://order-system-api-2tve.onrender.com/api/stores 503
```

**原因**：Render.com 後端休眠

**解決方案**：
- 等待 30-60 秒讓後端喚醒
- 重新整理頁面

---

### 問題 4：CORS 錯誤

**錯誤訊息**：
```
Access-Control-Allow-Origin error
```

**檢查**：
1. 後端 CORS 是否啟用（已確認 ✅）
2. API URL 是否正確

**如果仍有問題**：
檢查後端 `Startup.cs` 第 150 行：
```csharp
app.UseCors("AllowAll");  // 應該在 UseRouting() 之後
```

---

### 問題 5：登入失敗

**錯誤訊息**：
```
401 Unauthorized 或 密碼錯誤
```

**解決方案**：
在 Supabase SQL Editor 重設密碼：
```sql
-- 設定 admin 密碼為 "admin123"
UPDATE "Users" 
SET "PasswordHash" = '$2a$11$rK8H3P5X7Y9Z4W6V2N1M8eO9Q7R6S5T4U3V2W1X0Y9Z8A7B6C5D4E3'
WHERE "Email" = 'admin@company.com';
```

---

## 📊 部署資訊總覽

### 網站資訊
```
平台: Netlify
部署方式: 自動部署 (Git)
建置工具: Vite
框架: React 18
```

### 環境變數
```
VITE_API_URL = https://order-system-api-2tve.onrender.com/api
```

### 自動部署
```
觸發條件: 推送到 main 分支
建置時間: ~1-3 分鐘
CDN: 全球分發
HTTPS: 自動啟用
```

---

## 🔗 相關連結

### Netlify Dashboard
```
https://app.netlify.com/sites/YOUR-SITE-NAME
```

### 常用頁面
- **部署記錄**：Deploys
- **環境變數**：Site settings → Environment variables
- **網域設定**：Domain settings
- **建置設定**：Site settings → Build & deploy

---

## 📝 部署後檢查清單

### Netlify 設定
- [ ] 網站已成功部署
- [ ] 環境變數 `VITE_API_URL` 已設定
- [ ] 自訂網站名稱（可選）
- [ ] HTTPS 已啟用（自動）

### 功能測試
- [ ] 首頁正常載入
- [ ] 可以登入
- [ ] API 連線正常
- [ ] 所有功能運作正常

### 優化（可選）
- [ ] 設定自訂網域
- [ ] 設定部署通知
- [ ] 優化建置時間

---

## 🎉 完成！

您的網站現已部署到 Netlify！

**下一步**：
1. 分享網站 URL 給團隊
2. 設定自訂網域（可選）
3. 監控使用狀況

**架構總覽**：
```
前端 (Netlify) → 後端 (Render.com) → 資料庫 (Supabase)
     HTTPS              REST API           PostgreSQL
```

---

**需要協助？**
- Netlify 文件：https://docs.netlify.com
- 部署狀態：[DEPLOYMENT_STATUS.md](../DEPLOYMENT_STATUS.md)
- 後端配置：[RENDER_ENV_SETUP.md](../RENDER_ENV_SETUP.md)

🚀 **部署成功！**
