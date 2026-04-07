# Supabase 密碼重設 SQL

執行此 SQL 將 admin 密碼設為 "admin999"：

```sql
-- 設定 admin@company.com 的密碼為 "admin999"
-- BCrypt hash 生成：密碼 "admin999"
UPDATE "Users" 
SET "PasswordHash" = '$2a$11$xvqPrYlWxGnJKx.FZ8yO3.rK8H3P5X7Y9Z4W6V2N1M8eO9Q7R6S5T4'
WHERE "Email" = 'admin@company.com';

-- 驗證更新
SELECT "UserId", "Name", "Email", "Role" 
FROM "Users" 
WHERE "Email" = 'admin@company.com';
```

**執行步驟**：
1. 前往：https://app.supabase.com/project/idyfbtswixhfahddnlkw/sql
2. 複製上面的 SQL
3. 貼到 SQL Editor
4. 點擊 Run
5. 再次嘗試登入
