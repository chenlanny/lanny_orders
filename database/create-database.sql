-- ============================================
-- 建立資料庫：L_DBII
-- 伺服器：192.168.207.52
-- ============================================

USE master;
GO

-- 檢查資料庫是否存在，如果存在則刪除（謹慎使用）
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'L_DBII')
BEGIN
    ALTER DATABASE L_DBII SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE L_DBII;
    PRINT '已刪除舊的 L_DBII 資料庫';
END
GO

-- 建立新資料庫
CREATE DATABASE L_DBII
ON PRIMARY 
(
    NAME = N'L_DBII_Data',
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\L_DBII.mdf',
    SIZE = 50MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10MB
)
LOG ON 
(
    NAME = N'L_DBII_Log',
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\L_DBII_log.ldf',
    SIZE = 10MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
);
GO

PRINT '資料庫 L_DBII 建立成功！';
GO

-- 設定資料庫選項
ALTER DATABASE L_DBII SET RECOVERY SIMPLE;
ALTER DATABASE L_DBII SET AUTO_SHRINK OFF;
ALTER DATABASE L_DBII SET AUTO_CREATE_STATISTICS ON;
ALTER DATABASE L_DBII SET AUTO_UPDATE_STATISTICS ON;
GO

-- 切換到新建立的資料庫
USE L_DBII;
GO

PRINT '已切換到 L_DBII 資料庫';
GO
