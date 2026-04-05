# 目錄整理腳本
Set-Location "D:\github\ORDERS\A_order"

# 創建資料夾
Write-Host "創建資料夾..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path "D:\github\ORDERS\A_order\測試事件" -Force | Out-Null
New-Item -ItemType Directory -Path "D:\github\ORDERS\A_order\測試報告" -Force | Out-Null

# 移動 JSON 文件
Write-Host "移動 JSON 測試文件..." -ForegroundColor Yellow
$jsonFiles = @("pool_bento_menu.json", "store1_menu.json", "test-event.json", "test_store1_output.json", "wutao_bento_menu.json")
foreach ($file in $jsonFiles) {
    if (Test-Path $file) {
        Move-Item -Path $file -Destination "測試事件\" -Force
        Write-Host "  ✓ $file"
    }
}

# 移動 PowerShell 測試腳本
Write-Host "移動 PowerShell 測試腳本..." -ForegroundColor Yellow
$ps1Files = @("test-create-event.ps1", "test-event-detail.ps1", "test-menu-api.ps1")
foreach ($file in $ps1Files) {
    if (Test-Path $file) {
        Move-Item -Path $file -Destination "測試事件\" -Force
        Write-Host "  ✓ $file"
    }
}

# 移動測試報告
Write-Host "移動測試報告文檔..." -ForegroundColor Yellow
$mdFiles = @("便當菜單新增報告.md", "截止時間顯示測試說明.md", "繁體中文測試報告.md", "繁體中文編碼說明.md")
foreach ($file in $mdFiles) {
    if (Test-Path $file) {
        Move-Item -Path $file -Destination "測試報告\" -Force
        Write-Host "  ✓ $file"
    }
}

Write-Host "`n✓ 整理完成！" -ForegroundColor Green

# 顯示結果
Write-Host "`n=== 測試事件資料夾內容 ===" -ForegroundColor Cyan
Get-ChildItem "測試事件" | Select-Object Name, Length | Format-Table -AutoSize

Write-Host "=== 測試報告資料夾內容 ===" -ForegroundColor Cyan
Get-ChildItem "測試報告" | Select-Object Name, Length | Format-Table -AutoSize
