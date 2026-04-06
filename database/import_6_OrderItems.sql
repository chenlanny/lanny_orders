
-- ================================
-- 完整数据导出（包括用户和店铺）
-- 数据日期: 2026-04-06 12:57:14
-- ================================

-- ===== Users (用户) =====
INSERT INTO "Users" ("UserId", "Email", "Name", "PasswordHash", "Role", "CreatedAt") VALUES (1, '1@company.com', '王小明', '$2a$11$paJOoGzXvwK7oixwG1k7QudpoQbmmihrppGH2nW8Qc6gemIgtAeGq', 'User', '2026-04-03 14:25:36');
INSERT INTO "Users" ("UserId", "Email", "Name", "PasswordHash", "Role", "CreatedAt") VALUES (2, '2@company.com', '李小華', '$2a$11$iFZVGtKlBPbQGgZ3wry5beDzL9hM/ziOaabM4rZ6njnLG0hqL31Em', 'User', '2026-04-03 14:25:36');
INSERT INTO "Users" ("UserId", "Email", "Name", "PasswordHash", "Role", "CreatedAt") VALUES (3, '3@company.com', '華經理', '$2a$11$DEXU9.eIqV4IwZU.aWonpuqsPDjkWPZHa2YsUMApb3agGKKD5JC5a', 'User', '2026-04-03 14:25:37');
INSERT INTO "Users" ("UserId", "Email", "Name", "PasswordHash", "Role", "CreatedAt") VALUES (4, '4@company.com', 'EC', '$2a$11$pc1HroXK6eBnjAwKyNRz6u/wt60ZHMhMi31u4zyraQSFLNqXG9Rmi', 'User', '2026-04-03 10:06:54');
INSERT INTO "Users" ("UserId", "Email", "Name", "PasswordHash", "Role", "CreatedAt") VALUES (5, 'admin@company.com', '管理員', '$2a$11$WEb6BuNDHbIctOvj67z16.avMGGRR9HIVFNIyG6UOmVWa8qwYyQ5K', 'Admin', '2026-04-03 08:03:46');
INSERT INTO "Users" ("UserId", "Email", "Name", "PasswordHash", "Role", "CreatedAt") VALUES (6, '5@company.com', '物流', '$2a$11$9TDCCGUf6METUq8.ByCFZO8uFqrxgIbjGWboa.nMzo/MoDc6IKK4i', 'User', '2026-04-05 22:35:15');

-- ===== Stores (店铺) =====
INSERT INTO "Stores" ("StoreId", "Name", "Phone", "Address", "CreatedAt") VALUES (1, '50嵐', '02-1234-5678', '台北市信義區', '2026-04-03 14:25:38');
INSERT INTO "Stores" ("StoreId", "Name", "Phone", "Address", "CreatedAt") VALUES (2, '清心福全', '02-2345-6789', '台北市大安區', '2026-04-03 14:25:38');
INSERT INTO "Stores" ("StoreId", "Name", "Phone", "Address", "CreatedAt") VALUES (3, '池上便當', '02-3456-7890', '台北市中山區', '2026-04-03 14:25:39');
INSERT INTO "Stores" ("StoreId", "Name", "Phone", "Address", "CreatedAt") VALUES (4, '悟饕便當', '02-4567-8901', '台北市松山區', '2026-04-03 14:25:39');
INSERT INTO "Stores" ("StoreId", "Name", "Phone", "Address", "CreatedAt") VALUES (6, '迷克夏', '02-2345-6789', '台北市大安區', '2026-04-03 10:23:05');
INSERT INTO "Stores" ("StoreId", "Name", "Phone", "Address", "CreatedAt") VALUES (7, '一芳水果茶', '03-3075581', NULL, '2026-04-03 15:23:43');


-- ================================

-- SQL Server 数据导出（正确表结构）

-- 数据日期: 2026-04-06 12:56:48

-- ================================



