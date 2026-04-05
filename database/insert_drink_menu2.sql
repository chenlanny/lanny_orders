-- 50嵐飲料菜單
-- 清心福全飲料菜單

USE L_DBII;
GO

-- 清空現有菜單項（保留店家）
DELETE FROM MenuItems WHERE StoreId IN (1, 2);
GO

-- ========== 50嵐 (StoreId=1) ==========

-- 珍珠奶茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt)
VALUES (1, N'珍珠奶茶', N'奶茶系列', N'{"中杯":50,"大杯":55,"瓶裝":60}', N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":0},{"name":"椰果","price":10},{"name":"布丁","price":10}]}', 1, GETDATE());

-- 烏龍綠茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt)
VALUES (1, N'烏龍綠茶', N'茶類', N'{"中杯":35,"大杯":40,"瓶裝":45}', N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10},{"name":"椰果","price":10}]}', 1, GETDATE());

-- 四季春茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt)
VALUES (1, N'四季春茶', N'茶類', N'{"中杯":30,"大杯":35,"瓶裝":40}', N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10},{"name":"椰果","price":10}]}', 1, GETDATE());

-- 波霸奶茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt)
VALUES (1, N'波霸奶茶', N'奶茶系列', N'{"中杯":55,"大杯":60,"瓶裝":65}', N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"波霸","price":0},{"name":"椰果","price":10},{"name":"布丁","price":10}]}', 1, GETDATE());

-- 檸檬綠茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt)
VALUES (1, N'檸檬綠茶', N'果茶系列', N'{"中杯":40,"大杯":45,"瓶裝":50}', N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰"],"toppings":[{"name":"蘆薈","price":10},{"name":"椰果","price":10}]}', 1, GETDATE());

-- 冬瓜檸檬
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt)
VALUES (1, N'冬瓜檸檬', N'果茶系列', N'{"中杯":45,"大杯":50,"瓶裝":55}', N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰"],"toppings":[{"name":"蘆薈","price":10}]}', 1, GETDATE());

-- 奶蓋綠茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt)
VALUES (1, N'奶蓋綠茶', N'奶蓋系列', N'{"中杯":60,"大杯":65}', N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰"],"toppings":[]}', 1, GETDATE());

-- ========== 清心福全 (StoreId=2) ==========

-- 珍珠奶茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt)
VALUES (2, N'珍珠奶茶', N'奶茶系列', N'{"中杯":45,"大杯":50}', N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":0},{"name":"椰果","price":10},{"name":"布丁","price":10},{"name":"仙草凍","price":10}]}', 1, GETDATE());

-- 烏龍綠茶（翡翠烏龍）
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt)
VALUES (2, N'烏龍綠茶', N'茗品系列', N'{"中杯":30,"大杯":35}', N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10},{"name":"椰果","price":10}]}', 1, GETDATE());

-- 特級綠茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt)
VALUES (2, N'特級綠茶', N'茗品系列', N'{"中杯":25,"大杯":30}', N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10},{"name":"椰果","price":10}]}', 1, GETDATE());

-- 錫蘭紅茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt)
VALUES (2, N'錫蘭紅茶', N'茗品系列', N'{"中杯":25,"大杯":30}', N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10},{"name":"椰果","price":10}]}', 1, GETDATE());

-- 檸檬綠茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt)
VALUES (2, N'檸檬綠茶', N'季節鮮果系列', N'{"中杯":40,"大杯":45}', N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰"],"toppings":[{"name":"蘆薈","price":10}]}', 1, GETDATE());

-- 蜂蜜檸檬
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt)
VALUES (2, N'蜂蜜檸檬', N'季節鮮果系列', N'{"中杯":45,"大杯":50}', N'{"sweetness":["正常","少糖","半糖","微糖"],"temperature":["正常冰","少冰","微冰","去冰"],"toppings":[{"name":"蘆薈","price":10}]}', 1, GETDATE());

-- 冬瓜檸檬
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt)
VALUES (2, N'冬瓜檸檬', N'冬瓜系列', N'{"中杯":40,"大杯":45}', N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰"],"toppings":[{"name":"蘆薈","price":10}]}', 1, GETDATE());

-- 優多綠茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt)
VALUES (2, N'優多綠茶', N'優多系列', N'{"中杯":45,"大杯":50}', N'{"sweetness":["正常","少糖"],"temperature":["正常冰","少冰"],"toppings":[{"name":"蘆薈","price":10}]}', 1, GETDATE());

-- 琥珀黑糖奶茶
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt)
VALUES (2, N'琥珀黑糖奶茶', N'奶茶系列', N'{"中杯":55,"大杯":60}', N'{"sweetness":["正常","少糖"],"temperature":["正常冰","少冰","微冰"],"toppings":[{"name":"珍珠","price":10},{"name":"波霸","price":10}]}', 1, GETDATE());

-- 紅茶拿鐵（鮮奶茶）
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt)
VALUES (2, N'紅茶拿鐵', N'鮮奶系列', N'{"中杯":50,"大杯":55}', N'{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10},{"name":"波霸","price":10},{"name":"布丁","price":10}]}', 1, GETDATE());

GO

PRINT N'菜單項目新增完成！';
PRINT N'50嵐: 7 項';
PRINT N'清心福全: 10 項';

SELECT StoreId, Name AS StoreName, COUNT(*) AS MenuCount
FROM MenuItems mi
JOIN Stores s ON mi.StoreId = s.StoreId
WHERE mi.StoreId IN (1, 2)
GROUP BY mi.StoreId, s.Name;
