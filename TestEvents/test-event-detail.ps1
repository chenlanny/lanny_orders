# 測試事件詳情API
$loginUrl = "http://localhost:5000/api/auth/login"
$loginBody = '{"email":"admin@company.com","password":"admin999"}'
$r = Invoke-RestMethod -Uri $loginUrl -Method POST -Body $loginBody -ContentType "application/json"
$token = $r.data.token

$eventUrl = "http://localhost:5000/api/events/1"
$headers = @{ Authorization = "Bearer $token" }
$event = Invoke-RestMethod -Uri $eventUrl -Headers $headers

Write-Host "=== Event Details ===" -ForegroundColor Green
Write-Host "Title: $($event.data.title)"
Write-Host "Status: $($event.data.status)"
Write-Host ""

Write-Host "=== OrderGroups ===" -ForegroundColor Yellow
$event.data.orderGroups | ConvertTo-Json -Depth 3

Write-Host "`n=== Test Store Menu API ===" -ForegroundColor Cyan
$storeId = $event.data.orderGroups[0].storeId
$menuUrl = "http://localhost:5000/api/stores/$storeId/menu"
try {
    $menu = Invoke-RestMethod -Uri $menuUrl -Headers $headers
    Write-Host "Menu API Success: $($menu.success)"
    Write-Host "Menu Items Count: $($menu.data.Length)"
} catch {
    Write-Host "Menu API Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host $_.ErrorDetails.Message -ForegroundColor Red
}