-- ===== MenuItems (菜单项) =====

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (21, 1, '珍珠奶茶', '奶茶系列', '{"中杯":50,"大杯":55,"瓶裝":60}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":0},{"name":"椰果","price":10},{"name":"布丁","price":10}]}', NULL, true, '2026-04-03 16:49:24');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (22, 1, '烏龍綠茶', '茶類', '{"中杯":35,"大杯":40,"瓶裝":45}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10},{"name":"椰果","price":10}]}', NULL, true, '2026-04-03 16:49:24');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (23, 1, '四季春茶', '茶類', '{"中杯":30,"大杯":35,"瓶裝":40}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10},{"name":"椰果","price":10}]}', NULL, true, '2026-04-03 16:49:24');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (24, 1, '波霸奶茶', '奶茶系列', '{"中杯":55,"大杯":60,"瓶裝":65}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"波霸","price":0},{"name":"椰果","price":10},{"name":"布丁","price":10}]}', NULL, true, '2026-04-03 16:49:24');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (25, 1, '檸檬綠茶', '果茶系列', '{"中杯":40,"大杯":45,"瓶裝":50}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰"],"toppings":[{"name":"蘆薈","price":10},{"name":"椰果","price":10}]}', NULL, true, '2026-04-03 16:49:24');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (26, 1, '冬瓜檸檬', '果茶系列', '{"中杯":45,"大杯":50,"瓶裝":55}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰"],"toppings":[{"name":"蘆薈","price":10}]}', NULL, true, '2026-04-03 16:49:24');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (27, 1, '奶蓋綠茶', '奶蓋系列', '{"中杯":60,"大杯":65}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰"],"toppings":[]}', NULL, true, '2026-04-03 16:49:24');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (28, 2, '珍珠奶茶', '奶茶系列', '{"中杯":45,"大杯":50}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":0},{"name":"椰果","price":10},{"name":"布丁","price":10},{"name":"仙草凍","price":10}]}', NULL, true, '2026-04-03 16:49:24');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (29, 2, '烏龍綠茶', '茗品系列', '{"中杯":30,"大杯":35}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10},{"name":"椰果","price":10}]}', NULL, true, '2026-04-03 16:49:24');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (30, 2, '特級綠茶', '茗品系列', '{"中杯":25,"大杯":30}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10},{"name":"椰果","price":10}]}', NULL, true, '2026-04-03 16:49:24');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (31, 2, '錫蘭紅茶', '茗品系列', '{"中杯":25,"大杯":30}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10},{"name":"椰果","price":10}]}', NULL, true, '2026-04-03 16:49:24');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (32, 2, '檸檬綠茶', '季節鮮果系列', '{"中杯":40,"大杯":45}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰"],"toppings":[{"name":"蘆薈","price":10}]}', NULL, true, '2026-04-03 16:49:24');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (33, 2, '蜂蜜檸檬', '季節鮮果系列', '{"中杯":45,"大杯":50}', '{"sweetness":["正常","少糖","半糖","微糖"],"temperature":["正常冰","少冰","微冰","去冰"],"toppings":[{"name":"蘆薈","price":10}]}', NULL, true, '2026-04-03 16:49:24');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (34, 2, '冬瓜檸檬', '冬瓜系列', '{"中杯":40,"大杯":45}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰"],"toppings":[{"name":"蘆薈","price":10}]}', NULL, true, '2026-04-03 16:49:24');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (35, 2, '優多綠茶', '優多系列', '{"中杯":45,"大杯":50}', '{"sweetness":["正常","少糖"],"temperature":["正常冰","少冰"],"toppings":[{"name":"蘆薈","price":10}]}', NULL, true, '2026-04-03 16:49:24');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (36, 2, '琥珀黑糖奶茶', '奶茶系列', '{"中杯":55,"大杯":60}', '{"sweetness":["正常","少糖"],"temperature":["正常冰","少冰","微冰"],"toppings":[{"name":"珍珠","price":10},{"name":"波霸","price":10}]}', NULL, true, '2026-04-03 16:49:24');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (37, 2, '紅茶拿鐵', '鮮奶系列', '{"中杯":50,"大杯":55}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10},{"name":"波霸","price":10},{"name":"布丁","price":10}]}', NULL, true, '2026-04-03 16:49:24');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (38, 3, '排骨便當', '經典便當', '{"標準":85}', '{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', NULL, true, '2026-04-03 16:55:48');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (39, 3, '雞腿便當', '經典便當', '{"標準":90}', '{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', NULL, true, '2026-04-03 16:55:48');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (40, 3, '炸雞便當', '經典便當', '{"標準":85}', '{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', NULL, true, '2026-04-03 16:55:48');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (41, 3, '控肉便當', '經典便當', '{"標準":80}', '{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', NULL, true, '2026-04-03 16:55:48');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (42, 3, '鱈魚便當', '海鮮便當', '{"標準":95}', '{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', NULL, true, '2026-04-03 16:55:48');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (43, 3, '鯖魚便當', '海鮮便當', '{"標準":90}', '{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', NULL, true, '2026-04-03 16:55:48');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (44, 3, '素食便當', '素食系列', '{"標準":75}', '{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10}]}', NULL, true, '2026-04-03 16:55:48');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (45, 3, '雙拼便當', '特色便當', '{"標準":120}', '{"portions":["標準"],"combos":["排骨+雞腿","排骨+炸雞","雞腿+炸雞"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', NULL, true, '2026-04-03 16:55:48');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (46, 4, '招牌排骨便當', '經典便當', '{"標準":80}', '{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', NULL, true, '2026-04-03 16:55:48');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (47, 4, '雞腿便當', '經典便當', '{"標準":85}', '{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', NULL, true, '2026-04-03 16:55:48');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (48, 4, '炸雞便當', '經典便當', '{"標準":80}', '{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', NULL, true, '2026-04-03 16:55:48');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (49, 4, '爌肉便當', '經典便當', '{"標準":85}', '{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', NULL, true, '2026-04-03 16:55:48');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (50, 4, '焢肉便當', '經典便當', '{"標準":75}', '{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', NULL, true, '2026-04-03 16:55:48');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (51, 4, '鱈魚便當', '海鮮便當', '{"標準":90}', '{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', NULL, true, '2026-04-03 16:55:48');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (52, 4, '素食便當', '素食系列', '{"標準":70}', '{"portions":["標準"],"extras":[{"name":"加飯","price":0}]}', NULL, true, '2026-04-03 16:55:48');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (53, 4, '豬排便當', '經典便當', '{"標準":85}', '{"portions":["標準"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', NULL, true, '2026-04-03 16:55:48');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (54, 4, '雙主菜便當', '特色便當', '{"標準":110}', '{"portions":["標準"],"combos":["排骨+雞腿","排骨+炸雞","雞腿+炸雞"],"extras":[{"name":"加飯","price":0},{"name":"加滷蛋","price":10},{"name":"加青菜","price":10}]}', NULL, true, '2026-04-03 16:55:48');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (75, 6, '迷克珍珠', '珍奶系列', '{"小杯":45,"中杯":50,"大杯":60}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":0},{"name":"椰果","price":5}]}', NULL, true, '2026-04-03 18:29:04');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (76, 6, '迷克奶茶', '奶茶系列', '{"小杯":40,"中杯":45,"大杯":55}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10},{"name":"椰果","price":5}]}', NULL, true, '2026-04-03 18:29:04');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (77, 6, '觀音拿鐵', '拿鐵系列', '{"中杯":55,"大杯":65}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10}]}', NULL, true, '2026-04-03 18:29:04');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (78, 6, '烏龍奶茶', '奶茶系列', '{"小杯":40,"中杯":45,"大杯":55}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10}]}', NULL, true, '2026-04-03 18:29:04');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (79, 6, '紅茶拿鐵', '拿鐵系列', '{"中杯":50,"大杯":60}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10}]}', NULL, true, '2026-04-03 18:29:04');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (80, 6, '綠茶拿鐵', '拿鐵系列', '{"中杯":50,"大杯":60}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"]}', NULL, true, '2026-04-03 18:29:04');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (81, 6, '冬瓜檸檬', '果茶系列', '{"中杯":45,"大杯":55}', '{"sweetness":["正常","少糖","微糖"],"temperature":["正常冰","少冰","微冰","去冰"]}', NULL, true, '2026-04-03 18:29:04');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (82, 6, '金萱青茶', '茶飲系列', '{"中杯":30,"大杯":35,"瓶裝":40}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"]}', NULL, true, '2026-04-03 18:29:04');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (83, 6, '茉莉綠茶', '茶飲系列', '{"中杯":25,"大杯":30,"瓶裝":35}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"]}', NULL, true, '2026-04-03 18:29:04');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (84, 6, '蜂蜜檸檬', '果茶系列', '{"中杯":50,"大杯":60}', '{"sweetness":["正常","少糖"],"temperature":["正常冰","少冰","微冰","去冰"]}', NULL, true, '2026-04-03 18:29:04');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (85, 6, '甘蔗青茶', '鮮果特調', '{"中杯":50,"大杯":60}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10},{"name":"波霸","price":10}]}', NULL, true, '2026-04-03 13:49:36');

