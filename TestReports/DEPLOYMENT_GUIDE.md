# 🚀 飲料訂購系統 - 完全免費部署指南

> **方案 A**：Vercel (前端) + Render.com (後端) + Supabase (PostgreSQL)  
> **費用**：完全免費  
> **限制**：後端會休眠（15分鐘無活動），首次訪問需等待 30-60 秒

---

## 📋 目錄

1. [前置準備](#前置準備)
2. [第一步：註冊帳號](#第一步註冊帳號)
3. [第二步：部署資料庫 (Supabase)](#第二步部署資料庫-supabase)
4. [第三步：部署後端 (Render.com)](#第三步部署後端-rendercom)
5. [第四步：部署前端 (Vercel)](#第四步部署前端-vercel)
6. [第五步：測試與驗證](#第五步測試與驗證)
7. [疑難排解](#疑難排解)

---

## 前置準備

### ✅ 必備條件

- [ ] GitHub 帳號（用於部署）
- [ ] 本地專案已推送到 GitHub
- [ ] 已完成本地測試（前後端正常運作）

### 📦 必要檔案檢查

確認專案中已有以下檔案（由自動化腳本生成）：

```
A_order/
├── database/
│   ├── backend/
│   │   ├── Dockerfile ✅
│   │   ├── .dockerignore ✅
│   │   ├── appsettings.Production.json ✅
│   │   └── OfficeOrderApi.csproj ✅ (已添加 PostgreSQL 支援)
│   └── postgresql-init.sql ✅
├── frontend/
│   ├── vercel.json ✅
│   └── .env.production ✅
└── render.yaml ✅
```

### 🔧 本地更新套件

開啟終端機，執行以下指令以安裝 PostgreSQL 支援套件：

```powershell
cd D:\github\ORDERS\A_order\database\backend
dotnet restore
```

---

## 第一步：註冊帳號

### 1.1 註冊 Supabase（資料庫）

1. 前往 [https://supabase.com](https://supabase.com)
2. 點擊「Start your project」
3. 使用 GitHub 帳號登入
4. ✅ 完成註冊

### 1.2 註冊 Render.com（後端）

1. 前往 [https://render.com](https://render.com)
2. 點擊「Get Started」
3. 使用 GitHub 帳號登入
4. ✅ 完成註冊

### 1.3 註冊 Vercel（前端）

1. 前往 [https://vercel.com](https://vercel.com)
2. 點擊「Sign Up」
3. 使用 GitHub 帳號登入
4. ✅ 完成註冊

---

## 第二步：部署資料庫 (Supabase)

### 2.1 創建新專案

1. 登入 Supabase Dashboard
2. 點擊「New Project」
3. 填寫專案資訊：
   - **Name**: `order-system`
   - **Database Password**: 設定一個強密碼（請記住！）   ReyifmEReyi
   - **Region**: `Southeast Asia (Singapore)`
   - **Pricing Plan**: `Free`
4. 點擊「Create new project」
5. ⏳ 等待 1-2 分鐘初始化

### 2.2 執行資料庫初始化腳本

1. 在 Supabase Dashboard 左側選單點擊「SQL Editor」
2. 點擊「New query」
3. 複製本地專案中的 `database/postgresql-init.sql` 內容
4. 貼上到 SQL Editor
5. 點擊「Run」執行
6. ✅ 確認顯示「Success. No rows returned」

### 2.3 取得資料庫連接字串

1. 在 Supabase Dashboard 點擊「Settings」（左下角齒輪圖示）
2. 點擊「Database」
3. 找到「Connection string」區塊
4. 選擇「URI」分頁
5. 複製連接字串（格式類似）：
   ```
   postgresql://postgres:[YOUR-PASSWORD]@db.xxxxxxxxxxxxx.supabase.co:5432/postgres
   ```
6. 📋 **儲存此連接字串**（稍後會用到）     postgresql://postgres:[ReyifmEReyi]@db.idyfbtswixhfahddnlkw.supabase.co:5432/postgres

---

## 第三步：部署後端 (Render.com)

### 3.1 推送程式碼到 GitHub

確保專案已推送到 GitHub：

```powershell
cd D:\github\ORDERS\A_order
git add .
git commit -m "Add deployment configs for Render + Vercel + Supabase"
git push origin main
```

### 3.2 連接 GitHub 倉庫

1. 登入 Render.com Dashboard
2. 點擊「New +」按鈕
3. 選擇「Blueprint」
4. 點擊「Connect a repository」
5. 選擇您的 GitHub 倉庫（例如：`yourname/ORDERS`）
6. ✅ 授權 Render.com 存取倉庫

### 3.3 配置後端服務

Render.com 會自動讀取 `render.yaml` 檔案，但需要手動設定環境變數：

1. 在 Dashboard 找到新創建的 Web Service：`order-system-api`
2. 點擊進入服務設定頁面
3. 點擊「Environment」分頁
4. 添加環境變數（**重要**）：

#### 必須設定的環境變數

| Key | Value | 說明 |
|-----|-------|------|
| `ASPNETCORE_ENVIRONMENT` | `Production` | 環境設定 |
| `ASPNETCORE_URLS` | `http://+:5000` | 端口設定 |
| `ConnectionStrings__DefaultConnection` | `[貼上 Supabase 連接字串]` | **從步驟 2.3 複製** |
| `Jwt__Key` | `[自行產生 32 字元隨機字串]` | JWT 密鑰 |
| `Jwt__Issuer` | `OfficeOrderAPI` | JWT 發行者 |
| `Jwt__Audience` | `OfficeOrderClient` | JWT 受眾 |
| `Jwt__ExpiryMinutes` | `60` | Token 有效期（分鐘） |

#### 如何產生 JWT Key

在 PowerShell 執行：

```powershell
-join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | ForEach-Object {[char]$_})
```

複製輸出結果（例如：`K9mP2xQ7vR3sT8wY1zL5nM4jH6gF0dB9`）

5. 點擊「Save Changes」
6. Render.com 會自動開始建置和部署

### 3.4 等待部署完成

1. 點擊「Logs」分頁觀察建置進度
2. ⏳ 首次部署需要 5-10 分鐘（需要建置 .NET Docker 映像）
3. ✅ 看到「Your service is live」表示部署成功
4. 📋 **複製服務 URL**（例如：`https://order-system-api.onrender.com`）

### 3.5 測試後端 API

在瀏覽器開啟：

```
https://order-system-api.onrender.com/api/auth/login
```

#### 真的測後端API網址
''''''https://order-system-api-2tve.onrender.com  

**預期結果**：顯示 HTTP 405 或 400 錯誤（正常，因為需要 POST 請求）

---

## 第四步：部署前端 (Vercel)

### 4.1 更新前端 API 地址

編輯 `frontend/.env.production`：

```env
# 將 VITE_API_URL 改為 Render.com 的後端 URL
VITE_API_URL=https://order-system-api.onrender.com/api
```

提交變更：

```powershell
git add frontend/.env.production
git commit -m "Update API URL for production"
git push origin main
```

### 4.2 連接 GitHub 倉庫

1. 登入 Vercel Dashboard
2. 點擊「Add New...」→「Project」
3. 點擊「Import Git Repository」
4. 選擇您的 GitHub 倉庫
5. 點擊「Import」

### 4.3 配置專案設定

在「Configure Project」頁面：

#### 基本設定

- **Framework Preset**: 選擇「Vite」
- **Root Directory**: 點擊「Edit」，輸入 `frontend`（子目錄）
- **Build Command**: 保持預設 `npm run build`
- **Output Directory**: 保持預設 `dist`

#### 環境變數

點擊「Environment Variables」區塊，添加：

| Name | Value |
|------|-------|
| `VITE_API_URL` | `https://order-system-api.onrender.com/api` |

（替換為您的 Render.com 後端 URL）

### 4.4 開始部署

1. 點擊「Deploy」
2. ⏳ 等待 2-3 分鐘
3. ✅ 看到「🎉 Congratulations!」表示部署成功
4. 點擊「Visit」查看網站
5. 📋 **記錄 Vercel URL**（例如：`https://order-system-abc123.vercel.app`）

---

## 第五步：測試與驗證

### 5.1 測試前端訪問

1. 開啟 Vercel 提供的 URL
2. ✅ 應該看到登入頁面
3. 使用測試帳號登入：
   - Email: `admin@company.com`
   - Password: `admin999`

### 5.2 驗證功能

#### ✅ 核心功能測試清單

- [ ] 登入/登出功能正常
- [ ] 查看店家列表
- [ ] 創建新揪團
- [ ] 新增訂單
- [ ] 查看分帳明細

#### ⚠️ 首次訪問注意事項

**後端冷啟動問題**：
- Render.com 免費方案會在 15 分鐘無活動後休眠
- 休眠後首次訪問需要等待 **30-60 秒**
- 頁面可能顯示「504 Gateway Timeout」或載入很久
- **解決方法**：重新整理頁面，第二次就會正常

### 5.3 效能優化建議

#### 防止後端休眠（選填）

使用 **UptimeRobot** 或 **Cron-job.org** 定期 ping 後端：

1. 註冊 [https://uptimerobot.com](https://uptimerobot.com)（免費）
2. 添加新監控：
   - **Monitor Type**: HTTP(s)
   - **URL**: `https://order-system-api.onrender.com/api/health`
   - **Monitoring Interval**: 5 分鐘
3. ✅ 這樣後端就不會休眠

---

## 疑難排解

### ❌ 問題 1：後端 500 錯誤

**症狀**：API 請求返回 HTTP 500

**可能原因**：資料庫連接失敗

**解決方法**：
1. 檢查 Render.com 環境變數 `ConnectionStrings__DefaultConnection` 是否正確
2. 前往 Supabase Dashboard 確認資料庫狀態
3. 查看 Render.com Logs 確認錯誤訊息

### ❌ 問題 2：CORS 錯誤

**症狀**：前端顯示「CORS policy blocked」

**解決方法**：
1. 確認後端 `Startup.cs` 已啟用 CORS（`AllowAll` 政策）
2. 檢查 Render.com 環境變數是否正確設定
3. 清除瀏覽器快取後重試

### ❌ 問題 3：前端 404 錯誤

**症狀**：重新整理頁面時顯示 404

**解決方法**：
1. 確認 `frontend/vercel.json` 檔案存在且正確
2. Vercel 會自動重新部署，等待 1-2 分鐘

### ❌ 問題 4：資料庫連接字串格式錯誤

**正確格式**（PostgreSQL）：
```
Host=db.xxxxx.supabase.co;Port=5432;Database=postgres;Username=postgres;Password=yourpassword;SSL Mode=Require;
```

或

```
postgresql://postgres:yourpassword@db.xxxxx.supabase.co:5432/postgres
```

### ❌ 問題 5：中文顯示亂碼

**確認事項**：
1. PostgreSQL 初始化腳本已執行成功
2. 所有字串欄位使用 `VARCHAR` 或 `TEXT`（PostgreSQL 原生支援 UTF-8）
3. 如仍有問題，在 Supabase Dashboard 執行：
   ```sql
   SHOW SERVER_ENCODING;  -- 應顯示 UTF8
   ```

---

## 🎉 完成部署！

### 您的系統現在已上線：

- ✅ **前端 URL**: https://order-system-abc123.vercel.app
- ✅ **後端 API**: https://order-system-api.onrender.com/api
- ✅ **資料庫**: Supabase PostgreSQL (Singapore)

### 📊 資源使用情況

| 服務 | 免費額度 | 使用量 |
|------|---------|--------|
| Vercel | 100GB 流量/月 | ~1-5GB |
| Render.com | 750 小時/月 | 24/7 運行 |
| Supabase | 500MB 資料庫 | ~50-100MB |

### 🔒 安全性建議

1. **修改預設密碼**：
   - 登入後立即修改 `admin@company.com` 密碼
   
2. **更換 JWT Key**：
   - 定期更換 Render.com 環境變數中的 `Jwt__Key`

3. **啟用 HTTPS**：
   - Vercel 和 Render.com 預設已啟用 SSL 證書

4. **資料庫備份**：
   - Supabase 免費方案有自動備份（保留 7 天）

---

## 📝 下一步

### 升級建議（未來可選）

如果系統使用量增加，建議升級：

1. **Render.com → Render.com Starter ($7/月)**
   - 無休眠問題
   - 更穩定的效能

2. **Supabase → Supabase Pro ($25/月)**
   - 8GB 資料庫空間
   - 更多並發連接

### 功能擴充方向

- [ ] 新增 Email 通知功能
- [ ] 整合 LINE Notify
- [ ] 加入 Google Analytics
- [ ] 實作 PWA（Progressive Web App）

---

## 📞 技術支援

### 遇到問題？

1. **查看 Logs**：
   - Render.com Dashboard → Logs
   - Vercel Dashboard → Deployments → View Function Logs

2. **檢查測試報告**：
   - `TestReports/系統測試報告-2026-04-03.md`

3. **參考官方文件**：
   - [Render.com Docs](https://render.com/docs)
   - [Vercel Docs](https://vercel.com/docs)
   - [Supabase Docs](https://supabase.com/docs)

---

**祝您部署順利！** 🚀✨

如有任何問題，請查閱上方的疑難排解區塊。
