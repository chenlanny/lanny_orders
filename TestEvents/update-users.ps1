# Update User Data Script
# Generate BCrypt hashes for passwords using .NET BCrypt library

# Add BCrypt.Net-Next package path (from backend project)
$projectPath = "D:\github\ORDERS\A_order\database\backend"
Add-Type -Path "$projectPath\bin\Debug\netcoreapp3.1\BCrypt.Net-Next.dll"

# Generate password hashes
$hash111 = [BCrypt.Net.BCrypt]::HashPassword("111")
$hash222 = [BCrypt.Net.BCrypt]::HashPassword("222")
$hash333 = [BCrypt.Net.BCrypt]::HashPassword("333")
$hash444 = [BCrypt.Net.BCrypt]::HashPassword("444")
$hash555 = [BCrypt.Net.BCrypt]::HashPassword("555")

Write-Host "Password hashes generated:" -ForegroundColor Green
Write-Host "111: $hash111"
Write-Host "222: $hash222"
Write-Host "333: $hash333"
Write-Host "444: $hash444"
Write-Host "555: $hash555"

# Database connection
$server = "192.168.207.52"
$database = "L_DBII"
$username = "reyi"
$password = "ReyifmE"

# Update existing users
Write-Host "`nUpdating existing users..." -ForegroundColor Cyan

# Update User 1: 王小明
sqlcmd -S $server -U $username -P $password -d $database -Q "UPDATE Users SET Email='1@company.com', PasswordHash='$hash111' WHERE UserId=1"
Write-Host "  Updated User 1: 王小明 -> 1@company.com"

# Update User 2: 李小華
sqlcmd -S $server -U $username -P $password -d $database -Q "UPDATE Users SET Email='2@company.com', PasswordHash='$hash222' WHERE UserId=2"
Write-Host "  Updated User 2: 李小華 -> 2@company.com"

# Update User 3: 陳經理 -> 華經理
sqlcmd -S $server -U $username -P $password -d $database -Q "UPDATE Users SET Name=N'華經理', Email='3@company.com', PasswordHash='$hash333' WHERE UserId=3"
Write-Host "  Updated User 3: 華經理 -> 3@company.com"

# Insert new users
Write-Host "`nInserting new users..." -ForegroundColor Cyan

# Check if UserId 4 exists
$existingUser4 = sqlcmd -S $server -U $username -P $password -d $database -Q "SELECT COUNT(*) FROM Users WHERE UserId=4" -h -1
if ($existingUser4.Trim() -eq "0") {
    sqlcmd -S $server -U $username -P $password -d $database -Q "SET IDENTITY_INSERT Users ON; INSERT INTO Users (UserId, Name, Email, PasswordHash, CreatedAt) VALUES (4, N'EC', '4@company.com', '$hash444', GETUTCDATE()); SET IDENTITY_INSERT Users OFF;"
    Write-Host "  Inserted User 4: EC -> 4@company.com"
} else {
    sqlcmd -S $server -U $username -P $password -d $database -Q "UPDATE Users SET Name=N'EC', Email='4@company.com', PasswordHash='$hash444' WHERE UserId=4"
    Write-Host "  Updated User 4: EC -> 4@company.com (already existed)"
}

# Check if UserId 6 is available (5 is used by admin)
$existingUser6 = sqlcmd -S $server -U $username -P $password -d $database -Q "SELECT COUNT(*) FROM Users WHERE UserId=6" -h -1
if ($existingUser6.Trim() -eq "0") {
    sqlcmd -S $server -U $username -P $password -d $database -Q "SET IDENTITY_INSERT Users ON; INSERT INTO Users (UserId, Name, Email, PasswordHash, CreatedAt) VALUES (6, N'林小姐', '5@company.com', '$hash555', GETUTCDATE()); SET IDENTITY_INSERT Users OFF;"
    Write-Host "  Inserted User 6: 林小姐 -> 5@company.com (UserId=6 because 5 is admin)"
} else {
    sqlcmd -S $server -U $username -P $password -d $database -Q "UPDATE Users SET Name=N'林小姐', Email='5@company.com', PasswordHash='$hash555' WHERE UserId=6"
    Write-Host "  Updated User 6: 林小姐 -> 5@company.com"
}

# Display updated users
Write-Host "`nVerifying updated users..." -ForegroundColor Cyan
sqlcmd -S $server -U $username -P $password -d $database -Q "SELECT UserId, Name, Email FROM Users WHERE UserId IN (1,2,3,4,5,6) ORDER BY UserId" -W -s ","

Write-Host "`nUser data update complete!" -ForegroundColor Green