INSERT INTO "MenuItems" ("ItemId", "StoreId", "Name", "Category", "PriceRules", "Options", "ImageUrl", "IsAvailable", "CreatedAt") VALUES (86, 7, '甘蔗青茶', '特調鮮果', '{"中杯":40,"大杯":50}', '{"sweetness":["正常","少糖","半糖","微糖","無糖"],"temperature":["正常冰","少冰","微冰","去冰","溫","熱"],"toppings":[{"name":"珍珠","price":10},{"name":"波霸","price":10}]}', NULL, true, '2026-04-03 15:24:53');



-- ===== Events (活动) =====

INSERT INTO "Events" ("EventId", "Title", "InitiatorId", "Status", "CreatedAt", "ClosedAt", "DeliveredAt", "Notes", "OrderType", "Deadline", "DeliveryFee") VALUES (1, 'test', 5, '進行中', '2026-04-03 09:12:21', NULL, NULL, 'test', '飲料', '2026-04-03 19:00:00', 70.00);

INSERT INTO "Events" ("EventId", "Title", "InitiatorId", "Status", "CreatedAt", "ClosedAt", "DeliveredAt", "Notes", "OrderType", "Deadline", "DeliveryFee") VALUES (2, '????????', 5, 'Open', '2026-04-03 09:50:16', NULL, NULL, '??:????????', '飲料', '2026-04-02 17:50:16', 0.00);

