# ================================================
# Supabase Database Verification Script
# ================================================

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Supabase Database Verification" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "To verify if data exists in Supabase, follow these steps:" -ForegroundColor Yellow
Write-Host ""

Write-Host "STEP 1: Open Supabase SQL Editor" -ForegroundColor Green
Write-Host "  URL: https://app.supabase.com/project/idyfbtswixhfahddnlkw/sql" -ForegroundColor Cyan
Write-Host ""

Write-Host "STEP 2: Run these SQL commands (paste one at a time):" -ForegroundColor Green
Write-Host ""

Write-Host "Command 1 - Check total users:" -ForegroundColor White
Write-Host '  SELECT COUNT(*) as total_count FROM "Users";' -ForegroundColor Cyan
Write-Host "  Expected: 6 rows" -ForegroundColor Gray
Write-Host ""

Write-Host "Command 2 - Check admin account:" -ForegroundColor White
Write-Host '  SELECT "UserId", "Email", "Name", "Role" FROM "Users" WHERE "Email" = ''admin@company.com'';' -ForegroundColor Cyan
Write-Host "  Expected: 1 row with admin@company.com" -ForegroundColor Gray
Write-Host ""

Write-Host "Command 3 - List all users (for reference):" -ForegroundColor White
Write-Host '  SELECT "UserId", "Email", "Name", "Role" FROM "Users";' -ForegroundColor Cyan
Write-Host "  Expected: 6 rows total" -ForegroundColor Gray
Write-Host ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Results Interpretation" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "✅ SUCCESS - Data already imported:" -ForegroundColor Green
Write-Host "   - Total users count = 6" -ForegroundColor Gray
Write-Host "   - admin@company.com exists" -ForegroundColor Gray
Write-Host "   → You can skip data import step" -ForegroundColor Gray
Write-Host ""

Write-Host "❌ NEEDS IMPORT - Data not found:" -ForegroundColor Red
Write-Host "   - Total users count = 0" -ForegroundColor Gray
Write-Host "   - admin@company.com NOT found" -ForegroundColor Gray
Write-Host "   → Run the import script (see below)" -ForegroundColor Gray
Write-Host ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  How to Import Data" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "If data is missing, follow these steps:" -ForegroundColor Yellow
Write-Host ""

Write-Host "STEP 1: Get the SQL file" -ForegroundColor Green
Write-Host "  Location: database\export_complete_with_users.sql" -ForegroundColor Cyan
Write-Host ""

Write-Host "STEP 2: Open the file and copy all content" -ForegroundColor Green
Write-Host "  (File size: ~20-30 KB, contains ~400 SQL lines)" -ForegroundColor Gray
Write-Host ""

Write-Host "STEP 3: Paste into Supabase SQL Editor" -ForegroundColor Green
Write-Host "  URL: https://app.supabase.com/project/idyfbtswixhfahddnlkw/sql" -ForegroundColor Cyan
Write-Host ""

Write-Host "STEP 4: Click RUN button" -ForegroundColor Green
Write-Host "  Wait for completion (usually 10-30 seconds)" -ForegroundColor Gray
Write-Host ""

Write-Host "STEP 5: Verify with the commands in STEP 2" -ForegroundColor Green
Write-Host "  Re-run the SQL commands to confirm data was imported" -ForegroundColor Gray
Write-Host ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Troubleshooting" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Problem: Import fails with SQL error" -ForegroundColor Yellow
Write-Host "  Solution 1: Check for duplicate data" -ForegroundColor White
Write-Host '    Run: SELECT COUNT(*) FROM "Users";' -ForegroundColor Cyan
Write-Host "    If count > 0, data already imported" -ForegroundColor Gray
Write-Host ""
Write-Host "  Solution 2: Clear old data first" -ForegroundColor White
Write-Host '    Run: DELETE FROM "Users";' -ForegroundColor Cyan
Write-Host '    Then run: DELETE FROM "Stores";' -ForegroundColor Cyan
Write-Host '    Then run: DELETE FROM "MenuItems";' -ForegroundColor Cyan
Write-Host "    Then import data" -ForegroundColor Gray
Write-Host ""

Write-Host "Problem: Import succeeds but no data appears" -ForegroundColor Yellow
Write-Host "  Solution: Refresh the page" -ForegroundColor White
Write-Host "    Press Ctrl+R or click browser refresh button" -ForegroundColor Gray
Write-Host ""

Write-Host "Problem: Login still fails after import" -ForegroundColor Yellow
Write-Host "  Solution: Check Render.com logs" -ForegroundColor White
Write-Host "    URL: https://dashboard.render.com" -ForegroundColor Cyan
Write-Host "    Check service: order-system-api-2tve" -ForegroundColor Gray
Write-Host "    Look for connection errors" -ForegroundColor Gray
Write-Host ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to close..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
