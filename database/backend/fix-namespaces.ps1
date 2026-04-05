# 批量修改檔案範圍命名空間為傳統命名空間
$files = @(
    "DTOs\AuthDtos.cs",
    "DTOs\ApiResponse.cs",
    "DTOs\EventDtos.cs",
    "DTOs\OrderDtos.cs",
    "Services\AuthService.cs",
    "Services\EventService.cs",
    "Services\OrderService.cs",
    "Services\StoreService.cs",
    "Services\SummaryService.cs",
    "Controllers\AuthController.cs",
    "Controllers\EventsController.cs",
    "Controllers\OrdersController.cs",
    "Controllers\StoresController.cs"
)

foreach ($file in $files) {
    $fullPath = "d:\github\ORDERS\A_order\database\backend\$file"
    if (Test-Path $fullPath) {
        Write-Host "處理: $file" -ForegroundColor Cyan
        
        $content = Get-Content $fullPath -Raw
        
        # 替換 file-scoped namespace 為傳統 namespace
        $content = $content -replace 'namespace (OfficeOrderApi\.\w+);', 'namespace $1{{'
        
        # 在檔案末尾加上額外的 } 
        if ($content -notmatch '\}\s*\}\s*$') {
            $content = $content.TrimEnd() + "`n}"
        }
        
        # 寫回檔案
        Set-Content $fullPath -Value $content -NoNewline
        
        Write-Host "✓ 完成: $file" -ForegroundColor Green
    }
}

Write-Host "`n所有檔案處理完成！" -ForegroundColor Yellow
