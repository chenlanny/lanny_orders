# 刪除「午夜快閃團」測試資料 PowerShell 腳本

# 1. 登入管理員帳號
$loginBody = @{
    email = "admin@company.com"
    password = "admin999"
} | ConvertTo-Json

$loginResponse = Invoke-RestMethod -Uri "http://localhost:5000/api/auth/login" `
    -Method Post `
    -ContentType "application/json" `
    -Body $loginBody

$token = $loginResponse.data.token
Write-Host "已登入，Token: $token"

# 2. 查詢所有活動
$headers = @{
    "Authorization" = "Bearer $token"
}

$events = Invoke-RestMethod -Uri "http://localhost:5000/api/events" `
    -Method Get `
    -Headers $headers

Write-Host "`n所有活動："
$events.data | ForEach-Object {
    Write-Host "EventId: $($_.eventId), Title: $($_.title), Status: $($_.status)"
}

# 3. 查找「午夜快閃團」
$targetEvent = $events.data | Where-Object { $_.title -like "*午夜*" -or $_.title -like "*快閃*" }

if ($targetEvent) {
    Write-Host "`n找到目標活動: EventId = $($targetEvent.eventId), Title = $($targetEvent.title)"
    
    # 確認是否要刪除
    $confirm = Read-Host "確認要刪除此活動嗎？(Y/N)"
    
    if ($confirm -eq 'Y' -or $confirm -eq 'y') {
        # 刪除活動（如果有對應的 API）
        # 注意：目前後端可能沒有刪除活動的 API，需要先確認
        Write-Host "注意：後端可能沒有實作刪除活動的 API！"
        Write-Host "EventId: $($targetEvent.eventId)"
        Write-Host "請手動使用 SQL 刪除或透過揪團管理頁面取消活動"
    } else {
        Write-Host "已取消刪除操作"
    }
} else {
    Write-Host "`n未找到包含「午夜」或「快閃」的活動"
}
