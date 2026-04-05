USE L_DBII;
GO

-- Insert Users
INSERT INTO Users (Name, Email, PasswordHash, Department, Role) VALUES
(N'管理員', 'admin@company.com', '$2a$11$KIXXqGXQHzbKLpHPtx/hF.m7AGJQ8h8BN/Q7K6rM8K0gC0N0pG94W', N'管理部', 'Admin'),
(N'王小明', 'wang@company.com', '$2a$11$KIXXqGXQHzbKLpHPtx/hF.m7AGJQ8h8BN/Q7K6rM8K0gC0N0pG94W', N'業務部', 'User'),
(N'李小華', 'lee@company.com', '$2a$11$KIXXqGXQHzbKLpHPtx/hF.m7AGJQ8h8BN/Q7K6rM8K0gC0N0pG94W', N'研發部', 'User'),
(N'陳經理', 'chen@company.com', '$2a$11$KIXXqGXQHzbKLpHPtx/hF.m7AGJQ8h8BN/Q7K6rM8K0gC0N0pG94W', N'管理部', 'User'),
(N'林助理', 'lin@company.com', '$2a$11$KIXXqGXQHzbKLpHPtx/hF.m7AGJQ8h8BN/Q7K6rM8K0gC0N0pG94W', N'行政部', 'User');
GO

-- Insert Stores
INSERT INTO Stores (Name, Category, Phone, Address) VALUES
(N'50嵐', 'Drink', '02-1234-5678', N'台北市信義區xx路1號'),
(N'清心福全', 'Drink', '02-2345-6789', N'台北市大安區yy路2號'),
(N'池上便當', 'Lunch', '02-3456-7890', N'台北市中山區zz路3號'),
(N'悟饕便當', 'Lunch', '02-4567-8901', N'台北市松山區aa路4號');
GO

-- Insert MenuItems for 50嵐
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options) VALUES
(1, N'珍珠奶茶', N'奶茶類',
'{"type":"size","required":true,"options":[{"name":"中杯","code":"M","price":50,"isDefault":true},{"name":"大杯","code":"L","price":55},{"name":"瓶裝","code":"BTL","price":60}]}',
'{"sweetness":{"label":"甜度","required":true,"default":"少糖","options":["無糖","微糖","半糖","少糖","全糖"]},"temperature":{"label":"溫度","required":true,"default":"少冰","options":["去冰","微冰","少冰","正常冰","常溫","溫","熱"]},"toppings":{"label":"加料","required":false,"multiple":true,"maxSelect":3,"note":"最多可選 3 種","options":[{"name":"珍珠","code":"PEARL","price":10},{"name":"椰果","code":"JELLY","price":5},{"name":"布丁","code":"PUDDING","price":15},{"name":"蘆薈","code":"ALOE","price":10}]}}'),

(1, N'四季春茶', N'茶類',
'{"type":"size","required":true,"options":[{"name":"中杯","code":"M","price":25,"isDefault":true},{"name":"大杯","code":"L","price":30}]}',
'{"sweetness":{"label":"甜度","required":true,"default":"無糖","options":["無糖","微糖","半糖","少糖","全糖"]},"temperature":{"label":"溫度","required":true,"default":"正常冰","options":["去冰","微冰","少冰","正常冰","常溫","溫","熱"]},"toppings":{"label":"加料","required":false,"multiple":true,"maxSelect":2,"options":[{"name":"珍珠","code":"PEARL","price":10},{"name":"椰果","code":"JELLY","price":5}]}}'),

(1, N'波霸紅茶', N'茶類',
'{"type":"size","required":true,"options":[{"name":"中杯","code":"M","price":40,"isDefault":true},{"name":"大杯","code":"L","price":45}]}',
'{"sweetness":{"label":"甜度","required":true,"default":"少糖","options":["無糖","微糖","半糖","少糖","全糖"]},"temperature":{"label":"溫度","required":true,"default":"少冰","options":["去冰","微冰","少冰","正常冰","常溫","溫","熱"]}}'),

(1, N'冬瓜檸檬', N'特調類',
'{"type":"size","required":true,"options":[{"name":"中杯","code":"M","price":45,"isDefault":true},{"name":"大杯","code":"L","price":50}]}',
'{"sweetness":{"label":"甜度","required":true,"default":"半糖","options":["微糖","半糖","少糖","全糖"],"note":"此品項不提供無糖"},"temperature":{"label":"溫度","required":true,"default":"正常冰","options":["少冰","正常冰"],"note":"僅提供冷飲"}}');
GO

-- Insert MenuItems for 清心福全
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options) VALUES
(2, N'珍珠奶茶', N'奶茶類',
'{"type":"size","required":true,"options":[{"name":"中杯","code":"M","price":45,"isDefault":true},{"name":"大杯","code":"L","price":50}]}',
'{"sweetness":{"label":"甜度","required":true,"default":"少糖","options":["無糖","微糖","半糖","少糖","全糖"]},"temperature":{"label":"溫度","required":true,"default":"少冰","options":["去冰","微冰","少冰","正常冰","常溫","溫","熱"]},"toppings":{"label":"加料","required":false,"multiple":true,"maxSelect":2,"options":[{"name":"珍珠","code":"PEARL","price":10},{"name":"布丁","code":"PUDDING","price":15},{"name":"奶蓋","code":"CHEESE_FOAM","price":20}]}}'),

(2, N'檸檬青茶', N'茶類',
'{"type":"size","required":true,"options":[{"name":"中杯","code":"M","price":35,"isDefault":true},{"name":"大杯","code":"L","price":40}]}',
'{"sweetness":{"label":"甜度","required":true,"default":"微糖","options":["無糖","微糖","半糖","少糖","全糖"]},"temperature":{"label":"溫度","required":true,"default":"正常冰","options":["去冰","微冰","少冰","正常冰"]}}');
GO

-- Insert MenuItems for 池上便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options) VALUES
(3, N'排骨便當', N'主餐',
'{"type":"portion","required":true,"options":[{"name":"小份","code":"S","price":80,"isDefault":true},{"name":"大份","code":"L","price":90}]}',
NULL),

(3, N'雞腿便當', N'主餐',
'{"type":"portion","required":true,"options":[{"name":"小份","code":"S","price":85,"isDefault":true},{"name":"大份","code":"L","price":95}]}',
NULL),

(3, N'魚便當', N'主餐',
'{"type":"portion","required":true,"options":[{"name":"小份","code":"S","price":75,"isDefault":true},{"name":"大份","code":"L","price":85}]}',
NULL),

(3, N'素食便當', N'主餐',
'{"type":"portion","required":true,"options":[{"name":"小份","code":"S","price":70,"isDefault":true},{"name":"大份","code":"L","price":80}]}',
NULL);
GO

-- Insert MenuItems for 悟饕便當
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules, Options) VALUES
(4, N'控肉便當', N'主餐',
'{"type":"portion","required":true,"options":[{"name":"小份","code":"S","price":80,"isDefault":true},{"name":"大份","code":"L","price":90}]}',
NULL),

(4, N'炸雞腿便當', N'主餐',
'{"type":"portion","required":true,"options":[{"name":"小份","code":"S","price":85,"isDefault":true},{"name":"大份","code":"L","price":95}]}',
NULL),

(4, N'烤鯖魚便當', N'主餐',
'{"type":"portion","required":true,"options":[{"name":"小份","code":"S","price":90,"isDefault":true},{"name":"大份","code":"L","price":100}]}',
NULL);
GO

PRINT 'Test data inserted successfully!';
GO
