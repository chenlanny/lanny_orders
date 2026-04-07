# ================================================
# Login Issue - Render.com Troubleshooting Guide
# ================================================

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Render.com Backend Troubleshooting" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "資料已確認: ✅ Supabase 中有 6 個用戶，包括 admin@company.com" -ForegroundColor Green
Write-Host "登入狀態: ❌ 後端返回 HTTP 500 錯誤" -ForegroundColor Red
Write-Host ""
Write-Host "原因分析: 後端無法正確訪問資料庫或配置錯誤" -ForegroundColor Yellow
Write-Host ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  STEP 1: 檢查 Render.com Logs（最重要）" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. 開啟 Render Dashboard" -ForegroundColor White
Write-Host "   https://dashboard.render.com" -ForegroundColor Cyan
Write-Host ""

Write-Host "2. 選擇服務: order-system-api-2tve" -ForegroundColor White
Write-Host ""

Write-Host "3. 點擊 'Logs' 頁籤" -ForegroundColor White
Write-Host ""

Write-Host "4. 查看最近的錯誤訊息，特別注意:" -ForegroundColor White
Write-Host "   • 'Connection timeout'" -ForegroundColor Gray
Write-Host "   • 'Authentication failed'" -ForegroundColor Gray
Write-Host "   • 'SSL error'" -ForegroundColor Gray
Write-Host "   • 'Database does not exist'" -ForegroundColor Gray
Write-Host "   • 'Invalid connection string'" -ForegroundColor Gray
Write-Host ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  STEP 2: 檢查環境變數配置" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. 在 Render Dashboard 中" -ForegroundColor White
Write-Host "   order-system-api-2tve → Environment" -ForegroundColor Cyan
Write-Host ""

Write-Host "2. 確認以下變數存在並正確:" -ForegroundColor White
Write-Host ""

Write-Host "   ✓ ConnectionStrings__DefaultConnection" -ForegroundColor Yellow
Write-Host "     應該是: Host=db.idyfbtswixhfahddnlkw.supabase.co;Port=5432;..." -ForegroundColor Cyan
Write-Host ""

Write-Host "   ✓ Jwt__Key" -ForegroundColor Yellow
Write-Host "     應該是: YourSuperSecretKeyForJwtTokenGeneration2026!..." -ForegroundColor Cyan
Write-Host ""

Write-Host "   ✓ ASPNETCORE_ENVIRONMENT" -ForegroundColor Yellow
Write-Host "     應該是: Production" -ForegroundColor Cyan
Write-Host ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  STEP 3: 常見問題檢查清單" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "問題 1: Connection timeout 或無法連接資料庫" -ForegroundColor Yellow
Write-Host "  原因: 連接字串錯誤或 Supabase IP 未授權" -ForegroundColor White
Write-Host "  解決: 重新複製正確的連接字串" -ForegroundColor White
Write-Host "    1. 開啟 Supabase → Database → Connection pooling" -ForegroundColor Cyan
Write-Host "    2. 複製 PostgreSQL connection string" -ForegroundColor Cyan
Write-Host "    3. 貼入 Render.com 環境變數" -ForegroundColor Cyan
Write-Host ""

Write-Host "問題 2: SSL error 或 certificate error" -ForegroundColor Yellow
Write-Host "  原因: SSL 配置不正確" -ForegroundColor White
Write-Host "  解決: 確保連接字串包含: SSL Mode=Require" -ForegroundColor White
Write-Host ""

Write-Host "問題 3: Authentication failed 密碼錯誤" -ForegroundColor Yellow
Write-Host "  原因: Supabase 密碼錯誤" -ForegroundColor White
Write-Host "  解決: 使用正確的 postgres 密碼" -ForegroundColor White
Write-Host ""

Write-Host "問題 4: Render service still starting 服務剛啟動" -ForegroundColor Yellow
Write-Host "  原因: 後端部署需要時間初始化" -ForegroundColor White
Write-Host "  解決: 等待 3-5 分鐘後重試" -ForegroundColor White
Write-Host ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  STEP 4: 重新部署後端（如有修改環境變數）" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. 確認環境變數已正確設定" -ForegroundColor White
Write-Host ""

Write-Host "2. 在 Render Dashboard 點擊:" -ForegroundColor White
Write-Host "   order-system-api-2tve → Manual Deploy → " -ForegroundColor Cyan
Write-Host "   Deploy latest commit" -ForegroundColor Cyan
Write-Host ""

Write-Host "3. 等待部署完成（通常 5-10 分鐘）" -ForegroundColor White
Write-Host ""

Write-Host "4. 部署完成後，查看 Logs 確認是否成功" -ForegroundColor White
Write-Host ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  STEP 5: 重新測試登入" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. 執行測試命令:" -ForegroundColor White
Write-Host ""
Write-Host "   `$body = @{" -ForegroundColor Cyan
Write-Host "       email = 'admin@company.com'" -ForegroundColor Cyan
Write-Host "       password = 'admin123'" -ForegroundColor Cyan
Write-Host "   } | ConvertTo-Json" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Invoke-RestMethod -Uri 'https://order-system-api-2tve.onrender.com/api/auth/login' \" -ForegroundColor Cyan
Write-Host "       -Method Post -Body `$body -ContentType 'application/json'" -ForegroundColor Cyan
Write-Host ""

Write-Host "2. 預期結果:" -ForegroundColor White
Write-Host "   ✅ 返回 token 和用戶資訊 → 問題解決" -ForegroundColor Green
Write-Host "   ❌ 仍然是 500 錯誤 → 繼續檢查 Logs" -ForegroundColor Red
Write-Host ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  連接字串格式（參考）" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "正確格式:" -ForegroundColor White
Write-Host 'Host=db.idyfbtswixhfahddnlkw.supabase.co;Port=5432;Database=postgres;Username=postgres;Password=YOUR_PASSWORD;SSL Mode=Require;Timeout=15;Command Timeout=15;Max Pool Size=5;Connection Idle Lifetime=5;' -ForegroundColor Cyan
Write-Host ""

Write-Host "其中 YOUR_PASSWORD 應替換為 Supabase 的實際密碼" -ForegroundColor Yellow
Write-Host ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "建議順序:"
Write-Host "1️⃣  首先檢查 Render.com Logs（STEP 1）" -ForegroundColor White
Write-Host "2️⃣  查看具體錯誤訊息，根據錯誤修復" -ForegroundColor White
Write-Host "3️⃣  如有修改環境變數，執行重新部署（STEP 4）" -ForegroundColor White
Write-Host "4️⃣  等待 3-5 分鐘後重新測試（STEP 5）" -ForegroundColor White
Write-Host ""
