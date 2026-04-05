-- ================================
-- 飲料訂購系統 PostgreSQL 初始化腳本
-- ================================
-- 此腳本用於在 Render.com 的 PostgreSQL 資料庫中創建所有資料表
-- 執行前請確保已連接到正確的資料庫

-- ================================
-- 1. 創建 Users 資料表
-- ================================
CREATE TABLE IF NOT EXISTS "Users" (
    "UserId" SERIAL PRIMARY KEY,
    "Name" VARCHAR(50) NOT NULL,
    "Email" VARCHAR(100) NOT NULL UNIQUE,
    "PasswordHash" VARCHAR(255) NOT NULL,
    "Department" VARCHAR(50),
    "Role" VARCHAR(50) NOT NULL DEFAULT 'User',
    "IsActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "LastLoginAt" TIMESTAMP
);

-- 建立索引
CREATE INDEX "IX_Users_Email" ON "Users" ("Email");

-- ================================
-- 2. 創建 Stores 資料表
-- ================================
CREATE TABLE IF NOT EXISTS "Stores" (
    "StoreId" SERIAL PRIMARY KEY,
    "Name" VARCHAR(100) NOT NULL,
    "Category" VARCHAR(20) NOT NULL,
    "Phone" VARCHAR(20),
    "Address" VARCHAR(200),
    "MenuUrl" VARCHAR(500),
    "IsActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 建立索引
CREATE INDEX "IX_Stores_Category" ON "Stores" ("Category");

-- ================================
-- 3. 創建 MenuItems 資料表
-- ================================
CREATE TABLE IF NOT EXISTS "MenuItems" (
    "MenuItemId" SERIAL PRIMARY KEY,
    "StoreId" INTEGER NOT NULL,
    "Name" VARCHAR(100) NOT NULL,
    "Category" VARCHAR(50),
    "PriceRules" TEXT,
    "Options" TEXT,
    "ImageUrl" VARCHAR(500),
    "IsAvailable" BOOLEAN NOT NULL DEFAULT TRUE,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "FK_MenuItems_Stores" FOREIGN KEY ("StoreId") 
        REFERENCES "Stores" ("StoreId") ON DELETE CASCADE
);

-- 建立索引
CREATE INDEX "IX_MenuItems_StoreId" ON "MenuItems" ("StoreId");

-- ================================
-- 4. 創建 Events 資料表
-- ================================
CREATE TABLE IF NOT EXISTS "Events" (
    "EventId" SERIAL PRIMARY KEY,
    "Title" VARCHAR(100) NOT NULL,
    "InitiatorId" INTEGER NOT NULL,
    "Status" VARCHAR(20) NOT NULL DEFAULT 'Open',
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ClosedAt" TIMESTAMP,
    "DeliveredAt" TIMESTAMP,
    "Notes" VARCHAR(500),
    "OrderType" VARCHAR(20),
    "Deadline" TIMESTAMP,
    "DeliveryFee" DECIMAL(10, 2) NOT NULL DEFAULT 0,
    CONSTRAINT "FK_Events_Users" FOREIGN KEY ("InitiatorId") 
        REFERENCES "Users" ("UserId") ON DELETE RESTRICT
);

-- 建立索引
CREATE INDEX "IX_Events_Status" ON "Events" ("Status");
CREATE INDEX "IX_Events_CreatedAt" ON "Events" ("CreatedAt");

-- ================================
-- 5. 創建 OrderGroups 資料表
-- ================================
CREATE TABLE IF NOT EXISTS "OrderGroups" (
    "GroupId" SERIAL PRIMARY KEY,
    "EventId" INTEGER NOT NULL,
    "StoreId" INTEGER NOT NULL,
    "Deadline" TIMESTAMP NOT NULL,
    "Status" VARCHAR(20) NOT NULL DEFAULT 'Open',
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "FK_OrderGroups_Events" FOREIGN KEY ("EventId") 
        REFERENCES "Events" ("EventId") ON DELETE CASCADE,
    CONSTRAINT "FK_OrderGroups_Stores" FOREIGN KEY ("StoreId") 
        REFERENCES "Stores" ("StoreId") ON DELETE RESTRICT
);

-- 建立索引
CREATE INDEX "IX_OrderGroups_EventId" ON "OrderGroups" ("EventId");

-- ================================
-- 6. 創建 OrderItems 資料表
-- ================================
CREATE TABLE IF NOT EXISTS "OrderItems" (
    "OrderItemId" SERIAL PRIMARY KEY,
    "GroupId" INTEGER NOT NULL,
    "UserId" INTEGER NOT NULL,
    "ItemId" INTEGER NOT NULL,
    "SizeCode" VARCHAR(20) NOT NULL,
    "SizeName" VARCHAR(50) NOT NULL,
    "Quantity" INTEGER NOT NULL DEFAULT 1,
    "CustomOptions" VARCHAR(200),
    "Toppings" VARCHAR(500),
    "Note" VARCHAR(200),
    "BasePrice" DECIMAL(8, 1) NOT NULL,
    "ToppingPrice" DECIMAL(8, 1) NOT NULL DEFAULT 0,
    "UnitPrice" DECIMAL(8, 1) NOT NULL,
    "SubTotal" DECIMAL(8, 1) NOT NULL,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "FK_OrderItems_OrderGroups" FOREIGN KEY ("GroupId") 
        REFERENCES "OrderGroups" ("GroupId") ON DELETE CASCADE,
    CONSTRAINT "FK_OrderItems_Users" FOREIGN KEY ("UserId") 
        REFERENCES "Users" ("UserId") ON DELETE RESTRICT,
    CONSTRAINT "FK_OrderItems_MenuItems" FOREIGN KEY ("ItemId") 
        REFERENCES "MenuItems" ("MenuItemId") ON DELETE RESTRICT
);

-- 建立索引
CREATE INDEX "IX_OrderItems_GroupId" ON "OrderItems" ("GroupId");
CREATE INDEX "IX_OrderItems_UserId" ON "OrderItems" ("UserId");

-- ================================
-- 7. 插入測試用管理員帳號
-- ================================
-- 密碼：admin999（已使用 BCrypt 加密）
INSERT INTO "Users" ("Name", "Email", "PasswordHash", "Department", "Role", "IsActive") 
VALUES (
    'Administrator',
    'admin@company.com',
    '$2a$11$YmXqK7zJWzK3FqX8Qs1Qe.gXyZcH8YhFqM9eR3qLvP5KdN7wJ8Xm2',
    'IT',
    'Admin',
    TRUE
)
ON CONFLICT ("Email") DO NOTHING;

-- ================================
-- 8. 插入測試店家（選填）
-- ================================
-- 50嵐（飲料店）
INSERT INTO "Stores" ("Name", "Category", "Phone", "Address") 
VALUES (
    '50嵐',
    '飲料',
    '02-1234-5678',
    '台北市大安區'
)
ON CONFLICT DO NOTHING;

-- 清心福全（飲料店）
INSERT INTO "Stores" ("Name", "Category", "Phone", "Address") 
VALUES (
    '清心福全',
    '飲料',
    '02-2345-6789',
    '台北市信義區'
)
ON CONFLICT DO NOTHING;

-- ================================
-- 完成
-- ================================
-- 資料庫結構創建完成！
-- 您現在可以啟動 ASP.NET Core 應用程式連接此資料庫
