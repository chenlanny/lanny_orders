-- 50嵐飲?��???
-- 清�?福全飲�??�單

USE L_DBII;
GO

-- 清空?��??�單?��?保�?店家�?
DELETE FROM MenuItems WHERE StoreId IN (1, 2);
GO

-- ========== 50�?(StoreId=1) ==========

-- ?��?奶茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, ImageUrl, IsAvailable, CreatedAt)
VALUES (
    1,
    N'?��?奶茶',
    N'奶茶系�?',
    N'{"中杯":50,"大杯":55,"?��?":60}',
    N'{"sweetness":["�?��","少�?","?��?","微�?","?��?"],"temperature":["�?��??,"少冰","微冰","?�冰","�?,"??],"toppings":[{"name":"?��?","price":0},{"name":"椰�?","price":10},{"name":"布�?","price":10}]}',
    NULL,
    1,
    GETDATE()
);

-- ?��?綠茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, ImageUrl, IsAvailable, CreatedAt)
VALUES (
    1,
    N'?��?綠茶',
    N'?��?',
N'{"中杯":35,"大杯":40,"?��?":45}',
    N'{"sweetness":["�?��","少�?","?��?","微�?","?��?"],"temperature":["�?��??,"少冰","微冰","?�冰","�?,"??],"toppings":[{"name":"?��?","price":10},{"name":"椰�?","price":10}]}',
    NULL,
    1,
    GETDATE()
);

-- ?�季?�茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, ImageUrl, IsAvailable, CreatedAt)
VALUES (
    1,
    N'?�季?�茶',
    N'?��?',
N'{"中杯":30,"大杯":35,"?��?":40}',
    N'{"sweetness":["�?��","少�?","?��?","微�?","?��?"],"temperature":["�?��??,"少冰","微冰","?�冰","�?,"??],"toppings":[{"name":"?��?","price":10},{"name":"椰�?","price":10}]}',
    NULL,
    1,
    GETDATE()
);

-- 波霸奶茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, ImageUrl, IsAvailable, CreatedAt)
VALUES (
    1,
    N'波霸奶茶',
    N'奶茶系�?',
N'{"中杯":55,"大杯":60,"?��?":65}',
    N'{"sweetness":["�?��","少�?","?��?","微�?","?��?"],"temperature":["�?��??,"少冰","微冰","?�冰","�?,"??],"toppings":[{"name":"波霸","price":0},{"name":"椰�?","price":10},{"name":"布�?","price":10}]}',
    NULL,
    1,
    GETDATE()
);

-- 檸檬綠茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, ImageUrl, IsAvailable, CreatedAt)
VALUES (
    1,
    N'檸檬綠茶',
    N'?�茶系�?',
N'{"中杯":40,"大杯":45,"?��?":50}',
    N'{"sweetness":["�?��","少�?","?��?","微�?","?��?"],"temperature":["�?��??,"少冰","微冰","?�冰"],"toppings":[{"name":"?��?","price":10},{"name":"椰�?","price":10}]}',
    NULL,
    1,
    GETDATE()
);

-- ?��?檸檬
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, ImageUrl, IsAvailable, CreatedAt)
VALUES (
    1,
    N'?��?檸檬',
    N'?�茶系�?',
N'{"中杯":45,"大杯":50,"?��?":55}',
    N'{"sweetness":["�?��","少�?","?��?","微�?","?��?"],"temperature":["�?��??,"少冰","微冰","?�冰"],"toppings":[{"name":"?��?","price":10}]}',
    NULL,
    1,
    GETDATE()
);

-- 奶�?綠茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, ImageUrl, IsAvailable, CreatedAt)
VALUES (
    1,
    N'奶�?綠茶',
    N'奶�?系�?',
N'{"中杯":60,"大杯":65}',
    N'{"sweetness":["�?��","少�?","?��?","微�?","?��?"],"temperature":["�?��??,"少冰"],"toppings":[]}',
    NULL,
    1,
    GETDATE()
);

-- ========== 清�?福全 (StoreId=2) ==========

-- ?��?奶茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, ImageUrl, IsAvailable, CreatedAt)
VALUES (
    2,
    N'?��?奶茶',
    N'奶茶系�?',
N'{"中杯":45,"大杯":50}',
    N'{"sweetness":["�?��","少�?","?��?","微�?","?��?"],"temperature":["�?��??,"少冰","微冰","?�冰","�?,"??],"toppings":[{"name":"?��?","price":0},{"name":"椰�?","price":10},{"name":"布�?","price":10},{"name":"仙�???,"price":10}]}',
    NULL,
    1,
    GETDATE()
);

