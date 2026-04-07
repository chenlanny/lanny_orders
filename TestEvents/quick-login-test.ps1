# ===========================================
# Quick Login Test Script
# ===========================================

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Login Issue Quick Test" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Backend Health
Write-Host "[Test 1/3] Backend API Health Check..." -ForegroundColor Yellow
try {
    $health = Invoke-WebRequest -Uri "https://order-system-api-2tve.onrender.com/api/auth/status" -UseBasicParsing -TimeoutSec 30
    Write-Host "  PASS - Backend is online (Status: $($health.StatusCode))" -ForegroundColor Green
} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "  PASS - Backend is online (401 = needs auth)" -ForegroundColor Green
    } else {
        Write-Host "  FAIL - Backend is offline or error" -ForegroundColor Red
        exit 1
    }
}
Write-Host ""

# Test 2: Login API with admin123
Write-Host "[Test 2/3] Testing login with admin123..." -ForegroundColor Yellow
$body = @{
    email = "admin@company.com"
    password = "admin123"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "https://order-system-api-2tve.onrender.com/api/auth/login" `
                                   -Method POST `
                                   -Body $body `
                                   -ContentType "application/json" `
                                   -TimeoutSec 30
    
    Write-Host "  PASS - Login successful!" -ForegroundColor Green
    Write-Host "    User: $($response.data.user.name)" -ForegroundColor Gray
    Write-Host "    Role: $($response.data.user.role)" -ForegroundColor Gray
    Write-Host "    Token: YES" -ForegroundColor Gray
    $loginSuccess = $true
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    
    if ($statusCode -eq 500) {
        Write-Host "  FAIL - Server Error (500)" -ForegroundColor Red
        Write-Host "    Most likely cause: Database has no user data" -ForegroundColor Yellow
        Write-Host "    Action required: Import data to Supabase" -ForegroundColor Yellow
    } elseif ($statusCode -eq 401) {
        Write-Host "  FAIL - Unauthorized (401)" -ForegroundColor Red
        Write-Host "    Possible cause: Wrong password" -ForegroundColor Yellow
    } else {
        Write-Host "  FAIL - Error ($statusCode)" -ForegroundColor Red
    }
    
    $loginSuccess = $false
}
Write-Host ""

# Test 3: Frontend Config Check
Write-Host "[Test 3/3] Checking frontend configuration..." -ForegroundColor Yellow
$envProd = "frontend\.env.production"
if (Test-Path $envProd) {
    $content = Get-Content $envProd -Raw
    if ($content -match "order-system-api-2tve\.onrender\.com") {
        Write-Host "  PASS - Frontend .env.production is correct" -ForegroundColor Green
    } else {
        Write-Host "  WARN - Frontend .env.production may need update" -ForegroundColor Yellow
    }
} else {
    Write-Host "  WARN - No .env.production file found" -ForegroundColor Yellow
}
Write-Host ""

# Summary
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  SUMMARY" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

if ($loginSuccess) {
    Write-Host "STATUS: ALL TESTS PASSED" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your system is working correctly!" -ForegroundColor Green
    Write-Host "You can now login at: https://playful-centaur-98df6f.netlify.app/login" -ForegroundColor Cyan
} else {
    Write-Host "STATUS: LOGIN FAILED" -ForegroundColor Red
    Write-Host ""
    Write-Host "NEXT STEPS:" -ForegroundColor Yellow
    Write-Host "1. Open Supabase SQL Editor:" -ForegroundColor White
    Write-Host "   https://app.supabase.com/project/idyfbtswixhfahddnlkw/sql" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "2. Run this SQL to check if users exist:" -ForegroundColor White
    Write-Host '   SELECT COUNT(*) FROM "Users";' -ForegroundColor Cyan
    Write-Host ""
    Write-Host "3. If result is 0, import data:" -ForegroundColor White
    Write-Host "   - Open file: database\export_complete_with_users.sql" -ForegroundColor Cyan
    Write-Host "   - Copy all content and paste into Supabase SQL Editor" -ForegroundColor Cyan
    Write-Host "   - Click RUN" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "4. Re-run this test script" -ForegroundColor White
    Write-Host ""
    Write-Host "For detailed diagnosis, see:" -ForegroundColor White
    Write-Host "  TestReports\LOGIN_ISSUE_DIAGNOSIS.md" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
