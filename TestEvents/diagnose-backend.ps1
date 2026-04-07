# 完整診斷腳本
Write-Host ""
Write-Host "=== 後端 API 完整診斷 ===" -ForegroundColor Cyan
Write-Host ""

# 測試 1: 基本連線
Write-Host "[1/3] 測試基本連線..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://order-system-api-2tve.onrender.com/api/stores" -UseBasicParsing -TimeoutSec 30
    Write-Host "  ✅ API 運行中 (狀態: $($response.StatusCode))" -ForegroundColor Green
} catch {
    $code = $_.Exception.Response.StatusCode.value__
    if ($code -eq 401) {
        Write-Host "  ✅ API 運行中 (需要授權)" -ForegroundColor Green
    } else {
        Write-Host "  ❌ 連線失敗 (狀態: $code)" -ForegroundColor Red
    }
}

Write-Host ""

# 測試 2: 登入功能
Write-Host "[2/3] 測試登入 API..." -ForegroundColor Yellow
$body = @{
    email = "admin@company.com"
    password = "admin999"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest `
        -Uri "https://order-system-api-2tve.onrender.com/api/auth/login" `
        -Method POST `
        -Body $body `
        -ContentType "application/json" `
        -UseBasicParsing
    
    Write-Host "  ✅ 登入成功！" -ForegroundColor Green
    $content = $response.Content | ConvertFrom-Json
    Write-Host "  用戶: $($content.user.name)" -ForegroundColor Cyan
    Write-Host "  角色: $($content.user.role)" -ForegroundColor Cyan
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $errorBody = ""
    
    try {
        $stream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($stream)
        $errorBody = $reader.ReadToEnd()
    } catch {}
    
    Write-Host "  ❌ 登入失敗" -ForegroundColor Red
    Write-Host "  狀態碼: $statusCode" -ForegroundColor Yellow
    
    if ($statusCode -eq 400) {
        Write-Host "  原因: 密碼錯誤或格式不正確" -ForegroundColor Yellow
        Write-Host "  建議: 在 Supabase 重設密碼" -ForegroundColor Yellow
    } elseif ($statusCode -eq 500) {
        Write-Host "  原因: 後端伺服器錯誤" -ForegroundColor Yellow
        Write-Host "  可能問題:" -ForegroundColor Yellow
        Write-Host "    - 資料庫連接失敗 (環境變數格式錯誤)" -ForegroundColor Gray
        Write-Host "    - Render.com 還在部署中" -ForegroundColor Gray
        Write-Host "    - BCrypt 密碼驗證失敗" -ForegroundColor Gray
        Write-Host ""
        Write-Host "  建議動作:" -ForegroundColor Cyan
        Write-Host "    1. 檢查 Render.com Logs" -ForegroundColor White
        Write-Host "    2. 確認環境變數格式正確" -ForegroundColor White
        Write-Host "    3. 等待部署完成（如果剛修改）" -ForegroundColor White
    }
    
    if ($errorBody) {
        Write-Host "  詳細錯誤: $errorBody" -ForegroundColor Gray
    }
}

Write-Host ""

# 測試 3: 建議
Write-Host "[3/3] 檢查建議" -ForegroundColor Yellow
Write-Host "  → 前往 Render.com Logs 查看詳細錯誤" -ForegroundColor White
Write-Host "    https://dashboard.render.com/web/srv-ctrlrh0gph6c73cbhrag/logs" -ForegroundColor Gray
Write-Host ""
Write-Host "  → 確認環境變數格式" -ForegroundColor White
Write-Host "    https://dashboard.render.com/web/srv-ctrlrh0gph6c73cbhrag/env" -ForegroundColor Gray
Write-Host ""
