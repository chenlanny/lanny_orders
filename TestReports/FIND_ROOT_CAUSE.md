# 後端 500 錯誤診斷

**Logs 記錄**:
```
[08:45:29 ERR] HTTP POST /api/auth/login responded 500 in 235.2535 ms
```

這表示登入請求失敗，需要查看具體的異常訊息。

---

## 🔍 查找詳細錯誤的步驟

### 在 Render.com Logs 中查找：

1. **查找 Exception 或 Error 堆棧**
   - 向上或向下滾動查看相關的異常訊息
   - 尋找包含以下關鍵字的行：
     ```
     Exception
     error:
     fail:
     Unhandled
     ```

2. **尋找時間戳接近 08:45:29 的日誌**
   - 可能在登入 API 日誌前後幾秒內有詳細的異常信息

3. **常見的錯誤訊息（請檢查是否存在）**：

   **(a) 資料庫連接失敗**:
   ```
   Exception: Npgsql.NpgsqlException
   Could not translate... could not connect to database
   failed to connect
   ```

   **原因**: ConnectionStrings 配置錯誤或 Supabase 不可達

   **修復**:
   ```
   檢查 Render.com Environment：
   ConnectionStrings__DefaultConnection 
   = Host=db.idyfbtswixhfahddnlkw.supabase.co;Port=5432;...
   ```

   ---

   **(b) DbContext 初始化失敗**:
   ```
   Exception: InvalidOperationException
   No database provider has been configured
   ```

   **原因**: appsettings.json 或 Startup.cs 配置問題

   ---

   **(c) JWT 或認證問題**:
   ```
   Exception: ArgumentNullException
   Parameter name: key
   ```

   **原因**: Jwt__Key 環境變數未設定

   **修復**:
   ```
   檢查 Render.com Environment：
   Jwt__Key = YourSuperSecretKeyForJwtTokenGeneration2026!MustBeLongEnough
   ```

---

## 📋 立即查找

**在 Render Dashboard Logs 中查找並告訴我：**

1. **精確的異常類型** (e.g., `NpgsqlException`, `InvalidOperationException`)
2. **完整的錯誤訊息** (e.g., "failed to connect", "Parameter name: xyz")
3. **堆棧跟蹤的前 3-5 行**

---

## 🎯 我需要的信息

請複製並粘貼 Logs 中，在 `[08:45:29 ERR]` 前後出現的**完整異常訊息**。

通常會是這樣的格式：
```
[時間] Exception: ExceptionType
Message: 具體錯誤訊息
at ClassName.MethodName() in FileName.cs:line XXX
...
```

---

**複製 Logs 中的異常訊息並告訴我，我會立即修復！**