INSERT INTO "Events" ("EventId", "Title", "InitiatorId", "Status", "CreatedAt", "ClosedAt", "DeliveredAt", "Notes", "OrderType", "Deadline", "DeliveryFee") VALUES (3, 'Test Past Date', 5, 'Open', '2026-04-03 09:51:55', NULL, NULL, 'Should be rejected', '飲料', '2026-04-02 17:51:55', 0.00);

INSERT INTO "Events" ("EventId", "Title", "InitiatorId", "Status", "CreatedAt", "ClosedAt", "DeliveredAt", "Notes", "OrderType", "Deadline", "DeliveryFee") VALUES (4, 'Multi-Store Test Event', 5, 'Open', '2026-04-03 09:56:53', NULL, NULL, 'Test event for system testing', '飲料', '2026-04-03 22:56:53', 65.00);

INSERT INTO "Events" ("EventId", "Title", "InitiatorId", "Status", "CreatedAt", "ClosedAt", "DeliveredAt", "Notes", "OrderType", "Deadline", "DeliveryFee") VALUES (6, '快閃團', 5, 'Open', '2026-04-03 15:29:59', NULL, NULL, '', '便當', '2026-04-03 15:50:00', 120.00);

INSERT INTO "Events" ("EventId", "Title", "InitiatorId", "Status", "CreatedAt", "ClosedAt", "DeliveredAt", "Notes", "OrderType", "Deadline", "DeliveryFee") VALUES (7, '午夜快閃', 5, 'Open', '2026-04-03 23:48:03', NULL, NULL, '', '飲料', '2026-04-03 23:56:00', 140.00);

