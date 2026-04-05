系統架構建議
Frontend (Web / LINE Bot)
        ↓
Backend API (ASP.NET Core / Node.js)
        ↓
Database (SQL Server / PostgreSQL)
        ↓
通知服務 (Email / LINE Notify / Teams Webhook)


Store（店家）
  ├─ StoreId, Name, Category（飲料/便當）, MenuUrl, DeadlineMinutes

MenuItem（菜單品項）
  ├─ ItemId, StoreId, Name, Price, Options（JSON: 甜度/冰塊）

OrderGroup（揪團）
  ├─ GroupId, InitiatorId, StoreId, Deadline, Status（Open/Closed/Delivered）
  ├─ 支援多筆 → 同場合可建多個 OrderGroup（多店同時），以 EventId 群組

OrderItem（個人訂單項目）
  ├─ ItemId, GroupId, UserId, MenuItem, Quantity, CustomOptions, SubTotal

User（成員）
  ├─ UserId, Name, Email, LineUserId, Department

功能模組拆解
1. 多店同時訂購
建立一個 Event（活動），下掛多個 OrderGroup（每店一組）
發起人選多個店家 → 系統同時開放各店訂單收集
截止時間可分別設定（例：飲料 12:00、便當 11:45）

2. 自動分帳
每人應付金額 = Σ(自己的 OrderItem.SubTotal)
可加上：服務費率、外送費（依人數平攤）
輸出：分帳明細表（人名 / 品項 / 小計 / 外送費分攤 / 合計）

3. 熱門品項統計
可篩選：本週 / 本月 / 特定店家
顯示：個人最愛、部門最愛、全公司排行榜

資料庫建立（SQL Schema + 種子資料）
後端 API（ASP.NET Core 專案結構）
前端 UI（React 頁面骨架）
分帳邏輯（計算模組）