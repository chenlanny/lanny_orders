# ========================================
# Netlify 快速部署檢查腳本
# ========================================

Write-Host ""
Write-Host "=== Netlify 部署前檢查 ===" -ForegroundColor Cyan
Write-Host ""

# 檢查 1: Node.js
Write-Host "[1/5] 檢查 Node.js..." -NoNewline
try {
    $nodeVersion = node --version
    Write-Host " ✅ $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host " ❌ 未安裝" -ForegroundColor Red
    exit 1
}

# 檢查 2: npm
Write-Host "[2/5] 檢查 npm..." -NoNewline
try {
    $npmVersion = npm --version
    Write-Host " ✅ v$npmVersion" -ForegroundColor Green
} catch {
    Write-Host " ❌ 未安裝" -ForegroundColor Red
    exit 1
}

# 檢查 3: 依賴安裝
Write-Host "[3/5] 檢查依賴..." -NoNewline
if (Test-Path "node_modules") {
    Write-Host " ✅ 已安裝" -ForegroundColor Green
} else {
    Write-Host " ⚠️  未安裝，正在安裝..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -eq 0) {
        Write-Host "      ✅ 安裝完成" -ForegroundColor Green
    } else {
        Write-Host "      ❌ 安裝失敗" -ForegroundColor Red
        exit 1
    }
}

# 檢查 4: netlify.toml
Write-Host "[4/5] 檢查配置檔..." -NoNewline
if (Test-Path "../netlify.toml") {
    Write-Host " ✅ netlify.toml 存在" -ForegroundColor Green
} else {
    Write-Host " ❌ netlify.toml 不存在" -ForegroundColor Red
    exit 1
}

# 檢查 5: 測試建置
Write-Host "[5/5] 測試建置..." -NoNewline
$buildOutput = npm run build 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host " ✅ 建置成功" -ForegroundColor Green
} else {
    Write-Host " ❌ 建置失敗" -ForegroundColor Red
    Write-Host ""
    Write-Host "錯誤訊息:" -ForegroundColor Red
    Write-Host $buildOutput
    exit 1
}

Write-Host ""
Write-Host "=== ✅ 所有檢查通過！===" -ForegroundColor Green
Write-Host ""
Write-Host "📦 準備就緒，可以部署到 Netlify" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 部署步驟:" -ForegroundColor Yellow
Write-Host "   1. 前往 https://app.netlify.com" -ForegroundColor White
Write-Host "   2. 點擊 'Add new site' → 'Import an existing project'" -ForegroundColor White
Write-Host "   3. 選擇 GitHub 並授權" -ForegroundColor White
Write-Host "   4. 選擇 'A_order' 倉庫" -ForegroundColor White
Write-Host "   5. 設定環境變數:" -ForegroundColor White
Write-Host "      Key:   VITE_API_URL" -ForegroundColor Cyan
Write-Host "      Value: https://order-system-api-2tve.onrender.com/api" -ForegroundColor Cyan
Write-Host "   6. 點擊 'Deploy site'" -ForegroundColor White
Write-Host ""
Write-Host "📖 詳細說明: frontend/NETLIFY_DEPLOY.md" -ForegroundColor Magenta
Write-Host ""
