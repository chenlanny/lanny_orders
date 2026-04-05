-- Update User Data
-- Date: 2026-04-03

USE L_DBII;
GO

-- Update existing users
-- User 1: Wang -> 1@company.com / 111
UPDATE Users 
SET Email = '1@company.com', 
    PasswordHash = '$2a$11$paJOoGzXvwK7oixwG1k7QudpoQbmmihrppGH2nW8Qc6gemIgtAeGq'
WHERE UserId = 1;
PRINT 'Updated User 1: 王小明 -> 1@company.com';

-- User 2: Lee -> 2@company.com / 222
UPDATE Users 
SET Email = '2@company.com', 
    PasswordHash = '$2a$11$iFZVGtKlBPbQGgZ3wry5beDzL9hM/ziOaabM4rZ6njnLG0hqL31Em'
WHERE UserId = 2;
PRINT 'Updated User 2: 李小華 -> 2@company.com';

-- User 3: Chen -> Hua, 3@company.com / 333
UPDATE Users 
SET Name = N'華經理',
    Email = '3@company.com', 
    PasswordHash = '$2a$11$DEXU9.eIqV4IwZU.aWonpuqsPDjkWPZHa2YsUMApb3agGKKD5JC5a'
WHERE UserId = 3;
PRINT 'Updated User 3: 華經理 -> 3@company.com';

-- Insert new users
-- User 4: EC -> 4@company.com / 444
IF NOT EXISTS (SELECT 1 FROM Users WHERE UserId = 4)
BEGIN
    SET IDENTITY_INSERT Users ON;
    INSERT INTO Users (UserId, Name, Email, PasswordHash, CreatedAt)
    VALUES (4, N'EC', '4@company.com', '$2a$11$pc1HroXK6eBnjAwKyNRz6u/wt60ZHMhMi31u4zyraQSFLNqXG9Rmi', GETUTCDATE());
    SET IDENTITY_INSERT Users OFF;
    PRINT 'Inserted User 4: EC -> 4@company.com (new)';
END
ELSE
BEGIN
    UPDATE Users 
    SET Name = N'EC',
        Email = '4@company.com', 
        PasswordHash = '$2a$11$pc1HroXK6eBnjAwKyNRz6u/wt60ZHMhMi31u4zyraQSFLNqXG9Rmi'
    WHERE UserId = 4;
    PRINT 'Updated User 4: EC -> 4@company.com (existing)';
END

-- User 6: Lin -> 5@company.com / 555 (UserId=6 because 5 is admin)
IF NOT EXISTS (SELECT 1 FROM Users WHERE UserId = 6)
BEGIN
    SET IDENTITY_INSERT Users ON;
    INSERT INTO Users (UserId, Name, Email, PasswordHash, CreatedAt)
    VALUES (6, N'林小姐', '5@company.com', '$2a$11$WR3J4iBYTencN.cEPLjeru1dGOwomWL44JPb7pgdDVpnY/Cdl0s4a', GETUTCDATE());
    SET IDENTITY_INSERT Users OFF;
    PRINT 'Inserted User 6: 林小姐 -> 5@company.com (new)';
END
ELSE
BEGIN
    UPDATE Users 
    SET Name = N'林小姐',
        Email = '5@company.com', 
        PasswordHash = '$2a$11$WR3J4iBYTencN.cEPLjeru1dGOwomWL44JPb7pgdDVpnY/Cdl0s4a'
    WHERE UserId = 6;
    PRINT 'Updated User 6: 林小姐 -> 5@company.com (existing)';
END
GO

-- Verify results
SELECT UserId, Name, Email, CreatedAt
FROM Users
WHERE UserId IN (1, 2, 3, 4, 5, 6)
ORDER BY UserId;
GO
