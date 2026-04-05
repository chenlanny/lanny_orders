# 🚀 快速部署參考卡

> **5 分鐘快速查詢表** - 打印此頁貼在螢幕旁！

---

## 📝 部署順序（不可顛倒）

```
1. Supabase   → 取得資料庫連接字串
2. Render.com → 取得後端 API URL
3. Vercel     → 完成前端部署
```

---

## 🔑 Supabase 操作（5 分鐘）

```
1. 創建專案（Singapore）
2. SQL Editor → 貼上 database/postgresql-init.sql → Run
3. Settings → Database → 複製 Connection URI
```

**連接字串範例**：
```
postgresql://postgres:[密碼]@db.xxxxx.supabase.co:5432/postgres
```

---

## ⚙️ Render.com 環境變數（必填 8 個）

| Key | Value |
|-----|-------|
| `ASPNETCORE_ENVIRONMENT` | `Production` |
| `ASPNETCORE_URLS` | `http://+:5000` |
| `ConnectionStrings__DefaultConnection` | `[Supabase 連接字串]` |
| `Jwt__Key` | `[32 字元隨機字串]` |
| `Jwt__Issuer` | `OfficeOrderAPI` |
| `Jwt__Audience` | `OfficeOrderClient` |
| `Jwt__ExpiryMinutes` | `60` |

**產生 JWT Key**（PowerShell）：
```powershell
-join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | % {[char]$_})
```

---

## 🌐 Vercel 設定

**Root Directory**: `frontend`

**環境變數**：
```
VITE_API_URL = https://[Render URL].onrender.com/api
```

**別忘了**：先更新 `frontend/.env.production` 再推送 GitHub！

---

## 🧪 測試帳號

```
Email: admin@company.com
Password: admin999
```

---

## ⏱️ 預計等待時間

- Supabase 初始化：1-2 分鐘
- Render.com 建置：5-10 分鐘（首次）
- Vercel 部署：2-3 分鐘

---

## ⚠️ 後端休眠問題

**症狀**：首次訪問等很久  
**原因**：15 分鐘無活動會休眠  
**解決**：註冊 UptimeRobot 每 5 分鐘 ping 一次

**UptimeRobot 設定**：
```
URL: https://[Render URL].onrender.com/api/health
Interval: 5 分鐘
```

---

## 🔍 快速偵錯

### 問題：後端 500 錯誤
```
→ 檢查 Render.com Logs
→ 確認資料庫連接字串正確
→ 確認已執行 PostgreSQL 初始化腳本
```

### 問題：CORS 錯誤
```
→ 確認環境變數設定
→ 清除瀏覽器快取
→ 檢查 Render.com Logs
```

### 問題：前端白屏
```
→ 檢查 Vercel Logs
→ 確認 VITE_API_URL 正確
→ 確認 vercel.json 已提交
```

---

## 📱 重要 URL 記錄

| 項目 | URL |
|------|-----|
| Supabase Dashboard | https://app.supabase.com |
| Render Dashboard | https://dashboard.render.com |
| Vercel Dashboard | https://vercel.com/dashboard |
| 前端網址 | _____________________ |
| 後端 API | _____________________ |

---

## 🆘 緊急回退

```powershell
# 本地後端
cd D:\github\ORDERS\A_order\database\backend
dotnet run

# 本地前端
cd D:\github\ORDERS\A_order\frontend
npm run dev
```

---

**更多詳細資訊請查看**：`DEPLOYMENT_GUIDE.md`

**打印此頁並貼在螢幕旁，部署時隨時查看！** 📌
