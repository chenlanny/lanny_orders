# System Test Script
# Date: 2026-04-03

$ErrorActionPreference = "Continue"
$testResults = @()

Write-Output "========================================="
Write-Output "  System Comprehensive Test"
Write-Output "========================================="
Write-Output ""

# Login and get token
Write-Output "[Setup] Logging in..."
try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:5000/api/auth/login" `
        -Method Post `
        -ContentType "application/json" `
        -Body '{"email":"admin@company.com","password":"admin999"}'
    
    $token = $loginResponse.data.token
    $headers = @{"Authorization"="Bearer $token"}
    Write-Output "[準備] 登錄成功"
} catch {
    Write-Output "[錯誤] 登錄失敗: $($_.Exception.Message)"
    exit 1
}

Write-Output ""
Write-Output "========================================="
Write-Output "測試1: 建立揪團驗證"
Write-Output "========================================="

# 測試1-A: 創建過去日期揪團（應該失敗）
Write-Output "[測試1-A] 驗證拒絕過去日期..."
$pastDate = (Get-Date).AddDays(-1).ToString("yyyy-MM-ddTHH:mm:ss")
$body1a = @{
    title = "測試過去日期揪團"
    notes = "測試：不應允許過去日期"
    orderGroups = @(
        @{
            storeId = 1
            deadline = $pastDate
            deliveryFee = 0
        }
    )
} | ConvertTo-Json

try {
    $result = Invoke-RestMethod -Uri "http://localhost:5000/api/events" `
        -Method Post `
        -Headers $headers `
        -ContentType "application/json" `
        -Body $body1a
    $testResults += "[FAIL] 測試1-A: 系統允許創建過去日期（應拒絕）"
    Write-Output "  結果: FAIL - 系統允許了過去日期"
} catch {
    $testResults += "[PASS] 測試1-A: 正確拒絕過去日期"
    Write-Output "  結果: PASS - 正確拒絕過去日期"
}

# 測試1-B: 創建正常揪團
Write-Output "[測試1-B] 創建正常揪團..."
$futureDate1 = (Get-Date).AddHours(2).ToString("yyyy-MM-ddTHH:mm:ss")
$body1b = @{
    title = "測試正常揪團-店家1"
    notes = "正常測試揪團"
    orderGroups = @(
        @{
            storeId = 1
            deadline = $futureDate1
            deliveryFee = 30
        }
    )
} | ConvertTo-Json

try {
    $event1 = Invoke-RestMethod -Uri "http://localhost:5000/api/events" `
        -Method Post `
        -Headers $headers `
        -ContentType "application/json" `
        -Body $body1b
    $eventId1 = $event1.data.eventId
    $testResults += "[PASS] 測試1-B: 成功創建正常揪團 (ID: $eventId1)"
    Write-Output "  結果: PASS - 揪團ID: $eventId1"
} catch {
    $testResults += "[FAIL] 測試1-B: 創建正常揪團失敗 - $($_.Exception.Message)"
    Write-Output "  結果: FAIL - $($_.Exception.Message)"
    $eventId1 = $null
}

# 測試1-C: 同一揪團中不能有重複店家
Write-Output "[測試1-C] 驗證同一揪團不能有重複店家..."
$futureDate2 = (Get-Date).AddHours(3).ToString("yyyy-MM-ddTHH:mm:ss")
$body1c = @{
    title = "測試重複店家揪團"
    notes = "測試：同一揪團有兩個相同店家"
    orderGroups = @(
        @{
            storeId = 1
            deadline = $futureDate2
            deliveryFee = 30
        },
        @{
            storeId = 1
            deadline = $futureDate2
            deliveryFee = 40
        }
    )
} | ConvertTo-Json

try {
    $result = Invoke-RestMethod -Uri "http://localhost:5000/api/events" `
        -Method Post `
        -Headers $headers `
        -ContentType "application/json" `
        -Body $body1c
    $testResults += "[FAIL] 測試1-C: 系統允許重複店家（應拒絕）"
    Write-Output "  結果: FAIL - 系統允許了重複店家"
} catch {
    $testResults += "[PASS] 測試1-C: 正確拒絕重複店家"
    Write-Output "  結果: PASS - 正確拒絕重複店家"
}

# 測試1-D: 創建多店家揪團（用於後續測試）
Write-Output "[測試1-D] 創建多店家揪團（測試用）..."
$futureDate3 = (Get-Date).AddHours(5).ToString("yyyy-MM-ddTHH:mm:ss")
$body1d = @{
    title = "多店家測試揪團"
    notes = "包含兩家不同店家"
    orderGroups = @(
        @{
            storeId = 1
            deadline = $futureDate3
            deliveryFee = 30
        },
        @{
            storeId = 2
            deadline = $futureDate3
            deliveryFee = 35
        }
    )
} | ConvertTo-Json