INSERT INTO "Events" ("EventId", "Title", "InitiatorId", "Status", "CreatedAt", "ClosedAt", "DeliveredAt", "Notes", "OrderType", "Deadline", "DeliveryFee") VALUES (8, '0403', 5, 'Open', '2026-04-03 23:51:13', NULL, NULL, '', '飲料', '2026-04-03 23:59:00', 0.00);

INSERT INTO "Events" ("EventId", "Title", "InitiatorId", "Status", "CreatedAt", "ClosedAt", "DeliveredAt", "Notes", "OrderType", "Deadline", "DeliveryFee") VALUES (9, '凌晨團', 5, 'Open', '2026-04-04 00:12:11', NULL, NULL, '', '飲料', '2026-04-04 00:20:00', 10.00);

INSERT INTO "Events" ("EventId", "Title", "InitiatorId", "Status", "CreatedAt", "ClosedAt", "DeliveredAt", "Notes", "OrderType", "Deadline", "DeliveryFee") VALUES (10, 'EC GO', 4, 'Open', '2026-04-05 22:50:49', NULL, NULL, '', '飲料', '2026-04-05 23:21:00', 120.00);



-- ===== OrderGroups (订单组) =====

INSERT INTO "OrderGroups" ("GroupId", "EventId", "StoreId", "Deadline", "DeliveryFee", "Status", "CreatedAt") VALUES (1, 1, 1, '2026-04-03 20:27:34', 30.0, '進行中', '2026-04-03 09:12:21');

INSERT INTO "OrderGroups" ("GroupId", "EventId", "StoreId", "Deadline", "DeliveryFee", "Status", "CreatedAt") VALUES (2, 1, 2, '2026-04-03 20:27:34', 40.0, '進行中', '2026-04-03 09:12:21');

INSERT INTO "OrderGroups" ("GroupId", "EventId", "StoreId", "Deadline", "DeliveryFee", "Status", "CreatedAt") VALUES (3, 2, 1, '2026-04-02 17:50:16', 0.0, 'Open', '2026-04-03 09:50:16');

INSERT INTO "OrderGroups" ("GroupId", "EventId", "StoreId", "Deadline", "DeliveryFee", "Status", "CreatedAt") VALUES (4, 3, 1, '2026-04-02 17:51:55', 0.0, 'Open', '2026-04-03 09:51:55');

INSERT INTO "OrderGroups" ("GroupId", "EventId", "StoreId", "Deadline", "DeliveryFee", "Status", "CreatedAt") VALUES (5, 4, 1, '2026-04-03 22:56:53', 30.0, 'Open', '2026-04-03 09:56:53');

INSERT INTO "OrderGroups" ("GroupId", "EventId", "StoreId", "Deadline", "DeliveryFee", "Status", "CreatedAt") VALUES (6, 4, 2, '2026-04-03 22:56:53', 35.0, 'Open', '2026-04-03 09:56:53');

INSERT INTO "OrderGroups" ("GroupId", "EventId", "StoreId", "Deadline", "DeliveryFee", "Status", "CreatedAt") VALUES (8, 6, 3, '2026-04-03 15:50:00', 80.0, 'Open', '2026-04-03 15:29:59');

INSERT INTO "OrderGroups" ("GroupId", "EventId", "StoreId", "Deadline", "DeliveryFee", "Status", "CreatedAt") VALUES (9, 6, 7, '2026-04-03 15:45:00', 40.0, 'Open', '2026-04-03 15:29:59');

