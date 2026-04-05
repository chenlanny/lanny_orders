USE L_DBII;
GO

INSERT INTO MenuItems (StoreId, Name, Category, PriceRules) VALUES
(1, N'珍珠奶茶', N'奶茶類', '{"type":"size","required":true,"options":[{"name":"中杯","code":"M","price":50},{"name":"大杯","code":"L","price":55}]}'),
(1, N'四季春茶', N'茶類', '{"type":"size","required":true,"options":[{"name":"中杯","code":"M","price":25},{"name":"大杯","code":"L","price":30}]}'),
(1, N'波霸紅茶', N'茶類', '{"type":"size","required":true,"options":[{"name":"中杯","code":"M","price":40},{"name":"大杯","code":"L","price":45}]}'),
(2, N'珍珠奶茶', N'奶茶類', '{"type":"size","required":true,"options":[{"name":"中杯","code":"M","price":45},{"name":"大杯","code":"L","price":50}]}'),
(2, N'檸檬青茶', N'茶類', '{"type":"size","required":true,"options":[{"name":"中杯","code":"M","price":35},{"name":"大杯","code":"L","price":40}]}'),
(3, N'排骨便當', N'主餐', '{"type":"portion","required":true,"options":[{"name":"小份","code":"S","price":80},{"name":"大份","code":"L","price":90}]}'),
(3, N'雞腿便當', N'主餐', '{"type":"portion","required":true,"options":[{"name":"小份","code":"S","price":85},{"name":"大份","code":"L","price":95}]}'),
(3, N'魚便當', N'主餐', '{"type":"portion","required":true,"options":[{"name":"小份","code":"S","price":75},{"name":"大份","code":"L","price":85}]}'),
(4, N'控肉便當', N'主餐', '{"type":"portion","required":true,"options":[{"name":"小份","code":"S","price":80},{"name":"大份","code":"L","price":90}]}'),
(4, N'炸雞腿便當', N'主餐', '{"type":"portion","required":true,"options":[{"name":"小份","code":"S","price":85},{"name":"大份","code":"L","price":95}]}');
GO
