-- ============================================
-- 智慧辦公室訂餐系統 - 完整資料庫建立腳本
-- 資料庫：L_DBII
-- 伺服器：192.168.207.52
-- ============================================

USE L_DBII;
GO

-- ============================================
-- 1. 使用者表
-- ============================================
IF OBJECT_ID('Users', 'U') IS NOT NULL
    DROP TABLE Users;
GO

CREATE TABLE Users (
    UserId          INT PRIMARY KEY IDENTITY(1,1),
    Name            NVARCHAR(50) NOT NULL,
    Email           NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(255) NOT NULL,
    Department      NVARCHAR(50),
    Role            NVARCHAR(20) DEFAULT 'User',  -- Admin / User
    IsActive        BIT DEFAULT 1,
    CreatedAt       DATETIME DEFAULT GETDATE(),
    LastLoginAt     DATETIME NULL
);

CREATE INDEX IX_Users_Email ON Users(Email);
CREATE INDEX IX_Users_Department ON Users(Department);
GO

PRINT '✓ Users 表建立成功';
GO

-- ============================================
-- 2. 店家表
-- ============================================
IF OBJECT_ID('Stores', 'U') IS NOT NULL
    DROP TABLE Stores;
GO

CREATE TABLE Stores (
    StoreId         INT PRIMARY KEY IDENTITY(1,1),
    Name            NVARCHAR(100) NOT NULL,
    Category        NVARCHAR(20) NOT NULL,  -- Drink / Lunch / Snack
    Phone           NVARCHAR(20),
    Address         NVARCHAR(200),
    MenuUrl         NVARCHAR(500),
    IsActive        BIT DEFAULT 1,
    CreatedAt       DATETIME DEFAULT GETDATE()
);

CREATE INDEX IX_Stores_Category ON Stores(Category);
GO

PRINT '✓ Stores 表建立成功';
GO

-- ============================================
-- 3. 菜單品項表（支援尺寸定價）
-- ============================================
IF OBJECT_ID('MenuItems', 'U') IS NOT NULL
    DROP TABLE MenuItems;
GO

CREATE TABLE MenuItems (
    ItemId          INT PRIMARY KEY IDENTITY(1,1),
    StoreId         INT NOT NULL,
    Name            NVARCHAR(100) NOT NULL,
    Category        NVARCHAR(50),
    
    -- 定價規則（JSON: 尺寸/份量定價）
    PriceRules      NVARCHAR(MAX) NOT NULL,
    
    -- 客製化選項（JSON: 甜度/溫度/加料）
    Options         NVARCHAR(MAX),
    
    ImageUrl        NVARCHAR(500),
    IsAvailable     BIT DEFAULT 1,
    CreatedAt       DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_MenuItems_Store FOREIGN KEY (StoreId) 
        REFERENCES Stores(StoreId) ON DELETE CASCADE
);

CREATE INDEX IX_MenuItems_StoreId ON MenuItems(StoreId);
CREATE INDEX IX_MenuItems_Name ON MenuItems(Name);
GO

PRINT '✓ MenuItems 表建立成功';
GO

-- ============================================
-- 4. 揪團活動表
-- ============================================
IF OBJECT_ID('Events', 'U') IS NOT NULL
    DROP TABLE Events;
GO

CREATE TABLE Events (
    EventId         INT PRIMARY KEY IDENTITY(1,1),
    Title           NVARCHAR(100) NOT NULL,
    InitiatorId     INT NOT NULL,
    Status          NVARCHAR(20) DEFAULT 'Open',  -- Open / Closed / Delivered / Cancelled
    CreatedAt       DATETIME DEFAULT GETDATE(),
    ClosedAt        DATETIME NULL,
    DeliveredAt     DATETIME NULL,
    Notes           NVARCHAR(500),
    
    CONSTRAINT FK_Events_Initiator FOREIGN KEY (InitiatorId) 
        REFERENCES Users(UserId)
);

CREATE INDEX IX_Events_Status ON Events(Status);
CREATE INDEX IX_Events_CreatedAt ON Events(CreatedAt DESC);
GO

PRINT '✓ Events 表建立成功';
GO

-- ============================================
-- 5. 各店訂單群組表
-- ============================================
IF OBJECT_ID('OrderGroups', 'U') IS NOT NULL
    DROP TABLE OrderGroups;
GO

CREATE TABLE OrderGroups (
    GroupId         INT PRIMARY KEY IDENTITY(1,1),
    EventId         INT NOT NULL,
    StoreId         INT NOT NULL,
    Deadline        DATETIME NOT NULL,
    DeliveryFee     DECIMAL(8,1) DEFAULT 0,
    Status          NVARCHAR(20) DEFAULT 'Open',
    CreatedAt       DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_OrderGroups_Event FOREIGN KEY (EventId) 
        REFERENCES Events(EventId) ON DELETE CASCADE,
    CONSTRAINT FK_OrderGroups_Store FOREIGN KEY (StoreId) 
        REFERENCES Stores(StoreId)
);

CREATE INDEX IX_OrderGroups_EventId ON OrderGroups(EventId);
CREATE INDEX IX_OrderGroups_Deadline ON OrderGroups(Deadline);
GO

