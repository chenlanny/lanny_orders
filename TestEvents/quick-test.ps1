# Quick System Test
# ===================

$baseUrl = "http://localhost:5000/api"

# Login
Write-Host "Step 1: Login" -ForegroundColor Cyan
$loginBody = '{"email":"admin@company.com","password":"admin999"}'
$login = Invoke-RestMethod -Uri "$baseUrl/auth/login" -Method Post -ContentType "application/json" -Body $loginBody
$token = $login.data.token
$headers = @{"Authorization"="Bearer $token"}
Write-Host "  [OK] Logged in" -ForegroundColor Green

# Test 1: Create event with past date (should fail)
Write-Host "`nTest 1-A: Past date validation" -ForegroundColor Cyan
$pastDate = (Get-Date).AddDays(-1).ToString("yyyy-MM-ddTHH:mm:ss")
$body = @{
    title = "Past Date Test"
    orderGroups = @(
        @{
            storeId = 1
            deadline = $pastDate
            deliveryFee = 0
        }
    )
} | ConvertTo-Json

try {
    Invoke-RestMethod -Uri "$baseUrl/events" -Method Post -Headers $headers -ContentType "application/json" -Body $body | Out-Null
    Write-Host "  [FAIL] Allowed past date" -ForegroundColor Red
} catch {
    Write-Host "  [PASS] Rejected past date" -ForegroundColor Green
}

# Test 1-B: Duplicate stores (should fail)
Write-Host "`nTest 1-B: Duplicate store validation" -ForegroundColor Cyan
$futureDate = (Get-Date).AddHours(3).ToString("yyyy-MM-ddTHH:mm:ss")
$body = @{
    title = "Duplicate Store Test"
    orderGroups = @(
        @{ storeId = 1; deadline = $futureDate; deliveryFee = 30 },
        @{ storeId = 1; deadline = $futureDate; deliveryFee = 40 }
    )
} | ConvertTo-Json

try {
    Invoke-RestMethod -Uri "$baseUrl/events" -Method Post -Headers $headers -ContentType "application/json" -Body $body | Out-Null
    Write-Host "  [FAIL] Allowed duplicate stores" -ForegroundColor Red
} catch {
    Write-Host "  [PASS] Rejected duplicate stores" -ForegroundColor Green
}

# Test 1-C: Create valid multi-store event
Write-Host "`nTest 1-C: Create valid multi-store event" -ForegroundColor Cyan
$futureDate = (Get-Date).AddHours(5).ToString("yyyy-MM-ddTHH:mm:ss")
$body = @{
    title = "Multi-Store Test Event"
    notes = "Test event for system testing"
    orderGroups = @(
        @{ storeId = 1; deadline = $futureDate; deliveryFee = 30 },
        @{ storeId = 2; deadline = $futureDate; deliveryFee = 35 }
    )
} | ConvertTo-Json

try {
    $event = Invoke-RestMethod -Uri "$baseUrl/events" -Method Post -Headers $headers -ContentType "application/json" -Body $body
    $eventId = $event.data.eventId
    $group1 = $event.data.orderGroups[0].groupId
    $group2 = $event.data.orderGroups[1].groupId
    Write-Host "  [PASS] Event created: ID=$eventId, Groups=($group1, $group2)" -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] Failed to create event: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 2-A: Place order in store 1
Write-Host "`nTest 2-A: Place order in store 1" -ForegroundColor Cyan
$orderBody = @{
    groupId = $group1
    items = @(
        @{
            itemId = 1
            sizeCode = "M"
            quantity = 2
            customOptions = "Less Sugar"
            toppings = @("Pearl")
            note = "Test order 1"
        }
    )
} | ConvertTo-Json -Depth 5

try {
    Invoke-RestMethod -Uri "$baseUrl/events/$eventId/orders" -Method Post -Headers $headers -ContentType "application/json" -Body $orderBody | Out-Null
    Write-Host "  [PASS] Order placed in store 1" -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2-B: Place order in store 2
Write-Host "`nTest 2-B: Place order in store 2" -ForegroundColor Cyan
$orderBody = @{
    groupId = $group2
    items = @(
        @{
            itemId = 7
            sizeCode = "L"
            quantity = 1
            customOptions = "Normal"
            toppings = @()
            note = "Test order 2"
        }
    )
} | ConvertTo-Json -Depth 5

try {
    Invoke-RestMethod -Uri "$baseUrl/events/$eventId/orders" -Method Post -Headers $headers -ContentType "application/json" -Body $orderBody | Out-Null
    Write-Host "  [PASS] Order placed in store 2 (multi-store works!)" -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Get summary
Write-Host "`nTest 3: Get order summary" -ForegroundColor Cyan
try {
    $summary = Invoke-RestMethod -Uri "$baseUrl/events/$eventId/summary" -Method Get -Headers $headers
    $participants = $summary.data.participantCount
    $total = $summary.data.totalAmount
    Write-Host "  [PASS] Summary: $participants participants, Total: `$$total" -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Get all events
Write-Host "`nTest 4: Get all events" -ForegroundColor Cyan
try {
    $allEvents = Invoke-RestMethod -Uri "$baseUrl/events" -Method Get -Headers $headers
    $count = $allEvents.data.Count
    Write-Host "  [PASS] Found $count events" -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 5-A: Get stores
Write-Host "`nTest 5-A: Get all stores" -ForegroundColor Cyan
try {
    $stores = Invoke-RestMethod -Uri "$baseUrl/stores" -Method Get -Headers $headers
    $count = $stores.data.Count
    Write-Host "  [PASS] Found $count stores" -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 5-B: Get menu
Write-Host "`nTest 5-B: Get store menu" -ForegroundColor Cyan
try {
    $menu = Invoke-RestMethod -Uri "$baseUrl/stores/1/menu" -Method Get -Headers $headers
    $count = $menu.data.Count
    Write-Host "  [PASS] Found $count menu items" -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] Failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n================================" -ForegroundColor Cyan
Write-Host "Test Suite Complete!" -ForegroundColor Green
Write-Host "================================`n" -ForegroundColor Cyan