try {
    $event2 = Invoke-RestMethod -Uri "http://localhost:5000/api/events" `
        -Method Post `
        -Headers $headers `
        -ContentType "application/json" `
        -Body $body1d
    $eventId2 = $event2.data.eventId
    $groupId1 = $event2.data.orderGroups[0].groupId
    $groupId2 = $event2.data.orderGroups[1].groupId
    $testResults += "[PASS] 測試1-D: 成功創建多店家揪團 (ID: $eventId2)"
    Write-Output "  結果: PASS - 揪團ID: $eventId2, Group1: $groupId1, Group2: $groupId2"
} catch {
    $testResults += "[FAIL] 測試1-D: 創建多店家揪團失敗"
    Write-Output "  結果: FAIL - $($_.Exception.Message)"
    $eventId2 = $null
}

# 測試1-E: 創建即將截止的揪團（用於測試截止時間）
Write-Output "[測試1-E] 創建即將截止的揪團..."
$pastDeadline = (Get-Date).AddMinutes(-5).ToString("yyyy-MM-ddTHH:mm:ss")
$body1e = @{
    title = "已截止測試揪團"
    notes = "截止時間已過"
    orderGroups = @(
        @{
            storeId = 3
            deadline = $pastDeadline
            deliveryFee = 0
        }
    )
} | ConvertTo-Json

try {
    $event3 = Invoke-RestMethod -Uri "http://localhost:5000/api/events" `
        -Method Post `
        -Headers $headers `
        -ContentType "application/json" `
        -Body $body1e
    $eventId3 = $event3.data.eventId
    $testResults += "[PASS] 測試1-E: 成功創建已截止揪團 (ID: $eventId3)"
    Write-Output "  結果: PASS - 揪團ID: $eventId3 (用於測試截止邏輯)"
} catch {
    $testResults += "[INFO] 測試1-E: 無法創建已截止揪團（後端可能不允許）"
    Write-Output "  結果: INFO - 後端拒絕創建（這是合理的）"
    $eventId3 = $null
}

Write-Output ""
Write-Output "========================================="
Write-Output "測試2: 使用者訂購"
Write-Output "========================================="

if ($eventId2 -and $groupId1 -and $groupId2) {
    # 測試2-A: 正常訂購（店家1）
    Write-Output "[測試2-A] 在店家1訂購飲料..."
    $order2a = @{
        groupId = $groupId1
        items = @(
            @{
                itemId = 1
                sizeCode = "M"
                quantity = 2
                customOptions = "少糖"
                toppings = @("珍珠")
                note = "測試訂單1"
            }
        )
    } | ConvertTo-Json -Depth 5

    try {
        $orderResult1 = Invoke-RestMethod -Uri "http://localhost:5000/api/events/$eventId2/orders" `
            -Method Post `
            -Headers $headers `
            -ContentType "application/json" `
            -Body $order2a
        $testResults += "[PASS] 測試2-A: 成功在店家1訂購"
        Write-Output "  結果: PASS - 訂單已提交"
    } catch {
        $testResults += "[FAIL] 測試2-A: 店家1訂購失敗 - $($_.Exception.Message)"
        Write-Output "  結果: FAIL - $($_.Exception.Message)"
    }

    # 測試2-B: 同時訂購店家2
    Write-Output "[測試2-B] 在店家2訂購飲料..."
    $order2b = @{
        groupId = $groupId2
        items = @(
            @{
                itemId = 7
                sizeCode = "L"
                quantity = 1
                customOptions = "正常"
                toppings = @()
                note = "測試訂單2"
            }
        )
    } | ConvertTo-Json -Depth 5

    try {
        $orderResult2 = Invoke-RestMethod -Uri "http://localhost:5000/api/events/$eventId2/orders" `
            -Method Post `
            -Headers $headers `
            -ContentType "application/json" `
            -Body $order2b
        $testResults += "[PASS] 測試2-B: 成功在店家2訂購"
        Write-Output "  結果: PASS - 已支援多店家訂購"
    } catch {
        $testResults += "[FAIL] 測試2-B: 店家2訂購失敗 - $($_.Exception.Message)"
        Write-Output "  結果: FAIL - $($_.Exception.Message)"
    }
} else {
    $testResults += "[SKIP] 測試2: 因測試1-D失敗，跳過訂購測試"
    Write-Output "  結果: SKIP - 缺少測試用揪團"
}

# 測試2-C: 截止後訂購（如果有已截止揪團）
if ($eventId3) {
    Write-Output "[測試2-C] 驗證截止後無法訂購..."
    $order2c = @{
        groupId = $eventId3
        items = @(
            @{
                itemId = 15
                sizeCode = "單點"
                quantity = 1
                customOptions = ""
                toppings = @()
                note = "測試截止訂單"
            }
        )
    } | ConvertTo-Json -Depth 5

    try {
        $result = Invoke-RestMethod -Uri "http://localhost:5000/api/events/$eventId3/orders" `
            -Method Post `
            -Headers $headers `
            -ContentType "application/json" `
            -Body $order2c
        $testResults += "[FAIL] 測試2-C: 系統允許截止後訂購（應拒絕）"
        Write-Output "  結果: FAIL - 允許了截止後訂購"
    } catch {
        $testResults += "[PASS] 測試2-C: 正確拒絕截止後訂購"
        Write-Output "  結果: PASS - 正確拒絕"
    }
} else {
    $testResults += "[SKIP] 測試2-C: 無已截止揪團可測試"
    Write-Output "  結果: SKIP"
}

