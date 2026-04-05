# 迷克夏店家建立與菜單設定腳本
# Date: 2026-04-03

$baseUrl = "http://localhost:5000/api"

# 登入
$loginBody = '{"email":"admin@company.com","password":"admin999"}'
$login = Invoke-RestMethod -Uri "$baseUrl/auth/login" -Method Post -ContentType "application/json" -Body $loginBody
$headers = @{"Authorization"="Bearer $($login.data.token)"}
Write-Host "[OK] Logged in" -ForegroundColor Green

# Step 1: 創建迷克夏店家
Write-Host "`n[Step 1] Creating 迷克夏 store..." -ForegroundColor Cyan
$storeBody = @{
    name = "迷克夏"
    category = "Drink"
    phone = "02-2345-6789"
    address = "台北市大安區"
} | ConvertTo-Json

try {
    $store = Invoke-RestMethod -Uri "$baseUrl/stores" -Method Post -Headers $headers -ContentType "application/json" -Body $storeBody
    $storeId = $store.data.storeId
    Write-Host "[OK] Store created: ID=$storeId, Name=$($store.data.storeName)" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to create store" -ForegroundColor Red
    exit 1
}

# Step 2: 添加菜單品項
Write-Host "`n[Step 2] Adding menu items..." -ForegroundColor Cyan

$menuItems = @(
    @{
        itemName = "迷克珍珠"
        category = "珍奶系列"
        priceRules = '{"小杯":45,"中杯":50,"大杯":60}'
        options = '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":0},{"name":"椰果","price":5}]}'
        isAvailable = $true
    },
    @{
        itemName = "迷克奶茶"
        category = "奶茶系列"
        priceRules = '{"小杯":40,"中杯":45,"大杯":55}'
        options = '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10},{"name":"椰果","price":5}]}'
        isAvailable = $true
    },
    @{
        itemName = "觀音拿鐵"
        category = "拿鐵系列"
        priceRules = '{"中杯":55,"大杯":65}'
        options = '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10}]}'
        isAvailable = $true
    },
    @{
        itemName = "烏龍奶茶"
        category = "奶茶系列"
        priceRules = '{"小杯":40,"中杯":45,"大杯":55}'
        options = '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10}]}'
        isAvailable = $true
    },
    @{
        itemName = "紅茶拿鐵"
        category = "拿鐵系列"
        priceRules = '{"中杯":50,"大杯":60}'
        options = '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10}]}'
        isAvailable = $true
    },
    @{
        itemName = "綠茶拿鐵"
        category = "拿鐵系列"
        priceRules = '{"中杯":50,"大杯":60}'
        options = '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"]}'
        isAvailable = $true
    },
    @{
        itemName = "冬瓜檸檬"
        category = "果茶系列"
        priceRules = '{"中杯":45,"大杯":55}'
        options = '{"sweetness":["正常","少糖","微糖"],"temperature":["正常冰","少冰","微冰","去冰"]}'
        isAvailable = $true
    },
    @{
        itemName = "金萱青茶"
        category = "茶飲系列"
        priceRules = '{"中杯":30,"大杯":35,"瓶裝":40}'
        options = '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"]}'
        isAvailable = $true
    },
    @{
        itemName = "茉莉綠茶"
        category = "茶飲系列"
        priceRules = '{"中杯":25,"大杯":30,"瓶裝":35}'
        options = '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"]}'
        isAvailable = $true
    },
    @{
        itemName = "蜂蜜檸檬"
        category = "果茶系列"
        priceRules = '{"中杯":50,"大杯":60}'
        options = '{"sweetness":["正常","少糖"],"temperature":["正常冰","少冰","微冰","去冰"]}'
        isAvailable = $true
    }
)

$successCount = 0
foreach ($item in $menuItems) {
    $menuBody = $item | ConvertTo-Json -Depth 5
    try {
        $result = Invoke-RestMethod -Uri "$baseUrl/stores/$storeId/menu" -Method Post -Headers $headers -ContentType "application/json" -Body $menuBody
        Write-Host "  [OK] $($item.itemName)" -ForegroundColor Green
        $successCount++
    } catch {
        Write-Host "  [FAIL] $($item.itemName)" -ForegroundColor Red
    }
}

Write-Host "`n[Summary] Added $successCount / $($menuItems.Count) menu items" -ForegroundColor Yellow

# Step 3: 驗證結果
Write-Host "`n[Step 3] Verifying..." -ForegroundColor Cyan
$menu = Invoke-RestMethod -Uri "$baseUrl/stores/$storeId/menu/all" -Method Get -Headers $headers
Write-Host "[OK] Total menu items: $($menu.data.Count)" -ForegroundColor Green
$menu.data | ForEach-Object {
    $prices = $_.priceRules | ConvertFrom-Json
    $priceStr = ($prices.PSObject.Properties | ForEach-Object { "$($_.Name):$($_.Value)" }) -join ", "
    Write-Host "  - $($_.itemName) ($priceStr)" -ForegroundColor Gray
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "  迷克夏店家建立完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
