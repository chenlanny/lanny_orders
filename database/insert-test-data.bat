@echo off
chcp 65001 >nul
echo Inserting test data...

rem Users
sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -d L_DBII -Q "INSERT INTO Users (Name, Email, PasswordHash, Department, Role) VALUES (N'王小明', 'wang@company.com', 'hash123', N'業務部', 'User');"
sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -d L_DBII -Q "INSERT INTO Users (Name, Email, PasswordHash, Department, Role) VALUES (N'李小華', 'lee@company.com', 'hash123', N'研發部', 'User');"
sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -d L_DBII -Q "INSERT INTO Users (Name, Email, PasswordHash, Department, Role) VALUES (N'陳經理', 'chen@company.com', 'hash123', N'管理部', 'User');"

echo Users inserted.

rem Stores
sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -d L_DBII -Q "INSERT INTO Stores (Name, Category, Phone, Address) VALUES (N'50嵐', 'Drink', '02-1234-5678', N'台北市信義區');"
sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -d L_DBII -Q "INSERT INTO Stores (Name, Category, Phone, Address) VALUES (N'清心福全', 'Drink', '02-2345-6789', N'台北市大安區');"
sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -d L_DBII -Q "INSERT INTO Stores (Name, Category, Phone, Address) VALUES (N'池上便當', 'Lunch', '02-3456-7890', N'台北市中山區');"
sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -d L_DBII -Q "INSERT INTO Stores (Name, Category, Phone, Address) VALUES (N'悟饕便當', 'Lunch', '02-4567-8901', N'台北市松山區');"

echo Stores inserted.

rem MenuItems (simplified)
sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -d L_DBII -Q "INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options) VALUES (1, N'珍珠奶茶', N'奶茶類', '{\"type\":\"size\",\"required\":true,\"options\":[{\"name\":\"中杯\",\"code\":\"M\",\"price\":50},{\"name\":\"大杯\",\"code\":\"L\",\"price\":55}]}', NULL);"
sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -d L_DBII -Q "INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options) VALUES (1, N'四季春茶', N'茶類', '{\"type\":\"size\",\"required\":true,\"options\":[{\"name\":\"中杯\",\"code\":\"M\",\"price\":25},{\"name\":\"大杯\",\"code\":\"L\",\"price\":30}]}', NULL);"
sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -d L_DBII -Q "INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options) VALUES (3, N'排骨便當', N'主餐', '{\"type\":\"portion\",\"required\":true,\"options\":[{\"name\":\"小份\",\"code\":\"S\",\"price\":80},{\"name\":\"大份\",\"code\":\"L\",\"price\":90}]}', NULL);"
sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -d L_DBII -Q "INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options) VALUES (3, N'雞腿便當', N'主餐', '{\"type\":\"portion\",\"required\":true,\"options\":[{\"name\":\"小份\",\"code\":\"S\",\"price\":85},{\"name\":\"大份\",\"code\":\"L\",\"price\":95}]}', NULL);"

echo MenuItems inserted.
echo Done!

sqlcmd -S 192.168.207.52 -U reyi -P ReyifmE -d L_DBII -Q "SELECT 'Users' AS [Table], COUNT(*) AS [Count] FROM Users UNION ALL SELECT 'Stores', COUNT(*) FROM Stores UNION ALL SELECT 'MenuItems', COUNT(*) FROM MenuItems;"

pause
