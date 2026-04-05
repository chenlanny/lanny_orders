# 修改目標類型 new 表達式為完整類型聲明
$files = Get-ChildItem -Path "d:\github\ORDERS\A_order\database\backend" -Include "*.cs" -Recurse

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    
    # 修改各種 List<T> 的目標類型 new
    $content = $content -replace 'List<int> \w+ \{ get; set; \} = new\(\);', { 
        $match = $_.Value
        $match -replace ' = new\(\);', ' = new List<int>();'
    }
    
    $content = $content -replace 'List<string> \w+ \{ get; set; \} = new\(\);', { 
        $match = $_.Value
        $match -replace ' = new\(\);', ' = new List<string>();'
    }
    
    $content = $content -replace 'List<(\w+)> (\w+) \{ get; set; \} = new\(\);', { 
        $match = $_.Value
        if ($match -match 'List<(\w+)> (\w+)') {
            $type = $matches[1]
            $match -replace ' = new\(\);', " = new List<$type>();"
        } else {
            $match
        }
    }
    
    $content = $content -replace 'List<(\w+Dto)> (\w+) \{ get; set; \} = new\(\);', { 
        $match = $_.Value
        if ($match -match 'List<(\w+Dto)> (\w+)') {
            $type = $matches[1]
            $match -replace ' = new\(\);', " = new List<$type>();"
        } else {
            $match
        }
    }
    
    if ($content -ne $originalContent) {
        Set-Content $file.FullName -Value $content -NoNewline
        Write-Host "修改: $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "`n所有檔案處理完成！" -ForegroundColor Yellow