PRINT '✓ OrderGroups 表建立成功';
GO

-- ============================================
-- 6. 訂單項目表（支援尺寸、加料）
-- ============================================
IF OBJECT_ID('OrderItems', 'U') IS NOT NULL
    DROP TABLE OrderItems;
GO

CREATE TABLE OrderItems (
    OrderItemId     INT PRIMARY KEY IDENTITY(1,1),
    GroupId         INT NOT NULL,
    UserId          INT NOT NULL,
    ItemId          INT NOT NULL,
    
    -- 尺寸/規格選擇
    SizeCode        NVARCHAR(20) NOT NULL,
    SizeName        NVARCHAR(50) NOT NULL,
    
    Quantity        INT DEFAULT 1,
    
    -- 客製化選項（甜度、溫度）
    CustomOptions   NVARCHAR(200),
    
    -- 加料選項（JSON 陣列）
    Toppings        NVARCHAR(500),
    
    Note            NVARCHAR(200),
    
    -- 價格明細
    BasePrice       DECIMAL(8,1) NOT NULL,
    ToppingPrice    DECIMAL(8,1) DEFAULT 0,
    UnitPrice       DECIMAL(8,1) NOT NULL,
    SubTotal        DECIMAL(8,1) NOT NULL,
    
    CreatedAt       DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_OrderItems_Group FOREIGN KEY (GroupId) 
        REFERENCES OrderGroups(GroupId) ON DELETE CASCADE,
    CONSTRAINT FK_OrderItems_User FOREIGN KEY (UserId) 
        REFERENCES Users(UserId),
    CONSTRAINT FK_OrderItems_Item FOREIGN KEY (ItemId) 
        REFERENCES MenuItems(ItemId)
);

CREATE INDEX IX_OrderItems_GroupId ON OrderItems(GroupId);
CREATE INDEX IX_OrderItems_UserId ON OrderItems(UserId);
CREATE INDEX IX_OrderItems_CreatedAt ON OrderItems(CreatedAt DESC);
GO

PRINT '✓ OrderItems 表建立成功';
GO

-- ============================================
-- 7. 通知紀錄表（選用）
-- ============================================
IF OBJECT_ID('Notifications', 'U') IS NOT NULL
    DROP TABLE Notifications;
GO

CREATE TABLE Notifications (
    NotificationId  INT PRIMARY KEY IDENTITY(1,1),
    UserId          INT NOT NULL,
    EventId         INT,
    Type            NVARCHAR(50),
    Message         NVARCHAR(500),
    IsRead          BIT DEFAULT 0,
    SentAt          DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_Notifications_User FOREIGN KEY (UserId) 
        REFERENCES Users(UserId) ON DELETE CASCADE
);

CREATE INDEX IX_Notifications_UserId_IsRead ON Notifications(UserId, IsRead);
GO

PRINT '✓ Notifications 表建立成功';
GO

-- ============================================
-- 8. 建立分帳檢視
-- ============================================
IF OBJECT_ID('vw_OrderSummary', 'V') IS NOT NULL
    DROP VIEW vw_OrderSummary;
GO

CREATE VIEW vw_OrderSummary AS
SELECT 
    e.EventId,
    e.Title AS EventTitle,
    og.GroupId,
    s.Name AS StoreName,
    u.UserId,
    u.Name AS UserName,
    u.Department,
    
    -- 品項總額（含加料）
    SUM(oi.SubTotal) AS ItemTotal,
    
    -- 外送費分攤
    CASE 
        WHEN COUNT(DISTINCT oi2.UserId) > 0 
        THEN og.DeliveryFee / COUNT(DISTINCT oi2.UserId)
        ELSE 0 
    END AS DeliveryFeeShare,
    
    -- 應付總額
    SUM(oi.SubTotal) + 
    CASE 
        WHEN COUNT(DISTINCT oi2.UserId) > 0 
        THEN og.DeliveryFee / COUNT(DISTINCT oi2.UserId)
        ELSE 0 
    END AS TotalDue
    
FROM Events e
JOIN OrderGroups og ON e.EventId = og.EventId
JOIN Stores s ON og.StoreId = s.StoreId
JOIN OrderItems oi ON og.GroupId = oi.GroupId
JOIN Users u ON oi.UserId = u.UserId
LEFT JOIN OrderItems oi2 ON og.GroupId = oi2.GroupId
GROUP BY 
    e.EventId, e.Title, og.GroupId, s.Name, 
    u.UserId, u.Name, u.Department, og.DeliveryFee;
GO

PRINT '✓ vw_OrderSummary 檢視建立成功';
GO

PRINT '';
PRINT '========================================';
PRINT '資料庫結構建立完成！';
PRINT '========================================';
PRINT '已建立的物件：';
PRINT '  ✓ 7 個資料表';
PRINT '  ✓ 1 個檢視';
PRINT '  ✓ 12 個索引';
PRINT '  ✓ 8 個外鍵約束';
PRINT '';
PRINT '下一步：執行 seed-data.sql 插入測試資料';
PRINT '========================================';
GO
