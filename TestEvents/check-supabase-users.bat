@echo off
chcp 65001 >nul
@REM ==========================================
@REM Check Supabase Users Data
@REM ==========================================

echo.
echo ========================================
echo  Checking Supabase Users Data
echo ========================================
echo.

@REM Instructions for user
echo Please follow these steps:
echo.
echo 1. Open: https://app.supabase.com/project/idyfbtswixhfahddnlkw/sql
echo.
echo 2. Copy and paste this SQL command:
echo.
echo ====== START COPY ======
echo SELECT COUNT(*) as "Total Users" FROM "Users";
echo SELECT "UserId", "Email", "Name", "Role" FROM "Users" WHERE "Email" = 'admin@company.com';
echo ====== END COPY ======
echo.
echo 3. Click RUN button
echo.
echo 4. Check the results:
echo    - If "Total Users" = 6 AND you see admin@company.com record
echo      =] Data is imported successfully
echo.
echo    - If "Total Users" = 0 OR no admin@company.com record
echo      =] You need to import data from database\export_complete_with_users.sql
echo.
echo ========================================
echo.

pause
