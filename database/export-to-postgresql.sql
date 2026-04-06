-- ================================
-- 从 SQL Server 导出数据到 PostgreSQL
-- 执行此脚本以生成 INSERT 语句
-- ================================

-- 设置输出格式
SET NOCOUNT ON;

-- 导出 Users 表
PRINT '-- Users 数据';
SELECT 
    'INSERT INTO "Users" ("UserId", "Email", "Name", "PasswordHash", "Role", "CreatedAt") VALUES (' +
    CAST(UserId AS VARCHAR) + ', ' +
    '''' + REPLACE(Email, '''', '''''') + ''', ' +
    '''' + REPLACE(Name, '''', '''''') + ''', ' +
    '''' + REPLACE(PasswordHash, '''', '''''') + ''', ' +
    '''' + Role + ''', ' +
    '''' + CONVERT(VARCHAR, CreatedAt, 126) + ''');'
FROM Users
ORDER BY UserId;

PRINT '';
PRINT '-- Stores 数据';
-- 导出 Stores 表
SELECT 
    'INSERT INTO "Stores" ("StoreId", "Name", "Phone", "Address", "DeliveryFee", "MinOrderAmount", "IsActive", "CreatedAt") VALUES (' +
    CAST(StoreId AS VARCHAR) + ', ' +
    '''' + REPLACE(Name, '''', '''''') + ''', ' +
    ISNULL('''' + REPLACE(Phone, '''', '''''') + '''', 'NULL') + ', ' +
    ISNULL('''' + REPLACE(Address, '''', '''''') + '''', 'NULL') + ', ' +
    CAST(DeliveryFee AS VARCHAR) + ', ' +
    CAST(MinOrderAmount AS VARCHAR) + ', ' +
    CASE WHEN IsActive = 1 THEN 'true' ELSE 'false' END + ', ' +
    '''' + CONVERT(VARCHAR, CreatedAt, 126) + ''');'
FROM Stores
ORDER BY StoreId;

PRINT '';
PRINT '-- MenuItems 数据';
-- 导出 MenuItems 表
SELECT 
    'INSERT INTO "MenuItems" ("MenuItemId", "StoreId", "Name", "Price", "Category", "Description", "IsAvailable", "ImageUrl", "CreatedAt") VALUES (' +
    CAST(MenuItemId AS VARCHAR) + ', ' +
    CAST(StoreId AS VARCHAR) + ', ' +
    '''' + REPLACE(Name, '''', '''''') + ''', ' +
    CAST(Price AS VARCHAR) + ', ' +
    ISNULL('''' + REPLACE(Category, '''', '''''') + '''', 'NULL') + ', ' +
    ISNULL('''' + REPLACE(Description, '''', '''''') + '''', 'NULL') + ', ' +
    CASE WHEN IsAvailable = 1 THEN 'true' ELSE 'false' END + ', ' +
    ISNULL('''' + REPLACE(ImageUrl, '''', '''''') + '''', 'NULL') + ', ' +
    '''' + CONVERT(VARCHAR, CreatedAt, 126) + ''');'
FROM MenuItems
ORDER BY MenuItemId;

PRINT '';
PRINT '-- Events 数据';
-- 导出 Events 表
SELECT 
    'INSERT INTO "Events" ("EventId", "StoreId", "CreatorId", "Title", "Description", "DeadlineTime", "DeliveryTime", "Status", "TotalAmount", "CreatedAt", "UpdatedAt") VALUES (' +
    CAST(EventId AS VARCHAR) + ', ' +
    CAST(StoreId AS VARCHAR) + ', ' +
    CAST(CreatorId AS VARCHAR) + ', ' +
    '''' + REPLACE(Title, '''', '''''') + ''', ' +
    ISNULL('''' + REPLACE(Description, '''', '''''') + '''', 'NULL') + ', ' +
    '''' + CONVERT(VARCHAR, DeadlineTime, 126) + ''', ' +
    ISNULL('''' + CONVERT(VARCHAR, DeliveryTime, 126) + '''', 'NULL') + ', ' +
    '''' + Status + ''', ' +
    CAST(ISNULL(TotalAmount, 0) AS VARCHAR) + ', ' +
    '''' + CONVERT(VARCHAR, CreatedAt, 126) + ''', ' +
    ISNULL('''' + CONVERT(VARCHAR, UpdatedAt, 126) + '''', 'NULL') + ');'
FROM Events
ORDER BY EventId;

PRINT '';
PRINT '-- OrderGroups 数据';
-- 导出 OrderGroups 表  
SELECT 
    'INSERT INTO "OrderGroups" ("OrderGroupId", "EventId", "UserId", "Subtotal", "DeliveryFee", "Total", "Notes", "CreatedAt", "UpdatedAt") VALUES (' +
    CAST(OrderGroupId AS VARCHAR) + ', ' +
    CAST(EventId AS VARCHAR) + ', ' +
    CAST(UserId AS VARCHAR) + ', ' +
    CAST(Subtotal AS VARCHAR) + ', ' +
    CAST(DeliveryFee AS VARCHAR) + ', ' +
    CAST(Total AS VARCHAR) + ', ' +
    ISNULL('''' + REPLACE(Notes, '''', '''''') + '''', 'NULL') + ', ' +
    '''' + CONVERT(VARCHAR, CreatedAt, 126) + ''', ' +
    ISNULL('''' + CONVERT(VARCHAR, UpdatedAt, 126) + '''', 'NULL') + ');'
FROM OrderGroups
ORDER BY OrderGroupId;

PRINT '';
PRINT '-- OrderItems 数据';
-- 导出 OrderItems 表
SELECT 
    'INSERT INTO "OrderItems" ("OrderItemId", "OrderGroupId", "MenuItemId", "Quantity", "Price", "Subtotal", "Customization") VALUES (' +
    CAST(OrderItemId AS VARCHAR) + ', ' +
    CAST(OrderGroupId AS VARCHAR) + ', ' +
    CAST(MenuItemId AS VARCHAR) + ', ' +
    CAST(Quantity AS VARCHAR) + ', ' +
    CAST(Price AS VARCHAR) + ', ' +
    CAST(Subtotal AS VARCHAR) + ', ' +
    ISNULL('''' + REPLACE(Customization, '''', '''''') + '''', 'NULL') + ');'
FROM OrderItems
ORDER BY OrderItemId;
