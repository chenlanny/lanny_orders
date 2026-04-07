# Render.com 部署完成後測試腳本
Write-Host ""
Write-Host "=== 等待 10 分鐘後執行此測試 ===" -ForegroundColor Yellow
Write-Host ""

$body = @{
    email = "admin@company.com"
    password = "admin999"
} | ConvertTo-Json

Write-Host "測試登入 API..." -ForegroundColor Cyan

try {
    $response = Invoke-WebRequest -Uri "https://order-system-api-2tve.onrender.com/api/auth/login" `
                                   -Method POST `
                                   -Body $body `
                                   -ContentType "application/json" `
                                   -UseBasicParsing
    
    Write-Host "✅ 登入成功！" -ForegroundColor Green
    Write-Host "狀態碼: $($response.StatusCode)" -ForegroundColor White
    $content = $response.Content | ConvertFrom-Json
    Write-Host "用戶: $($content.user.name)" -ForegroundColor Cyan
    Write-Host "Token 已取得" -ForegroundColor Cyan
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    
    if ($statusCode -eq 400) {
        Write-Host "⚠️  密碼錯誤（但 API 正常）" -ForegroundColor Yellow
        Write-Host "需要在 Supabase 重設密碼" -ForegroundColor Yellow
    } elseif ($statusCode -eq 401) {
        Write-Host "⚠️  未授權（但 API 正常）" -ForegroundColor Yellow
        Write-Host "請檢查帳號密碼" -ForegroundColor Yellow
    } elseif ($statusCode -eq 500) {
        Write-Host "❌ 後端伺服器錯誤" -ForegroundColor Red
        Write-Host "請檢查 Render.com Logs" -ForegroundColor Red
    } else {
        Write-Host "❌ 錯誤" -ForegroundColor Red
        Write-Host "狀態碼: $statusCode" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
}

Write-Host ""
