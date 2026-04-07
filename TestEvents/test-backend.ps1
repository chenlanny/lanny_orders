# 後端 API 快速測試腳本
Write-Host ""
Write-Host "=== 測試後端 API ===" -ForegroundColor Cyan
Write-Host ""

$apiUrl = "https://order-system-api-2tve.onrender.com/api/stores"

Write-Host "正在測試: $apiUrl" -ForegroundColor Yellow
Write-Host "（首次訪問可能需要 30-60 秒喚醒服務...）" -ForegroundColor Yellow
Write-Host ""

try {
    $response = Invoke-WebRequest -Uri $apiUrl -Method Get -UseBasicParsing -TimeoutSec 60
    Write-Host "✅ 後端 API 正常運行！" -ForegroundColor Green
    Write-Host "狀態碼: $($response.StatusCode)" -ForegroundColor White
    Write-Host ""
    Write-Host "現在可以登入前端了！" -ForegroundColor Green
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    
    if ($statusCode -eq 401) {
        Write-Host "✅ 後端 API 正常運行（需要授權）！" -ForegroundColor Green
        Write-Host "狀態碼: 401 Unauthorized（正常）" -ForegroundColor White
        Write-Host ""
        Write-Host "現在可以登入前端了！" -ForegroundColor Green
    } elseif ($statusCode -eq 503) {
        Write-Host "⚠️  後端服務正在喚醒中..." -ForegroundColor Yellow
        Write-Host "請等待 30 秒後再次執行此腳本" -ForegroundColor Yellow
    } else {
        Write-Host "❌ 後端 API 錯誤" -ForegroundColor Red
        Write-Host "狀態碼: $statusCode" -ForegroundColor Red
        Write-Host "錯誤訊息: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
        Write-Host "建議檢查 Render.com 服務狀態和環境變數" -ForegroundColor Yellow
    }
}

Write-Host ""
