-- 刪除測試活動：午夜快閃 (EventId=5)
-- 保留：快閃團 (EventId=6)

USE L_DBII;
GO

-- 刪除 EventId=5 的資料
PRINT '正在刪除活動: 午夜快閃 (EventId=5)';

-- 刪除訂單項目
DELETE FROM OrderItems 
WHERE GroupId IN (SELECT GroupId FROM OrderGroups WHERE EventId = 5);
PRINT '  - 已刪除訂單項目';

-- 刪除訂單群組
DELETE FROM OrderGroups WHERE EventId = 5;
PRINT '  - 已刪除訂單群組';

-- 刪除活動
DELETE FROM Events WHERE EventId = 5;
PRINT '  - 已刪除活動';

PRINT '';
PRINT '完成！EventId=5（午夜快閃）已刪除。';
PRINT 'EventId=6（快閃團）已保留。';
GO
