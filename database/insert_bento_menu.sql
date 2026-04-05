USE L_DBII;
GO

-- 清空現有便當菜單（如有）
DELETE FROM MenuItems WHERE StoreId IN (3, 4);
GO

-- ========== 池上便當 (StoreId=3) ==========

-- 排骨便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt) VALUES
(3, N'排骨便當', N'經典便當', N'{"標準":85}', N'{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', 1, GETDATE());

-- 雞腿便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt) VALUES
(3, N'雞腿便當', N'經典便當', N'{"標準":90}', N'{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', 1, GETDATE());

-- 炸雞便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt) VALUES
(3, N'炸雞便當', N'經典便當', N'{"標準":85}', N'{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', 1, GETDATE());

-- 控肉便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt) VALUES
(3, N'控肉便當', N'經典便當', N'{"標準":80}', N'{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', 1, GETDATE());

-- 鱈魚便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt) VALUES
(3, N'鱈魚便當', N'海鮮便當', N'{"標準":95}', N'{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', 1, GETDATE());

-- 鯖魚便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt) VALUES
(3, N'鯖魚便當', N'海鮮便當', N'{"標準":90}', N'{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', 1, GETDATE());

-- 素食便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt) VALUES
(3, N'素食便當', N'素食系列', N'{"標準":75}', N'{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10}]}', 1, GETDATE());

-- 雙拼便當（排骨+雞腿）
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt) VALUES
(3, N'雙拼便當', N'特色便當', N'{"標準":120}', N'{"portions":["標準"],"combos":["排骨+雞腿","排骨+炸雞","雞腿+炸雞"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', 1, GETDATE());

-- ========== 悟饕便當 (StoreId=4) ==========

-- 招牌排骨便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt) VALUES
(4, N'招牌排骨便當', N'經典便當', N'{"標準":80}', N'{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', 1, GETDATE());

-- 雞腿便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt) VALUES
(4, N'雞腿便當', N'經典便當', N'{"標準":85}', N'{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', 1, GETDATE());

-- 炸雞便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt) VALUES
(4, N'炸雞便當', N'經典便當', N'{"標準":80}', N'{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', 1, GETDATE());

-- 爌肉便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt) VALUES
(4, N'爌肉便當', N'經典便當', N'{"標準":85}', N'{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', 1, GETDATE());

-- 焢肉便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt) VALUES
(4, N'焢肉便當', N'經典便當', N'{"標準":75}', N'{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', 1, GETDATE());

-- 鱈魚便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt) VALUES
(4, N'鱈魚便當', N'海鮮便當', N'{"標準":90}', N'{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', 1, GETDATE());

-- 素食便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt) VALUES
(4, N'素食便當', N'素食系列', N'{"標準":70}', N'{"portions":["標準"],"extras":[{"name":"加飯","price":0}]}', 1, GETDATE());

-- 豬排便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt) VALUES
(4, N'豬排便當', N'經典便當', N'{"標準":85}', N'{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', 1, GETDATE());

-- 雙主菜便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options, IsAvailable, CreatedAt) VALUES
(4, N'雙主菜便當', N'特色便當', N'{"標準":110}', N'{"portions":["標準"],"combos":["排骨+雞腿","排骨+炸雞","雞腿+炸雞"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', 1, GETDATE());

GO

PRINT N'✓ 便當菜單新增完成（繁體中文）';
PRINT N'✓ 池上便當: 8 項';
PRINT N'✓ 悟饕便當: 9 項';

-- 顯示統計
SELECT s.Name AS 店家, COUNT(*) AS 菜單數量
FROM MenuItems mi
JOIN Stores s ON mi.StoreId = s.StoreId
WHERE mi.StoreId IN (3, 4)
GROUP BY s.Name;

-- 顯示範例菜單
SELECT TOP 3 mi.Name AS 品項, mi.Category AS 類別, mi.PriceRules AS 價格
FROM MenuItems mi
WHERE mi.StoreId = 3
ORDER BY mi.ItemId;
