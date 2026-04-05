@echo off
chcp 65001 >nul
echo ========================================
echo 智慧辦公室訂餐系統 - 資料庫建立工具
echo ========================================
echo.

set SERVER=192.168.207.52
set USER=reyi
set PASSWORD=ReyifmE
set DATABASE=L_DBII

echo 伺服器: %SERVER%
echo 帳號: %USER%
echo 資料庫: %DATABASE%
echo.

:MENU
echo 請選擇操作：
echo [1] 建立資料庫 (L_DBII)
echo [2] 建立資料表結構
echo [3] 插入測試資料
echo [4] 執行完整建置 (1+2+3)
echo [5] 測試連線
echo [0] 離開
echo.
set /p choice="請輸入選項 (0-5): "

if "%choice%"=="1" goto CREATE_DB
if "%choice%"=="2" goto CREATE_SCHEMA
if "%choice%"=="3" goto SEED_DATA
if "%choice%"=="4" goto FULL_BUILD
if "%choice%"=="5" goto TEST_CONNECTION
if "%choice%"=="0" goto END
goto MENU

:TEST_CONNECTION
echo.
echo [測試連線] 正在連線到 %SERVER%...
sqlcmd -S %SERVER% -U %USER% -P %PASSWORD% -Q "SELECT @@VERSION AS [SQL Server Version]" -h -1
if %ERRORLEVEL% EQU 0 (
    echo ✓ 連線成功！
) else (
    echo ✗ 連線失敗，請檢查伺服器位址、帳號和密碼
)
echo.
pause
goto MENU

:CREATE_DB
echo.
echo [步驟 1/1] 建立資料庫 %DATABASE%...
sqlcmd -S %SERVER% -U %USER% -P %PASSWORD% -i create-database.sql
if %ERRORLEVEL% EQU 0 (
    echo ✓ 資料庫建立成功！
) else (
    echo ✗ 資料庫建立失敗
)
echo.
pause
goto MENU

:CREATE_SCHEMA
echo.
echo [步驟 1/1] 建立資料表結構...
sqlcmd -S %SERVER% -U %USER% -P %PASSWORD% -d %DATABASE% -i create-full-schema.sql
if %ERRORLEVEL% EQU 0 (
    echo ✓ 資料表結構建立成功！
) else (
    echo ✗ 資料表結構建立失敗
)
echo.
pause
goto MENU

:SEED_DATA
echo.
echo [步驟 1/1] 插入測試資料...
sqlcmd -S %SERVER% -U %USER% -P %PASSWORD% -d %DATABASE% -i seed-data.sql
if %ERRORLEVEL% EQU 0 (
    echo ✓ 測試資料插入成功！
) else (
    echo ✗ 測試資料插入失敗
)
echo.
pause
goto MENU

:FULL_BUILD
echo.
echo ========================================
echo 開始完整建置
echo ========================================
echo.

echo [步驟 1/3] 建立資料庫...
sqlcmd -S %SERVER% -U %USER% -P %PASSWORD% -i create-database.sql
if %ERRORLEVEL% NEQ 0 (
    echo ✗ 步驟 1 失敗
    pause
    goto MENU
)
echo ✓ 步驟 1 完成
echo.

echo [步驟 2/3] 建立資料表結構...
sqlcmd -S %SERVER% -U %USER% -P %PASSWORD% -d %DATABASE% -i create-full-schema.sql
if %ERRORLEVEL% NEQ 0 (
    echo ✗ 步驟 2 失敗
    pause
    goto MENU
)
echo ✓ 步驟 2 完成
echo.

echo [步驟 3/3] 插入測試資料...
sqlcmd -S %SERVER% -U %USER% -P %PASSWORD% -d %DATABASE% -i seed-data.sql
if %ERRORLEVEL% NEQ 0 (
    echo ✗ 步驟 3 失敗
    pause
    goto MENU
)
echo ✓ 步驟 3 完成
echo.

echo ========================================
echo 完整建置成功！
echo ========================================
echo.
echo 資料庫已準備就緒，可以開始開發了！
echo.
echo 連線字串：
echo Server=%SERVER%;Database=%DATABASE%;User Id=%USER%;Password=%PASSWORD%;TrustServerCertificate=True;
echo.
pause
goto MENU

:END
echo.
echo 感謝使用，再見！
exit
