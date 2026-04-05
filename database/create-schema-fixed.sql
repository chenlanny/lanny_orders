USE L_DBII;
GO

-- Drop tables in reverse order (child tables first)
IF OBJECT_ID('Notifications', 'U') IS NOT NULL DROP TABLE Notifications;
IF OBJECT_ID('OrderItems', 'U') IS NOT NULL DROP TABLE OrderItems;
IF OBJECT_ID('OrderGroups', 'U') IS NOT NULL DROP TABLE OrderGroups;
IF OBJECT_ID('Events', 'U') IS NOT NULL DROP TABLE Events;
IF OBJECT_ID('MenuItems', 'U') IS NOT NULL DROP TABLE MenuItems;
IF OBJECT_ID('Stores', 'U') IS NOT NULL DROP TABLE Stores;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
GO

-- Create Users table
CREATE TABLE Users (
    UserId          INT PRIMARY KEY IDENTITY(1,1),
    Name            NVARCHAR(50) NOT NULL,
    Email           NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(255) NOT NULL,
    Department      NVARCHAR(50),
    Role            NVARCHAR(20) DEFAULT 'User',
    IsActive        BIT DEFAULT 1,
    CreatedAt       DATETIME DEFAULT GETDATE(),
    LastLoginAt     DATETIME NULL
);
CREATE INDEX IX_Users_Email ON Users(Email);
CREATE INDEX IX_Users_Department ON Users(Department);
GO

-- Create Stores table
CREATE TABLE Stores (
    StoreId         INT PRIMARY KEY IDENTITY(1,1),
    Name            NVARCHAR(100) NOT NULL,
    Category        NVARCHAR(20) NOT NULL,
    Phone           NVARCHAR(20),
    Address         NVARCHAR(200),
    MenuUrl         NVARCHAR(500),
    IsActive        BIT DEFAULT 1,
    CreatedAt       DATETIME DEFAULT GETDATE()
);
CREATE INDEX IX_Stores_Category ON Stores(Category);
GO

-- Create MenuItems table
CREATE TABLE MenuItems (
    ItemId          INT PRIMARY KEY IDENTITY(1,1),
    StoreId         INT NOT NULL,
    Name            NVARCHAR(100) NOT NULL,
    Category        NVARCHAR(50),
    PriceRules      NVARCHAR(MAX) NOT NULL,
    Options         NVARCHAR(MAX),
    ImageUrl        NVARCHAR(500),
    IsAvailable     BIT DEFAULT 1,
    CreatedAt       DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_MenuItems_Store FOREIGN KEY (StoreId) REFERENCES Stores(StoreId) ON DELETE CASCADE
);
CREATE INDEX IX_MenuItems_StoreId ON MenuItems(StoreId);
CREATE INDEX IX_MenuItems_Name ON MenuItems(Name);
GO

-- Create Events table
CREATE TABLE Events (
    EventId         INT PRIMARY KEY IDENTITY(1,1),
    Title           NVARCHAR(100) NOT NULL,
    InitiatorId     INT NOT NULL,
    Status          NVARCHAR(20) DEFAULT 'Open',
    CreatedAt       DATETIME DEFAULT GETDATE(),
    ClosedAt        DATETIME NULL,
    DeliveredAt     DATETIME NULL,
    Notes           NVARCHAR(500),
    CONSTRAINT FK_Events_Initiator FOREIGN KEY (InitiatorId) REFERENCES Users(UserId)
);
CREATE INDEX IX_Events_Status ON Events(Status);
CREATE INDEX IX_Events_CreatedAt ON Events(CreatedAt DESC);
GO

-- Create OrderGroups table
CREATE TABLE OrderGroups (
    GroupId         INT PRIMARY KEY IDENTITY(1,1),
    EventId         INT NOT NULL,
    StoreId         INT NOT NULL,
    Deadline        DATETIME NOT NULL,
    DeliveryFee     DECIMAL(8,1) DEFAULT 0,
    Status          NVARCHAR(20) DEFAULT 'Open',
    CreatedAt       DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_OrderGroups_Event FOREIGN KEY (EventId) REFERENCES Events(EventId) ON DELETE CASCADE,
    CONSTRAINT FK_OrderGroups_Store FOREIGN KEY (StoreId) REFERENCES Stores(StoreId)
);
CREATE INDEX IX_OrderGroups_EventId ON OrderGroups(EventId);
CREATE INDEX IX_OrderGroups_Deadline ON OrderGroups(Deadline);
GO

-- Create OrderItems table
CREATE TABLE OrderItems (
    OrderItemId     INT PRIMARY KEY IDENTITY(1,1),
    GroupId         INT NOT NULL,
    UserId          INT NOT NULL,
    ItemId          INT NOT NULL,
    SizeCode        NVARCHAR(20) NOT NULL,
    SizeName        NVARCHAR(50) NOT NULL,
    Quantity        INT DEFAULT 1,
    CustomOptions   NVARCHAR(200),
    Toppings        NVARCHAR(500),
    Note            NVARCHAR(200),
    BasePrice       DECIMAL(8,1) NOT NULL,
    ToppingPrice    DECIMAL(8,1) DEFAULT 0,
    UnitPrice       DECIMAL(8,1) NOT NULL,
    SubTotal        DECIMAL(8,1) NOT NULL,
    CreatedAt       DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_OrderItems_Group FOREIGN KEY (GroupId) REFERENCES OrderGroups(GroupId) ON DELETE CASCADE,
    CONSTRAINT FK_OrderItems_User FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FK_OrderItems_Item FOREIGN KEY (ItemId) REFERENCES MenuItems(ItemId)
);
CREATE INDEX IX_OrderItems_GroupId ON OrderItems(GroupId);
CREATE INDEX IX_OrderItems_UserId ON OrderItems(UserId);
CREATE INDEX IX_OrderItems_CreatedAt ON OrderItems(CreatedAt DESC);
GO

-- Create Notifications table
CREATE TABLE Notifications (
    NotificationId  INT PRIMARY KEY IDENTITY(1,1),
    UserId          INT NOT NULL,
    EventId         INT,
    Type            NVARCHAR(50),
    Message         NVARCHAR(500),
    IsRead          BIT DEFAULT 0,
    SentAt          DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Notifications_User FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE
);
CREATE INDEX IX_Notifications_UserId_IsRead ON Notifications(UserId, IsRead);
GO

PRINT 'All tables created successfully!';
GO
