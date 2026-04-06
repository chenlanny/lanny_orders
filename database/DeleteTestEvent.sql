-- 刪除「午夜快閃團」測試資料
-- 執行方式：sqlcmd -S 192.168.207.52 -d L_DBII -E -i DeleteTestEvent.sql

-- 1. 先查詢要刪除的活動
SELECT EventId, Title, Status, CreatedAt 
FROM Events 
WHERE Title LIKE '%午夜%' OR Title LIKE '%快閃%';

-- 2. 如果確認要刪除，取消下面的注釋並執行

/*
-- 宣告變數
DECLARE @EventId INT;

-- 找到活動ID
SELECT @EventId = EventId 
FROM Events 
WHERE Title LIKE '%午夜%' OR Title LIKE '%快閃%';

-- 刪除相關訂單項目
DELETE FROM OrderItems 
WHERE GroupId IN (
    SELECT GroupId FROM OrderGroups WHERE EventId = @EventId
);

-- 刪除訂單群組
DELETE FROM OrderGroups WHERE EventId = @EventId;

-- 刪除活動
DELETE FROM Events WHERE EventId = @EventId;

-- 確認刪除結果
PRINT '已刪除活動ID: ' + CAST(@EventId AS VARCHAR(10));
*/