INSERT INTO "OrderGroups" ("GroupId", "EventId", "StoreId", "Deadline", "DeliveryFee", "Status", "CreatedAt") VALUES (10, 7, 7, '2026-04-03 23:56:00', 40.0, 'Open', '2026-04-03 23:48:03');

INSERT INTO "OrderGroups" ("GroupId", "EventId", "StoreId", "Deadline", "DeliveryFee", "Status", "CreatedAt") VALUES (11, 7, 3, '2026-04-04 00:10:00', 100.0, 'Open', '2026-04-03 23:48:03');

INSERT INTO "OrderGroups" ("GroupId", "EventId", "StoreId", "Deadline", "DeliveryFee", "Status", "CreatedAt") VALUES (12, 8, 7, '2026-04-03 23:59:00', 0.0, 'Open', '2026-04-03 23:51:13');

INSERT INTO "OrderGroups" ("GroupId", "EventId", "StoreId", "Deadline", "DeliveryFee", "Status", "CreatedAt") VALUES (13, 9, 6, '2026-04-04 00:20:00', 10.0, 'Open', '2026-04-04 00:12:12');

INSERT INTO "OrderGroups" ("GroupId", "EventId", "StoreId", "Deadline", "DeliveryFee", "Status", "CreatedAt") VALUES (14, 10, 2, '2026-04-05 23:21:00', 40.0, 'Open', '2026-04-05 22:50:49');

INSERT INTO "OrderGroups" ("GroupId", "EventId", "StoreId", "Deadline", "DeliveryFee", "Status", "CreatedAt") VALUES (15, 10, 4, '2026-04-05 23:55:00', 80.0, 'Open', '2026-04-05 22:50:49');



-- ===== OrderItems (订单项目) =====

INSERT INTO "OrderItems" ("OrderItemId", "GroupId", "UserId", "ItemId", "SizeCode", "SizeName", "Quantity", "CustomOptions", "Toppings", "Note", "BasePrice", "ToppingPrice", "UnitPrice", "SubTotal", "CreatedAt") VALUES (1, 5, 5, 24, '大杯', '大杯', 1, '微糖,溫', NULL, '', 60.0, 0.0, 60.0, 60.0, '2026-04-03 14:13:25');

INSERT INTO "OrderItems" ("OrderItemId", "GroupId", "UserId", "ItemId", "SizeCode", "SizeName", "Quantity", "CustomOptions", "Toppings", "Note", "BasePrice", "ToppingPrice", "UnitPrice", "SubTotal", "CreatedAt") VALUES (2, 6, 5, 37, '中杯', '中杯', 1, '微糖,熱', NULL, '', 50.0, 0.0, 50.0, 50.0, '2026-04-03 14:13:26');

INSERT INTO "OrderItems" ("OrderItemId", "GroupId", "UserId", "ItemId", "SizeCode", "SizeName", "Quantity", "CustomOptions", "Toppings", "Note", "BasePrice", "ToppingPrice", "UnitPrice", "SubTotal", "CreatedAt") VALUES (3, 10, 5, 86, '中杯', '中杯', 1, '正常,正常冰', NULL, '', 40.0, 0.0, 40.0, 40.0, '2026-04-03 23:55:59');

INSERT INTO "OrderItems" ("OrderItemId", "GroupId", "UserId", "ItemId", "SizeCode", "SizeName", "Quantity", "CustomOptions", "Toppings", "Note", "BasePrice", "ToppingPrice", "UnitPrice", "SubTotal", "CreatedAt") VALUES (4, 11, 5, 44, '標準', '標準', 1, '', NULL, '', 75.0, 0.0, 75.0, 75.0, '2026-04-03 23:56:00');

INSERT INTO "OrderItems" ("OrderItemId", "GroupId", "UserId", "ItemId", "SizeCode", "SizeName", "Quantity", "CustomOptions", "Toppings", "Note", "BasePrice", "ToppingPrice", "UnitPrice", "SubTotal", "CreatedAt") VALUES (5, 11, 4, 42, '標準', '標準', 1, '', NULL, '', 95.0, 0.0, 95.0, 95.0, '2026-04-04 00:00:03');

