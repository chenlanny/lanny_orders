-- ============================================
-- 智慧辦公室訂餐系統 - 測試資料
-- 資料庫：L_DBII
-- ============================================

USE L_DBII;
GO

PRINT '開始插入測試資料...';
GO

-- ============================================
-- 1. 使用者資料（密碼都是 "password123" 的 BCrypt 雜湊）
-- ============================================
DELETE FROM Users;
DBCC CHECKIDENT ('Users', RESEED, 0);
GO

INSERT INTO Users (Name, Email, PasswordHash, Department, Role) VALUES
('管理員', 'admin@company.com', '$2a$11$KIXXqGXQHzbKLpHPtx/hF.m7AGJQ8h8BN/Q7K6rM8K0gC0N0pG94W', '管理部', 'Admin'),
('王小明', 'wang@company.com', '$2a$11$KIXXqGXQHzbKLpHPtx/hF.m7AGJQ8h8BN/Q7K6rM8K0gC0N0pG94W', '業務部', 'User'),
('李小華', 'lee@company.com', '$2a$11$KIXXqGXQHzbKLpHPtx/hF.m7AGJQ8h8BN/Q7K6rM8K0gC0N0pG94W', '研發部', 'User'),
('陳經理', 'chen@company.com', '$2a$11$KIXXqGXQHzbKLpHPtx/hF.m7AGJQ8h8BN/Q7K6rM8K0gC0N0pG94W', '管理部', 'User'),
('林助理', 'lin@company.com', '$2a$11$KIXXqGXQHzbKLpHPtx/hF.m7AGJQ8h8BN/Q7K6rM8K0gC0N0pG94W', '行政部', 'User');

PRINT '✓ 已插入 5 位使用者';
GO

-- ============================================
-- 2. 店家資料
-- ============================================
DELETE FROM Stores;
DBCC CHECKIDENT ('Stores', RESEED, 0);
GO

INSERT INTO Stores (Name, Category, Phone, Address) VALUES
('50嵐', 'Drink', '02-1234-5678', '台北市信義區xx路1號'),
('清心福全', 'Drink', '02-2345-6789', '台北市大安區yy路2號'),
('池上便當', 'Lunch', '02-3456-7890', '台北市中山區zz路3號'),
('悟饕便當', 'Lunch', '02-4567-8901', '台北市松山區aa路4號');

PRINT '✓ 已插入 4 家店家';
GO

-- ============================================
-- 3. 50嵐菜單（完整版 - 含尺寸、甜度、溫度、加料）
-- ============================================
DELETE FROM MenuItems WHERE StoreId = 1;
GO

INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options) VALUES
(1, '珍珠奶茶', '奶茶類',
'{
  "type": "size",
  "required": true,
  "options": [
    {"name": "中杯", "code": "M", "price": 50, "isDefault": true},
    {"name": "大杯", "code": "L", "price": 55},
    {"name": "瓶裝", "code": "BTL", "price": 60}
  ]
}',
'{
  "sweetness": {
    "label": "甜度",
    "required": true,
    "default": "少糖",
    "options": ["無糖", "微糖", "半糖", "少糖", "全糖"]
  },
  "temperature": {
    "label": "溫度",
    "required": true,
    "default": "少冰",
    "options": ["去冰", "微冰", "少冰", "正常冰", "常溫", "溫", "熱"]
  },
  "toppings": {
    "label": "加料",
    "required": false,
    "multiple": true,
    "maxSelect": 3,
    "note": "最多可選 3 種",
    "options": [
      {"name": "珍珠", "code": "PEARL", "price": 10},
      {"name": "椰果", "code": "JELLY", "price": 5},
      {"name": "布丁", "code": "PUDDING", "price": 15},
      {"name": "蘆薈", "code": "ALOE", "price": 10}
    ]
  }
}'),

(1, '四季春茶', '茶類',
'{
  "type": "size",
  "required": true,
  "options": [
    {"name": "中杯", "code": "M", "price": 25, "isDefault": true},
    {"name": "大杯", "code": "L", "price": 30}
  ]
}',
'{
  "sweetness": {
    "label": "甜度",
    "required": true,
    "default": "無糖",
    "options": ["無糖", "微糖", "半糖", "少糖", "全糖"]
  },
  "temperature": {
    "label": "溫度",
    "required": true,
    "default": "正常冰",
    "options": ["去冰", "微冰", "少冰", "正常冰", "常溫", "溫", "熱"]
  },
  "toppings": {
    "label": "加料",
    "required": false,
    "multiple": true,
    "maxSelect": 2,
    "options": [
      {"name": "珍珠", "code": "PEARL", "price": 10},
      {"name": "椰果", "code": "JELLY", "price": 5}
    ]
  }
}'),

(1, '波霸紅茶', '茶類',
'{
  "type": "size",
  "required": true,
  "options": [
    {"name": "中杯", "code": "M", "price": 40, "isDefault": true},
    {"name": "大杯", "code": "L", "price": 45}
  ]
}',
'{
  "sweetness": {
    "label": "甜度",
    "required": true,
    "default": "少糖",
    "options": ["無糖", "微糖", "半糖", "少糖", "全糖"]
  },
  "temperature": {
    "label": "溫度",
    "required": true,
    "default": "少冰",
    "options": ["去冰", "微冰", "少冰", "正常冰", "常溫", "溫", "熱"]
  }
}'),

