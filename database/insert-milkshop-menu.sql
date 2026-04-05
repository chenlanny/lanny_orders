-- 刪除迷克夏的所有菜單項目（清理亂碼）
DELETE FROM MenuItems WHERE StoreId = 6;
GO

-- 插入迷克夏菜單項目（使用 N 前綴確保正確儲存繁體中文）

-- 1. 迷克珍珠
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable)
VALUES (
    6,
    N'迷克珍珠',
    N'珍奶系列',
    N'{"小杯":45,"中杯":50,"大杯":60}',
    N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":0},{"name":"椰果","price":5}]}',
    1
);

-- 2. 迷克奶茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable)
VALUES (
    6,
    N'迷克奶茶',
    N'奶茶系列',
    N'{"小杯":40,"中杯":45,"大杯":55}',
    N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10},{"name":"椰果","price":5}]}',
    1
);

-- 3. 觀音拿鐵
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable)
VALUES (
    6,
    N'觀音拿鐵',
    N'拿鐵系列',
    N'{"中杯":55,"大杯":65}',
    N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10}]}',
    1
);

-- 4. 烏龍奶茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable)
VALUES (
    6,
    N'烏龍奶茶',
    N'奶茶系列',
    N'{"小杯":40,"中杯":45,"大杯":55}',
    N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10}]}',
    1
);

-- 5. 紅茶拿鐵
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable)
VALUES (
    6,
    N'紅茶拿鐵',
    N'拿鐵系列',
    N'{"中杯":50,"大杯":60}',
    N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10}]}',
    1
);

-- 6. 綠茶拿鐵
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable)
VALUES (
    6,
    N'綠茶拿鐵',
    N'拿鐵系列',
    N'{"中杯":50,"大杯":60}',
    N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"]}',
    1
);

-- 7. 冬瓜檸檬
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable)
VALUES (
    6,
    N'冬瓜檸檬',
    N'果茶系列',
    N'{"中杯":45,"大杯":55}',
    N'{"sweetness":["正常","少糖","微糖"],"temperature":["正常冰","少冰","微冰","去冰"]}',
    1
);

-- 8. 金萱青茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable)
VALUES (
    6,
    N'金萱青茶',
    N'茶飲系列',
    N'{"中杯":30,"大杯":35,"瓶裝":40}',
    N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"]}',
    1
);

-- 9. 茉莉綠茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable)
VALUES (
    6,
    N'茉莉綠茶',
    N'茶飲系列',
    N'{"中杯":25,"大杯":30,"瓶裝":35}',
    N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"]}',
    1
);

-- 10. 蜂蜜檸檬
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable)
VALUES (
    6,
    N'蜂蜜檸檬',
    N'果茶系列',
    N'{"中杯":50,"大杯":60}',
    N'{"sweetness":["正常","少糖"],"temperature":["正常冰","少冰","微冰","去冰"]}',
    1
);

GO

-- 查詢結果確認
SELECT ItemId, Name, Category, PriceRules, IsAvailable
FROM MenuItems
WHERE StoreId = 6
ORDER BY ItemId;
GO
