# 測試創建揪團API

# 1. 登入取得token
Write-Host "正在登入..." -ForegroundColor Yellow
$loginUrl = "http://localhost:5000/api/auth/login"
$loginBody = @{
    email = "admin@company.com"
    password = "admin999"
} | ConvertTo-Json

$loginResponse = Invoke-RestMethod -Uri $loginUrl -Method POST -Body $loginBody -ContentType "application/json"
$token = $loginResponse.data.token
Write-Host "登入成功！Token: $($token.Substring(0,20))..." -ForegroundColor Green

# 2. 準備揪團資料
Write-Host "`n準備創建揪團資料..." -ForegroundColor Yellow
$deadline1 = (Get-Date).AddHours(2).ToString("yyyy-MM-ddTHH:mm:ss")
$deadline2 = (Get-Date).AddHours(3).ToString("yyyy-MM-ddTHH:mm:ss")

$eventData = @{
    title = "測試揪團"
    notes = "測試用"
    orderGroups = @(
        @{
            storeId = 1
            deadline = $deadline1
            deliveryFee = 30
        },
        @{
            storeId = 2
            deadline = $deadline2
            deliveryFee = 40
        }
    )
} | ConvertTo-Json -Depth 5

Write-Host "發送資料:" -ForegroundColor Cyan
Write-Host $eventData

# 3. 創建揪團
Write-Host "`n正在創建揪團..." -ForegroundColor Yellow
$eventUrl = "http://localhost:5000/api/events"
$headers = @{
    Authorization = "Bearer $token"
}

try {
    $response = Invoke-RestMethod -Uri $eventUrl -Method POST -Headers $headers -Body $eventData -ContentType "application/json"
    Write-Host "`n✓ 揪團創建成功！" -ForegroundColor Green
    Write-Host ($response | ConvertTo-Json -Depth 5)
} catch {
    Write-Host "`n✗ 揪團創建失敗！" -ForegroundColor Red
    Write-Host "錯誤: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        Write-Host "詳細: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
}