(1, '冬瓜檸檬', '特調類',
'{
  "type": "size",
  "required": true,
  "options": [
    {"name": "中杯", "code": "M", "price": 45, "isDefault": true},
    {"name": "大杯", "code": "L", "price": 50}
  ]
}',
'{
  "sweetness": {
    "label": "甜度",
    "required": true,
    "default": "半糖",
    "options": ["微糖", "半糖", "少糖", "全糖"],
    "note": "此品項不提供無糖"
  },
  "temperature": {
    "label": "溫度",
    "required": true,
    "default": "正常冰",
    "options": ["少冰", "正常冰"],
    "note": "僅提供冷飲"
  }
}');

PRINT '✓ 已插入 50嵐菜單（4 項）';
GO

-- ============================================
-- 4. 清心福全菜單
-- ============================================
DELETE FROM MenuItems WHERE StoreId = 2;
GO

INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options) VALUES
(2, '珍珠奶茶', '奶茶類',
'{
  "type": "size",
  "required": true,
  "options": [
    {"name": "中杯", "code": "M", "price": 45, "isDefault": true},
    {"name": "大杯", "code": "L", "price": 50}
  ]
}',
'{
  "sweetness": {
    "label": "甜度",
    "required": true,
    "default": "少糖",
    "options": ["無糖", "微糖", "半糖", "少糖", "全糖"]
  },
  "temperature": {
    "label": "溫度",
    "required": true,
    "default": "少冰",
    "options": ["去冰", "微冰", "少冰", "正常冰", "常溫", "溫", "熱"]
  },
  "toppings": {
    "label": "加料",
    "required": false,
    "multiple": true,
    "maxSelect": 2,
    "options": [
      {"name": "珍珠", "code": "PEARL", "price": 10},
      {"name": "布丁", "code": "PUDDING", "price": 15},
      {"name": "奶蓋", "code": "CHEESE_FOAM", "price": 20}
    ]
  }
}'),

(2, '檸檬青茶', '茶類',
'{
  "type": "size",
  "required": true,
  "options": [
    {"name": "中杯", "code": "M", "price": 35, "isDefault": true},
    {"name": "大杯", "code": "L", "price": 40}
  ]
}',
'{
  "sweetness": {
    "label": "甜度",
    "required": true,
    "default": "微糖",
    "options": ["無糖", "微糖", "半糖", "少糖", "全糖"]
  },
  "temperature": {
    "label": "溫度",
    "required": true,
    "default": "正常冰",
    "options": ["去冰", "微冰", "少冰", "正常冰"]
  }
}');

PRINT '✓ 已插入清心福全菜單（2 項）';
GO

-- ============================================
-- 5. 池上便當菜單
-- ============================================
DELETE FROM MenuItems WHERE StoreId = 3;
GO

INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options) VALUES
(3, '排骨便當', '主餐',
'{
  "type": "portion",
  "required": true,
  "options": [
    {"name": "小份", "code": "S", "price": 80, "isDefault": true},
    {"name": "大份", "code": "L", "price": 90}
  ]
}',
NULL),

(3, '雞腿便當', '主餐',
'{
  "type": "portion",
  "required": true,
  "options": [
    {"name": "小份", "code": "S", "price": 85, "isDefault": true},
    {"name": "大份", "code": "L", "price": 95}
  ]
}',
NULL),

(3, '魚便當', '主餐',
'{
  "type": "portion",
  "required": true,
  "options": [
    {"name": "小份", "code": "S", "price": 75, "isDefault": true},
    {"name": "大份", "code": "L", "price": 85}
  ]
}',
NULL),

(3, '素食便當', '主餐',
'{
  "type": "portion",
  "required": true,
  "options": [
    {"name": "小份", "code": "S", "price": 70, "isDefault": true},
    {"name": "大份", "code": "L", "price": 80}
  ]
}',
NULL);

PRINT '✓ 已插入池上便當菜單（4 項）';
GO

-- ============================================
-- 6. 悟饕便當菜單
-- ============================================
DELETE FROM MenuItems WHERE StoreId = 4;
GO

INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options) VALUES
(4, '控肉便當', '主餐',
'{
  "type": "portion",
  "required": true,
  "options": [
    {"name": "小份", "code": "S", "price": 80, "isDefault": true},
    {"name": "大份", "code": "L", "price": 90}
  ]
}',
NULL),

(4, '炸雞腿便當', '主餐',
'{
  "type": "portion",
  "required": true,
  "options": [
    {"name": "小份", "code": "S", "price": 85, "isDefault": true},
    {"name": "大份", "code": "L", "price": 95}
  ]
}',
NULL),

(4, '烤鯖魚便當', '主餐',
'{
  "type": "portion",
  "required": true,
  "options": [
    {"name": "小份", "code": "S", "price": 90, "isDefault": true},
    {"name": "大份", "code": "L", "price": 100}
  ]
}',
NULL);

PRINT '✓ 已插入悟饕便當菜單（3 項）';
GO

-- ============================================
-- 統計資訊
-- ============================================
PRINT '';
PRINT '========================================';
PRINT '測試資料插入完成！';
PRINT '========================================';
PRINT '';

SELECT '使用者' AS [類別], COUNT(*) AS [數量] FROM Users
UNION ALL
SELECT '店家', COUNT(*) FROM Stores
UNION ALL
SELECT '菜單品項', COUNT(*) FROM MenuItems;

PRINT '';
PRINT '測試帳號：';
PRINT '  管理員：admin@company.com / password123';
PRINT '  一般使用者：wang@company.com / password123';
PRINT '';
PRINT '可以開始測試系統了！';
PRINT '========================================';
GO