-- ?��?綠茶（翡翠�?龍�?
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, ImageUrl, IsAvailable, CreatedAt)
VALUES (
    2,
    N'?��?綠茶',
    N'?��?系�?',
N'{"中杯":30,"大杯":35}',
    N'{"sweetness":["�?��","少�?","?��?","微�?","?��?"],"temperature":["�?��??,"少冰","微冰","?�冰","�?,"??],"toppings":[{"name":"?��?","price":10},{"name":"椰�?","price":10}]}',
    NULL,
    1,
    GETDATE()
);

-- ?��?綠茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, ImageUrl, IsAvailable, CreatedAt)
VALUES (
    2,
    N'?��?綠茶',
    N'?��?系�?',
N'{"中杯":25,"大杯":30}',
    N'{"sweetness":["�?��","少�?","?��?","微�?","?��?"],"temperature":["�?��??,"少冰","微冰","?�冰","�?,"??],"toppings":[{"name":"?��?","price":10},{"name":"椰�?","price":10}]}',
    NULL,
    1,
    GETDATE()
);

-- ?�蘭紅茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, ImageUrl, IsAvailable, CreatedAt)
VALUES (
    2,
    N'?�蘭紅茶',
    N'?��?系�?',
N'{"中杯":25,"大杯":30}',
    N'{"sweetness":["�?��","少�?","?��?","微�?","?��?"],"temperature":["�?��??,"少冰","微冰","?�冰","�?,"??],"toppings":[{"name":"?��?","price":10},{"name":"椰�?","price":10}]}',
    NULL,
    1,
    GETDATE()
);

-- 檸檬綠茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, ImageUrl, IsAvailable, CreatedAt)
VALUES (
    2,
    N'檸檬綠茶',
    N'�??鮮�?系�?',
N'{"中杯":40,"大杯":45}',
    N'{"sweetness":["�?��","少�?","?��?","微�?","?��?"],"temperature":["�?��??,"少冰","微冰","?�冰"],"toppings":[{"name":"?��?","price":10}]}',
    NULL,
    1,
    GETDATE()
);

-- ?��?檸檬
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, ImageUrl, IsAvailable, CreatedAt)
VALUES (
    2,
    N'?��?檸檬',
    N'�??鮮�?系�?',
N'{"中杯":45,"大杯":50}',
    N'{"sweetness":["�?��","少�?","?��?","微�?"],"temperature":["�?��??,"少冰","微冰","?�冰"],"toppings":[{"name":"?��?","price":10}]}',
    NULL,
    1,
    GETDATE()
);

-- ?��?檸檬
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, ImageUrl, IsAvailable, CreatedAt)
VALUES (
    2,
    N'?��?檸檬',
    N'?��?系�?',
N'{"中杯":40,"大杯":45}',
    N'{"sweetness":["�?��","少�?","?��?","微�?","?��?"],"temperature":["�?��??,"少冰","微冰","?�冰"],"toppings":[{"name":"?��?","price":10}]}',
    NULL,
    1,
    GETDATE()
);

-- ?��?綠茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, ImageUrl, IsAvailable, CreatedAt)
VALUES (
    2,
    N'?��?綠茶',
    N'?��?系�?',
N'{"中杯":45,"大杯":50}',
    N'{"sweetness":["�?��","少�?"],"temperature":["�?��??,"少冰"],"toppings":[{"name":"?��?","price":10}]}',
    NULL,
    1,
    GETDATE()
);

-- ?��?黑�?奶茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, ImageUrl, IsAvailable, CreatedAt)
VALUES (
    2,
    N'?��?黑�?奶茶',
    N'奶茶系�?',
N'{"中杯":55,"大杯":60}',
    N'{"sweetness":["�?��","少�?"],"temperature":["�?��??,"少冰","微冰"],"toppings":[{"name":"?��?","price":10},{"name":"波霸","price":10}]}',
    NULL,
    1,
    GETDATE()
);

-- 紅茶?�鐵（鮮奶茶�?
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, ImageUrl, IsAvailable, CreatedAt)
VALUES (
    2,
    N'紅茶?�鐵',
    N'鮮奶系�?',
N'{"中杯":50,"大杯":55}',
    N'{"sweetness":["�?��","少�?","?��?","微�?","?��?"],"temperature":["�?��??,"少冰","微冰","?�冰","�?,"??],"toppings":[{"name":"?��?","price":10},{"name":"波霸","price":10},{"name":"布�?","price":10}]}',
    NULL,
    1,
    GETDATE()
);

GO

PRINT '?�單?�目?��?完�?�?;
PRINT '50�? 7 ??;
PRINT '清�?福全: 10 ??;
