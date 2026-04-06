-- ================================
-- Supabase 快速部署脚本
-- 清空并重新填充测试数据
-- ================================

-- 清空现有数据
TRUNCATE TABLE "OrderItems" CASCADE;
TRUNCATE TABLE "OrderGroups" CASCADE;
TRUNCATE TABLE "Events" CASCADE;
TRUNCATE TABLE "MenuItems" CASCADE;
TRUNCATE TABLE "Stores" CASCADE;
TRUNCATE TABLE "Users" CASCADE;

-- 重置序列
ALTER SEQUENCE "Users_UserId_seq" RESTART WITH 1;
ALTER SEQUENCE "Stores_StoreId_seq" RESTART WITH 1;
ALTER SEQUENCE "MenuItems_MenuItemId_seq" RESTART WITH 1;
ALTER SEQUENCE "Events_EventId_seq" RESTART WITH 1;
ALTER SEQUENCE "OrderGroups_OrderGroupId_seq" RESTART WITH 1;
ALTER SEQUENCE "OrderItems_OrderItemId_seq" RESTART WITH 1;

-- ================================
-- 插入用户数据
-- ================================
INSERT INTO "Users" ("Email", "Name", "PasswordHash", "Role", "CreatedAt") VALUES
('admin@company.com', '系统管理员', '$2a$11$rQF8vF0QhJZYPZx6vxJF4.OYqK8WqK4pZ8K9nZ0nZ0nZ0nZ0nZ0n.', 'Admin', NOW()),
('user1@company.com', '张小明', '$2a$11$rQF8vF0QhJZYPZx6vxJF4.OYqK8WqK4pZ8K9nZ0nZ0nZ0nZ0nZ0n.', 'User', NOW()),
('user2@company.com', '李美华', '$2a$11$rQF8vF0QhJZYPZx6vxJF4.OYqK8WqK4pZ8K9nZ0nZ0nZ0nZ0nZ0n.', 'User', NOW()),
('user3@company.com', '王大伟', '$2a$11$rQF8vF0QhJZYPZx6vxJF4.OYqK8WqK4pZ8K9nZ0nZ0nZ0nZ0nZ0n.', 'User', NOW()),
('user4@company.com', '陈小玲', '$2a$11$rQF8vF0QhJZYPZx6vxJF4.OYqK8WqK4pZ8K9nZ0nZ0nZ0nZ0nZ0n.', 'User', NOW()),
('user5@company.com', '林志强', '$2a$11$rQF8vF0QhJZYPZx6vxJF4.OYqK8WqK4pZ8K9nZ0nZ0nZ0nZ0nZ0n.', 'User', NOW());

-- ================================
-- 插入店家数据
-- ================================
INSERT INTO "Stores" ("Name", "Phone", "Address", "DeliveryFee", "MinOrderAmount", "IsActive", "CreatedAt") VALUES
('珍珠奶茶专卖店', '02-1234-5678', '台北市中正区中山南路21号', 30, 50, true, NOW()),
('美味便当店', '02-2345-6789', '台北市大安区信义路四段1号', 35, 100, true, NOW()),
('早餐吐司店', '02-3456-7890', '台北市松山区南京东路三段303号', 25, 40, true, NOW());

-- ================================
-- 插入菜单项目数据
-- ================================
INSERT INTO "MenuItems" ("StoreId", "Name", "Price", "Category", "Description", "IsAvailable", "CreatedAt") VALUES
-- 珍珠奶茶店菜单
(1, '珍珠奶茶', 50, '奶茶类', '经典珍珠奶茶', true, NOW()),
(1, '波霸奶茶', 55, '奶茶类', '大颗珍珠奶茶', true, NOW()),
(1, '布丁奶茶', 55, '奶茶类', '香浓布丁奶茶', true, NOW()),
(1, '椰果奶茶', 50, '奶茶类', '清爽椰果奶茶', true, NOW()),
(1, '红茶拿铁', 60, '奶茶类', '浓郁红茶拿铁', true, NOW()),
(1, '绿茶', 30, '茶类', '清香绿茶', true, NOW()),
(1, '红茶', 30, '茶类', '经典红茶', true, NOW()),

-- 便当店菜单
(2, '鸡腿便当', 85, '便当', '香嫩鸡腿便当', true, NOW()),
(2, '排骨便当', 80, '便当', '酥脆排骨便当', true, NOW()),
(2, '鱼排便当', 75, '便当', '金黄鱼排便当', true, NOW()),
(2, '素食便当', 70, '便当', '健康素食便当', true, NOW()),
(2, '炸鸡便当', 80, '便当', '酥脆炸鸡便当', true, NOW()),

-- 早餐店菜单
(3, '火腿蛋吐司', 40, '吐司', '经典火腿蛋吐司', true, NOW()),
(3, '鲔鱼蛋吐司', 45, '吐司', '香浓鲔鱼蛋吐司', true, NOW()),
(3, '培根蛋吐司', 45, '吐司', '香脆培根蛋吐司', true, NOW()),
(3, '奶茶', 25, '饮料', '香浓奶茶', true, NOW()),
(3, '豆浆', 20, '饮料', '营养豆浆', true, NOW());

-- 验证数据
SELECT '用户数量' as 表名, COUNT(*) as 数量 FROM "Users"
UNION ALL
SELECT '店家数量', COUNT(*) FROM "Stores"
UNION ALL
SELECT '菜单项目数量', COUNT(*) FROM "MenuItems";
