# 測試Store Menu API
$loginUrl = "http://localhost:5000/api/auth/login"
$loginBody = '{"email":"admin@company.com","password":"admin999"}'
$r = Invoke-RestMethod -Uri $loginUrl -Method POST -Body $loginBody -ContentType "application/json"
$token = $r.data.token

Write-Host "=== Testing Store 1 Menu API ===" -ForegroundColor Green
$menuUrl = "http://localhost:5000/api/stores/1/menu"
$headers = @{ Authorization = "Bearer $token" }
$menu = Invoke-RestMethod -Uri $menuUrl -Headers $headers

Write-Host "Response structure:"
Write-Host "success: $($menu.success)"
Write-Host "data type: $($menu.data.GetType().Name)"
Write-Host "data is array: $($menu.data -is [Array])"
if ($menu.data -is [Array]) {
    Write-Host "data length: $($menu.data.Length)"
} else {
    Write-Host "data properties: $($menu.data.PSObject.Properties.Name -join ', ')"
}

Write-Host "`nFull response:"
$menu | ConvertTo-Json -Depth 5
