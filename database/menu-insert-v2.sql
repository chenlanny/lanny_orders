USE L_DBII
GO
DECLARE @json1 NVARCHAR(MAX) = '{"type":"size","required":true,"options":[{"name":"中杯","code":"M","price":50},{"name":"大杯","code":"L","price":55}]}'
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules) VALUES (1, N'珍珠奶茶', N'奶茶類', @json1)
GO
DECLARE @json2 NVARCHAR(MAX) = '{"type":"size","required":true,"options":[{"name":"中杯","code":"M","price":25},{"name":"大杯","code":"L","price":30}]}'
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules) VALUES (1, N'四季春茶', N'茶類', @json2)
GO
DECLARE @json3 NVARCHAR(MAX) = '{"type":"size","required":true,"options":[{"name":"中杯","code":"M","price":40},{"name":"大杯","code":"L","price":45}]}'
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules) VALUES (1, N'波霸紅茶', N'茶類', @json3)
GO
DECLARE @json4 NVARCHAR(MAX) = '{"type":"size","required":true,"options":[{"name":"中杯","code":"M","price":45},{"name":"大杯","code":"L","price":50}]}'
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules) VALUES (2, N'珍珠奶茶', N'奶茶類', @json4)
GO
DECLARE @json5 NVARCHAR(MAX) = '{"type":"portion","required":true,"options":[{"name":"小份","code":"S","price":80},{"name":"大份","code":"L","price":90}]}'
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules) VALUES (3, N'排骨便當', N'主餐', @json5)
GO
DECLARE @json6 NVARCHAR(MAX) = '{"type":"portion","required":true,"options":[{"name":"小份","code":"S","price":85},{"name":"大份","code":"L","price":95}]}'
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules) VALUES (3, N'雞腿便當', N'主餐', @json6)
GO
DECLARE @json7 NVARCHAR(MAX) = '{"type":"portion","required":true,"options":[{"name":"小份","code":"S","price":80},{"name":"大份","code":"L","price":90}]}'
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules) VALUES (4, N'控肉便當', N'主餐', @json7)
GO
DECLARE @json8 NVARCHAR(MAX) = '{"type":"portion","required":true,"options":[{"name":"小份","code":"S","price":85},{"name":"大份","code":"L","price":95}]}'
INSERT INTO MenuItems (StoreId, Name, Category, PriceRules) VALUES (4, N'炸雞腿便當', N'主餐', @json8)
GO
SELECT COUNT(*) AS MenuItemCount FROM MenuItems
GO
