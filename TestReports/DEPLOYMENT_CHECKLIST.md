# 🎯 部署前檢查清單

> 在開始部署之前，請逐項確認以下項目

---

## ✅ 程式碼準備

```
[ ] 所有變更已提交到 Git
[ ] 已推送到 GitHub main 分支
[ ] 本地測試通過（前後端正常運作）
[ ] 資料庫連接正常（本地 SQL Server）
```

---

## ✅ 必要檔案檢查

```
[ ] database/backend/Dockerfile
[ ] database/backend/.dockerignore
[ ] database/backend/appsettings.Production.json
[ ] database/backend/OfficeOrderApi.csproj（含 PostgreSQL 支援）
[ ] database/postgresql-init.sql
[ ] frontend/vercel.json
[ ] frontend/.env.production
[ ] render.yaml
[ ] DEPLOYMENT_GUIDE.md
```

---

## ✅ 帳號註冊（三個免費服務）

```
[ ] Supabase 帳號（資料庫）
[ ] Render.com 帳號（後端）
[ ] Vercel 帳號（前端）
[ ] 三個帳號都使用 GitHub 登入
```

---

## ✅ 資料庫部署（Supabase）

```
[ ] 創建新專案（Region: Singapore）
[ ] 設定資料庫密碼並記錄
[ ] 執行 postgresql-init.sql 腳本
[ ] 取得連接字串並保存
[ ] 測試登入（admin@company.com / admin999）
```

---

## ✅ 後端部署（Render.com）

```
[ ] 連接 GitHub 倉庫
[ ] 設定環境變數：
    [ ] ASPNETCORE_ENVIRONMENT = Production
    [ ] ASPNETCORE_URLS = http://+:5000
    [ ] ConnectionStrings__DefaultConnection = [Supabase 連接字串]
    [ ] Jwt__Key = [32字元隨機字串]
    [ ] Jwt__Issuer = OfficeOrderAPI
    [ ] Jwt__Audience = OfficeOrderClient
    [ ] Jwt__ExpiryMinutes = 60
[ ] 等待建置完成（5-10分鐘）
[ ] 記錄後端 URL（https://xxx.onrender.com）
[ ] 測試 API 端點（/api/auth/login）
```

---

## ✅ 前端部署（Vercel）

```
[ ] 更新 frontend/.env.production 的 API URL
[ ] 推送變更到 GitHub
[ ] 連接 GitHub 倉庫
[ ] 設定 Root Directory = frontend
[ ] 設定環境變數 VITE_API_URL
[ ] 等待部署完成（2-3分鐘）
[ ] 記錄前端 URL（https://xxx.vercel.app）
```

---

## ✅ 功能測試

```
[ ] 開啟前端 URL
[ ] 登入測試（admin@company.com / admin999）
[ ] 查看店家列表
[ ] 創建新揪團
[ ] 新增訂單
[ ] 查看分帳明細
[ ] 登出功能
```

---

## ✅ 效能優化（選填）

```
[ ] 註冊 UptimeRobot 防止後端休眠
[ ] 設定每 5 分鐘 ping 一次後端
[ ] 修改管理員密碼（安全性）
```

---

## 🎯 完成指標

### 部署成功條件

- ✅ 前端可正常訪問
- ✅ 登入功能正常
- ✅ 資料庫讀寫正常
- ✅ 所有核心功能可用
- ✅ 無 CORS 錯誤
- ✅ 無 500 伺服器錯誤

### 記錄以下資訊（供日後使用）

| 項目 | URL/資訊 |
|------|----------|
| 前端網址 | https://________________.vercel.app |
| 後端 API | https://________________.onrender.com/api |
| 資料庫 | Supabase Project ID: ________________ |
| GitHub 倉庫 | https://github.com/________________ |
| Jwt Key | ________________________________ |

---

## ⚠️ 已知限制

- 🔴 後端會在 15 分鐘無活動後休眠
- 🟡 休眠後首次訪問需等待 30-60 秒
- 🟢 Vercel 前端不會休眠（永遠在線）
- 🟢 資料庫不會休眠（永遠在線）

---

## 🚨 緊急回退方案

如果部署失敗，可還原至本地環境：

```powershell
# 啟動本地後端
cd D:\github\ORDERS\A_order\database\backend
dotnet run

# 啟動本地前端
cd D:\github\ORDERS\A_order\frontend
npm run dev
```

---

**準備好了嗎？開始部署吧！** 🚀

請打開 `DEPLOYMENT_GUIDE.md` 查看詳細步驟。