Write-Output ""
Write-Output "========================================="
Write-Output "測試3: 購物車統計"
Write-Output "========================================="

if ($eventId2) {
    Write-Output "[測試3] 取得揪團統計資料..."
    try {
        $summary = Invoke-RestMethod -Uri "http://localhost:5000/api/events/$eventId2/summary" `
            -Method Get `
            -Headers $headers
        
        $totalAmount = $summary.data.totalAmount
        $participantCount = $summary.data.participantCount
        $itemCount = $summary.data.orderItems.Count
        
        $testResults += "[PASS] 測試3: 成功取得統計 (參與人數: $participantCount, 品項數: $itemCount, 總金額: $$totalAmount)"
        Write-Output "  結果: PASS"
        Write-Output "    - 參與人數: $participantCount"
        Write-Output "    - 訂購品項數: $itemCount"
        Write-Output "    - 總金額: $$totalAmount"
    } catch {
        $testResults += "[FAIL] 測試3: 取得統計失敗 - $($_.Exception.Message)"
        Write-Output "  結果: FAIL - $($_.Exception.Message)"
    }
} else {
    $testResults += "[SKIP] 測試3: 無測試用揪團"
    Write-Output "  結果: SKIP"
}

Write-Output ""
Write-Output "========================================="
Write-Output "測試4: 歷史訂單查詢"
Write-Output "========================================="

Write-Output "[測試4] 查詢所有活動（含已截止）..."
try {
    $allEvents = Invoke-RestMethod -Uri "http://localhost:5000/api/events" `
        -Method Get `
        -Headers $headers
    
    $openCount = ($allEvents.data | Where-Object { $_.status -eq "Open" }).Count
    $closedCount = ($allEvents.data | Where-Object { $_.status -eq "Closed" }).Count
    
    $testResults += "[PASS] 測試4: 成功查詢歷史訂單 (進行中: $openCount, 已結單: $closedCount)"
    Write-Output "  結果: PASS"
    Write-Output "    - 進行中: $openCount"
    Write-Output "    - 已結單: $closedCount"
} catch {
    $testResults += "[FAIL] 測試4: 查詢歷史訂單失敗 - $($_.Exception.Message)"
    Write-Output "  結果: FAIL - $($_.Exception.Message)"
}

Write-Output ""
Write-Output "========================================="
Write-Output "測試5: 統計資料呈現"
Write-Output "========================================="

Write-Output "[測試5-A] 查詢所有店家..."
try {
    $stores = Invoke-RestMethod -Uri "http://localhost:5000/api/stores" `
        -Method Get `
        -Headers $headers
    
    $storeCount = $stores.data.Count
    $testResults += "[PASS] 測試5-A: 成功查詢店家資料 (共 $storeCount 家)"
    Write-Output "  結果: PASS - 共 $storeCount 家店"
} catch {
    $testResults += "[FAIL] 測試5-A: 查詢店家失敗 - $($_.Exception.Message)"
    Write-Output "  結果: FAIL - $($_.Exception.Message)"
}

Write-Output "[測試5-B] 查詢店家菜單..."
try {
    $menu = Invoke-RestMethod -Uri "http://localhost:5000/api/stores/1/menu" `
        -Method Get `
        -Headers $headers
    
    $menuItemCount = $menu.data.Count
    $testResults += "[PASS] 測試5-B: 成功查詢菜單 (共 $menuItemCount 項)"
    Write-Output "  結果: PASS - 店家1有 $menuItemCount 項品項"
} catch {
    $testResults += "[FAIL] 測試5-B: 查詢菜單失敗 - $($_.Exception.Message)"
    Write-Output "  結果: FAIL - $($_.Exception.Message)"
}

Write-Output ""
Write-Output "========================================="
Write-Output "測試總結"
Write-Output "========================================="
Write-Output ""

$passCount = ($testResults | Where-Object { $_ -like "[PASS]*" }).Count
$failCount = ($testResults | Where-Object { $_ -like "[FAIL]*" }).Count
$skipCount = ($testResults | Where-Object { $_ -like "[SKIP]*" }).Count
$totalCount = $passCount + $failCount + $skipCount

foreach ($result in $testResults) {
    Write-Output $result
}

Write-Output ""
Write-Output "總計: $totalCount 項測試"
Write-Output "  通過: $passCount"
Write-Output "  失敗: $failCount"
Write-Output "  跳過: $skipCount"
Write-Output ""

if ($failCount -eq 0) {
    Write-Output "========================================="
    Write-Output "  ✓ 所有測試通過！系統運作正常"
    Write-Output "========================================="
    exit 0
} else {
    Write-Output "========================================="
    Write-Output "  ✗ 發現 $failCount 項失敗，需要修復"
    Write-Output "========================================="
    exit 1
}