INSERT INTO "OrderItems" ("OrderItemId", "GroupId", "UserId", "ItemId", "SizeCode", "SizeName", "Quantity", "CustomOptions", "Toppings", "Note", "BasePrice", "ToppingPrice", "UnitPrice", "SubTotal", "CreatedAt") VALUES (6, 11, 4, 43, '標準', '標準', 1, '', NULL, '', 90.0, 0.0, 90.0, 90.0, '2026-04-04 00:02:20');

INSERT INTO "OrderItems" ("OrderItemId", "GroupId", "UserId", "ItemId", "SizeCode", "SizeName", "Quantity", "CustomOptions", "Toppings", "Note", "BasePrice", "ToppingPrice", "UnitPrice", "SubTotal", "CreatedAt") VALUES (7, 13, 5, 81, '中杯', '中杯', 2, '正常,正常冰', NULL, '', 45.0, 0.0, 45.0, 90.0, '2026-04-04 00:12:51');

INSERT INTO "OrderItems" ("OrderItemId", "GroupId", "UserId", "ItemId", "SizeCode", "SizeName", "Quantity", "CustomOptions", "Toppings", "Note", "BasePrice", "ToppingPrice", "UnitPrice", "SubTotal", "CreatedAt") VALUES (8, 13, 5, 84, '中杯', '中杯', 3, '正常,正常冰', NULL, '', 50.0, 0.0, 50.0, 150.0, '2026-04-04 00:12:52');

INSERT INTO "OrderItems" ("OrderItemId", "GroupId", "UserId", "ItemId", "SizeCode", "SizeName", "Quantity", "CustomOptions", "Toppings", "Note", "BasePrice", "ToppingPrice", "UnitPrice", "SubTotal", "CreatedAt") VALUES (9, 14, 4, 37, '中杯', '中杯', 3, '正常,正常冰', NULL, '', 50.0, 0.0, 50.0, 150.0, '2026-04-05 22:51:21');

INSERT INTO "OrderItems" ("OrderItemId", "GroupId", "UserId", "ItemId", "SizeCode", "SizeName", "Quantity", "CustomOptions", "Toppings", "Note", "BasePrice", "ToppingPrice", "UnitPrice", "SubTotal", "CreatedAt") VALUES (10, 15, 4, 50, '標準', '標準', 1, '', NULL, '', 75.0, 0.0, 75.0, 75.0, '2026-04-05 22:51:22');

INSERT INTO "OrderItems" ("OrderItemId", "GroupId", "UserId", "ItemId", "SizeCode", "SizeName", "Quantity", "CustomOptions", "Toppings", "Note", "BasePrice", "ToppingPrice", "UnitPrice", "SubTotal", "CreatedAt") VALUES (11, 14, 3, 31, '中杯', '中杯', 8, '正常,正常冰', NULL, '', 25.0, 0.0, 25.0, 200.0, '2026-04-05 22:53:19');

INSERT INTO "OrderItems" ("OrderItemId", "GroupId", "UserId", "ItemId", "SizeCode", "SizeName", "Quantity", "CustomOptions", "Toppings", "Note", "BasePrice", "ToppingPrice", "UnitPrice", "SubTotal", "CreatedAt") VALUES (12, 15, 3, 53, '標準', '標準', 2, '', NULL, '', 85.0, 0.0, 85.0, 170.0, '2026-04-05 22:53:19');

INSERT INTO "OrderItems" ("OrderItemId", "GroupId", "UserId", "ItemId", "SizeCode", "SizeName", "Quantity", "CustomOptions", "Toppings", "Note", "BasePrice", "ToppingPrice", "UnitPrice", "SubTotal", "CreatedAt") VALUES (13, 14, 5, 28, '中杯', '中杯', 2, '正常,正常冰', NULL, '', 45.0, 0.0, 45.0, 90.0, '2026-04-05 23:06:50');


