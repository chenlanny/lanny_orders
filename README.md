# 智慧辦公室飲料/便當訂購系統 - 完整規劃文件

> 解決公司內部揪團痛點，自動計算金額與提醒  
> **版本：** 2.0  
> **更新日期：** 2026-04-03  
> **語言：** 繁體中文（UTF-8）

---

## � 專案目錄結構

```
A_order/
├── database/           # 後端 API (.NET Core 3.1)
├── frontend/          # 前端 UI (React 18 + Vite)
├── TestEvents/        # 測試事件數據與腳本
│   ├── *.json         # 測試用JSON數據
│   ├── *.ps1          # PowerShell測試腳本
│   └── README.md      # 測試說明文檔
├── TestReports/       # 測試報告與技術文檔
│   ├── 便當菜單新增報告.md
│   ├── 截止時間顯示測試說明.md
│   ├── 繁體中文測試報告.md
│   └── 繁體中文編碼說明.md
├── Aboutme.md         # 專案簡介
└── README.md          # 本文件（完整規劃文件）
```

---

## �📋 目錄

- [專案概述](#專案概述)
- [核心功能](#核心功能)
- [系統架構](#系統架構)
- [資料庫設計](#資料庫設計)
- [API 設計](#api-設計)
- [前端設計](#前端設計)
- [飲料訂單完整流程](#飲料訂單完整流程)
- [便當訂單設計](#便當訂單設計)
- [分帳邏輯](#分帳邏輯)
- [開發指南](#開發指南)
- [繁體中文編碼說明](#繁體中文編碼說明)

---

## 🎯 專案概述

### 解決的痛點

| 問題 | 現況 | 解決方案 |
|------|------|----------|
| 揪團訊息刷頻 | 群組被訂單訊息洗版 | 系統集中收單 |
| 手動計算金額 | 算錢算到頭痛 | 自動分帳 + 外送費平攤 |
| 容易忘記點餐 | 截止才發現沒點 | 自動提醒（規劃中）|
| 不知道點什麼 | 每次都要問 | 熱門品項統計 |
| 多店分開處理 | 一次揪多家店很麻煩 | 多店同時訂購 |
| 飲料選項複雜 | 尺寸/甜度/溫度/加料難整理 | 結構化選項系統 |

### 系統特色

✨ **多店同時訂購** - 一次活動可包含飲料店 + 便當店  
✨ **彈性定價** - 支援尺寸定價（大/中杯、大/小份）  
✨ **完整客製化** - 甜度、溫度、加料分開設定  
✨ **自動分帳** - 智慧計算每人應付金額  
✨ **熱門統計** - 個人/部門/全公司排行榜

---

## ✨ 核心功能

### 1. 多店同時訂購

```
Event（揪團活動）
  ├── OrderGroup（50嵐）       截止 14:00，外送費 $30
  ├── OrderGroup（清心）       截止 14:00，外送費 $0  
  └── OrderGroup（池上便當）   截止 11:30，外送費 $50
```

**特點：**
- 一次發起可選多個店家
- 每店獨立設定截止時間和外送費
- 使用者可同時點飲料和便當
- 統一管理與檢視

### 2. 彈性定價系統

#### 飲料尺寸定價
```
珍珠奶茶
  ├─ 中杯 $50
  ├─ 大杯 $55
  └─ 瓶裝 $60
```

#### 便當份量定價
```
排骨便當
  ├─ 小份 $80
  └─ 大份 $90
```

### 3. 完整客製化選項

#### 飲料選項（7 項參數）
- **尺寸**：中杯 / 大杯 / 瓶裝
- **甜度**：無糖 / 微糖 / 半糖 / 少糖 / 全糖
- **溫度**：去冰 / 微冰 / 少冰 / 正常冰 / 常溫 / 溫 / 熱
- **加料**：珍珠 / 椰果 / 布丁 / 仙草 / 蘆薈 / 奶蓋（可多選，最多 3 種）
- **數量**：1-99
- **備註**：自由文字

### 4. 自動分帳

**計算公式：**
```
個人應付 = Σ(品項小計 + 加料費) + Σ(外送費分攤)

品項小計 = (基礎價格 + 加料總價) × 數量
外送費分攤 = CEILING(店家外送費 ÷ 該店訂餐人數)
```

**輸出內容：**
- 個人明細表（品項、客製化、金額）
- 店家匯總表
- Excel 匯出功能

---

## 🏗️ 系統架構

```
┌─────────────────────┐
│   Browser (React)   │
│   - 飲料訂單介面     │
│   - 便當訂單介面     │
│   - 分帳明細頁       │
└──────────┬──────────┘
           │ HTTPS / REST API
           ↓
┌─────────────────────────┐
│  ASP.NET Core 8 Web API │
│  ┌────────────────────┐ │
│  │ Controllers        │ │
│  │ Services (業務邏輯)│ │
│  │ Repositories       │ │
│  └────────┬───────────┘ │
└───────────┼─────────────┘
            │ EF Core
            ↓
┌─────────────────────────┐
│    SQL Server 2022      │
│  - Users                │
│  - Stores / MenuItems   │
│  - Events / OrderGroups │
│  - OrderItems           │
└─────────────────────────┘
```

---

## 💾 資料庫設計

### ER Diagram

```
Users (使用者)
  ├── OrderItems ─┐
  └── Events      │
                  │
Events (揪團)     │
  └── OrderGroups (各店訂單群組)
        ├── Stores (店家)
        └── OrderItems (訂單項目) ←┘
              └── MenuItems (菜單品項)
```

### 核心資料表結構

#### Users（使用者）
```sql
CREATE TABLE Users (
    UserId          INT PRIMARY KEY IDENTITY(1,1),
    Name            NVARCHAR(50) NOT NULL,
    Email           NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(255) NOT NULL,
    Department      NVARCHAR(50),
    Role            NVARCHAR(20) DEFAULT 'User',  -- Admin / User
    IsActive        BIT DEFAULT 1,
    CreatedAt       DATETIME DEFAULT GETDATE(),
    LastLoginAt     DATETIME NULL
);
```

#### Stores（店家）
```sql
CREATE TABLE Stores (
    StoreId         INT PRIMARY KEY IDENTITY(1,1),
    Name            NVARCHAR(100) NOT NULL,
    Category        NVARCHAR(20) NOT NULL,  -- Drink / Lunch / Snack
    Phone           NVARCHAR(20),
    Address         NVARCHAR(200),
    MenuUrl         NVARCHAR(500),
    IsActive        BIT DEFAULT 1,
    CreatedAt       DATETIME DEFAULT GETDATE()
);
```

#### MenuItems（菜單品項 - 支援尺寸定價）
```sql
CREATE TABLE MenuItems (
    ItemId          INT PRIMARY KEY IDENTITY(1,1),
    StoreId         INT NOT NULL,
    Name            NVARCHAR(100) NOT NULL,
    Category        NVARCHAR(50),
    
    -- 定價規則（JSON: 尺寸/份量定價）
    PriceRules      NVARCHAR(MAX) NOT NULL,
    -- 範例：{"type":"size","required":true,"options":[{"name":"大杯","code":"L","price":55}]}
    
    -- 客製化選項（JSON: 甜度/溫度/加料）
    Options         NVARCHAR(MAX),
    -- 範例：{"sweetness":{...},"temperature":{...},"toppings":{...}}
    
    ImageUrl        NVARCHAR(500),
    IsAvailable     BIT DEFAULT 1,
    CreatedAt       DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_MenuItems_Store FOREIGN KEY (StoreId) 
        REFERENCES Stores(StoreId) ON DELETE CASCADE
);
```

#### Events（揪團活動）
```sql
CREATE TABLE Events (
    EventId         INT PRIMARY KEY IDENTITY(1,1),
    Title           NVARCHAR(100) NOT NULL,
    InitiatorId     INT NOT NULL,
    Status          NVARCHAR(20) DEFAULT 'Open',  -- Open / Closed / Delivered / Cancelled
    CreatedAt       DATETIME DEFAULT GETDATE(),
    ClosedAt        DATETIME NULL,
    DeliveredAt     DATETIME NULL,
    Notes           NVARCHAR(500),
    
    CONSTRAINT FK_Events_Initiator FOREIGN KEY (InitiatorId) 
        REFERENCES Users(UserId)
);
```

#### OrderGroups（各店訂單群組）
```sql
CREATE TABLE OrderGroups (
    GroupId         INT PRIMARY KEY IDENTITY(1,1),
    EventId         INT NOT NULL,
    StoreId         INT NOT NULL,
    Deadline        DATETIME NOT NULL,
    DeliveryFee     DECIMAL(8,1) DEFAULT 0,
    Status          NVARCHAR(20) DEFAULT 'Open',
    CreatedAt       DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_OrderGroups_Event FOREIGN KEY (EventId) 
        REFERENCES Events(EventId) ON DELETE CASCADE,
    CONSTRAINT FK_OrderGroups_Store FOREIGN KEY (StoreId) 
        REFERENCES Stores(StoreId)
);
```

#### OrderItems（訂單項目 - 支援尺寸、加料）
```sql
CREATE TABLE OrderItems (
    OrderItemId     INT PRIMARY KEY IDENTITY(1,1),
    GroupId         INT NOT NULL,
    UserId          INT NOT NULL,
    ItemId          INT NOT NULL,
    
    -- 尺寸/規格選擇
    SizeCode        NVARCHAR(20) NOT NULL,     -- "M", "L", "S" 等
    SizeName        NVARCHAR(50) NOT NULL,     -- "大杯", "小份" 等
    
    Quantity        INT DEFAULT 1,
    
    -- 客製化選項（甜度、溫度）
    CustomOptions   NVARCHAR(200),             -- "少糖,去冰"
    
    -- 加料選項（JSON 陣列）
    Toppings        NVARCHAR(500),
    -- 範例：[{"code":"PEARL","name":"珍珠","price":10}]
    
    Note            NVARCHAR(200),
    
    -- 價格明細
    BasePrice       DECIMAL(8,1) NOT NULL,     -- 該尺寸的基礎價格
    ToppingPrice    DECIMAL(8,1) DEFAULT 0,    -- 加料總價
    UnitPrice       DECIMAL(8,1) NOT NULL,     -- BasePrice + ToppingPrice
    SubTotal        DECIMAL(8,1) NOT NULL,     -- UnitPrice × Quantity
    
    CreatedAt       DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_OrderItems_Group FOREIGN KEY (GroupId) 
        REFERENCES OrderGroups(GroupId) ON DELETE CASCADE,
    CONSTRAINT FK_OrderItems_User FOREIGN KEY (UserId) 
        REFERENCES Users(UserId),
    CONSTRAINT FK_OrderItems_Item FOREIGN KEY (ItemId) 
        REFERENCES MenuItems(ItemId)
);
```

### JSON 格式範例

#### PriceRules（飲料 - 尺寸定價）
```json
{
  "type": "size",
  "required": true,
  "options": [
    {"name": "中杯", "code": "M", "price": 50, "isDefault": true},
    {"name": "大杯", "code": "L", "price": 55},
    {"name": "瓶裝", "code": "BTL", "price": 60}
  ]
}
```

#### PriceRules（便當 - 份量定價）
```json
{
  "type": "portion",
  "required": true,
  "options": [
    {"name": "小份", "code": "S", "price": 80, "isDefault": true},
    {"name": "大份", "code": "L", "price": 90}
  ]
}
```

#### Options（完整客製化選項）
```json
{
  "sweetness": {
    "label": "甜度",
    "required": true,
    "default": "少糖",
    "options": ["無糖", "微糖", "半糖", "少糖", "全糖"]
  },
  "temperature": {
    "label": "溫度",
    "required": true,
    "default": "少冰",
    "options": ["去冰", "微冰", "少冰", "正常冰", "常溫", "溫", "熱"]
  },
  "toppings": {
    "label": "加料",
    "required": false,
    "multiple": true,
    "maxSelect": 3,
    "note": "最多可選 3 種",
    "options": [
      {"name": "珍珠", "code": "PEARL", "price": 10},
      {"name": "椰果", "code": "JELLY", "price": 5},
      {"name": "布丁", "code": "PUDDING", "price": 15},
      {"name": "蘆薈", "code": "ALOE", "price": 10}
    ]
  }
}
```

### 完整建表腳本

請參考：[database/schema.sql](./database/schema.sql)

---

## 🔌 API 設計

### Base URL
```
Development: https://localhost:5001/api
Production: https://api.yourcompany.com/api
```

### 端點總覽

```
🔐 認證
POST   /auth/login                     登入
POST   /auth/register                  註冊
GET    /auth/me                        取得當前用戶資訊

🏪 店家管理
GET    /stores                         取得所有店家
GET    /stores/{id}                    店家詳情
GET    /stores/{id}/menu               店家菜單（含定價規則）
POST   /stores                         新增店家 [Admin]
PUT    /stores/{id}                    更新店家 [Admin]

📦 菜單品項
POST   /stores/{storeId}/menu          新增品項 [Admin]
PUT    /menu-items/{id}                更新品項 [Admin]
DELETE /menu-items/{id}                刪除品項 [Admin]

🎉 揪團管理
GET    /events                         揪團列表
GET    /events/{id}                    揪團詳情
POST   /events                         發起揪團
POST   /events/{id}/close              結單
DELETE /events/{id}                    取消揪團

🛒 訂單管理
GET    /events/{eventId}/orders        取得所有訂單
GET    /events/{eventId}/my-orders     我的訂單
POST   /events/{eventId}/orders        提交訂單
PUT    /orders/{id}                    修改訂單
DELETE /orders/{id}                    取消訂單

💰 分帳統計
GET    /events/{id}/summary            分帳明細
GET    /events/{id}/summary/export     匯出 Excel
GET    /stats/popular                  熱門品項
GET    /stats/personal                 個人統計
```

### 重要請求範例

#### POST /api/events - 發起揪團
```json
{
  "title": "下午茶 + 午餐揪團",
  "orderGroups": [
    {
      "storeId": 1,
      "deadline": "2026-04-03T14:00:00",
      "deliveryFee": 30
    },
    {
      "storeId": 3,
      "deadline": "2026-04-03T11:30:00",
      "deliveryFee": 50
    }
  ],
  "notes": "記得帶環保杯"
}
```

#### POST /api/events/{eventId}/orders - 提交訂單
```json
{
  "groupId": 1,
  "items": [
    {
      "itemId": 5,
      "sizeCode": "L",
      "quantity": 1,
      "customOptions": "少糖,去冰",
      "toppings": [
        {
          "code": "PEARL",
          "name": "珍珠",
          "price": 10
        }
      ],
      "note": ""
    }
  ]
}
```

---

## 🎨 前端設計

### 頁面架構

```
/
├── /login                    登入頁
├── /dashboard                首頁（進行中的揪團）
├── /events/new               發起揪團
├── /events/:id               揪團詳情 & 點餐
├── /events/:id/summary       分帳明細
├── /history                  歷史訂單
├── /stats                    統計分析
└── /admin                    管理後台
    ├── /admin/stores         店家管理
    └── /admin/menu           菜單管理
```

### 核心元件

```
src/
├── components/
│   ├── Layout/
│   │   ├── Header.jsx
│   │   └── Sidebar.jsx
│   ├── Event/
│   │   ├── EventCard.jsx
│   │   ├── CreateEventForm.jsx
│   │   └── EventDetail.jsx
│   ├── Drink/
│   │   ├── DrinkItemCard.jsx
│   │   ├── SizeSelector.jsx
│   │   ├── SweetnessSelector.jsx
│   │   ├── TemperatureSelector.jsx
│   │   └── ToppingSelector.jsx
│   ├── Lunch/
│   │   └── LunchItemCard.jsx
│   ├── Order/
│   │   ├── ShoppingCart.jsx
│   │   └── CartItem.jsx
│   └── Summary/
│       ├── SummaryTable.jsx
│       └── UserSummaryCard.jsx
├── pages/
│   ├── Dashboard.jsx
│   ├── EventDetail.jsx
│   ├── CreateEvent.jsx
│   └── Summary.jsx
├── services/
│   ├── api.js
│   ├── authService.js
│   └── eventService.js
└── App.jsx
```

---

## 🥤 飲料訂單完整流程

### UI 設計（完整版）

```
┌────────────────────────────────────────────────┐
│  珍珠奶茶                              [圖片]   │
├────────────────────────────────────────────────┤
│  尺寸：※必選                                    │
│  ┌──────┐ ┌──────┐ ┌──────┐                 │
│  │◉ 中杯 │ │○ 大杯 │ │○ 瓶裝 │                 │
│  │ $50  │ │ $55  │ │ $60  │                 │
│  └──────┘ └──────┘ └──────┘                 │
│                                                │
│  甜度：※必選                                    │
│  ┌─────┐┌─────┐┌─────┐┌─────┐┌─────┐      │
│  │ 無糖 ││ 微糖 ││ 半糖 ││◉少糖││ 全糖 │      │
│  └─────┘└─────┘└─────┘└─────┘└─────┘      │
│                                                │
│  溫度：※必選                                    │
│  冷飲：                                         │
│  ┌─────┐┌─────┐┌─────┐┌───────┐           │
│  │ 去冰 ││ 微冰 ││◉少冰││ 正常冰 │           │
│  └─────┘└─────┘└─────┘└───────┘           │
│  其他：                                         │
│  ┌─────┐┌─────┐┌─────┐                    │
│  │ 常溫 ││  溫  ││  熱  │                    │
│  └─────┘└─────┘└─────┘                    │
│                                                │
│  加料：（可選，最多 3 種）                      │
│  ┌─────────┐┌─────────┐┌─────────┐       │
│  │☑ 珍珠    ││☐ 椰果    ││☐ 布丁    │       │
│  │  +$10    ││  +$5     ││  +$15    │       │
│  └─────────┘└─────────┘└─────────┘       │
│  ┌─────────┐                                 │
│  │☐ 蘆薈    │                                 │
│  │  +$10    │                                 │
│  └─────────┘                                 │
│                                                │
│  備註：                                         │
│  ┌──────────────────────────────────┐       │
│  │ _____________________________      │       │
│  └──────────────────────────────────┘       │
│                                                │
│  數量：[－] 1 [＋]                             │
│                                                │
│  ┌──────────────────────────────────┐       │
│  │ 基礎價格：$50                      │       │
│  │ 加料費用：+$10 (珍珠)              │       │
│  │ 單價合計：$60                      │       │
│  └──────────────────────────────────┘       │
│                                                │
│         [取消]      [加入購物車 $60]          │
└────────────────────────────────────────────────┘
```

### 購物車顯示

```
┌────────────────────────────────────────┐
│  🛒 我的購物車                          │
├────────────────────────────────────────┤
│  50嵐                                  │
│  ┌────────────────────────────┐       │
│  │ 珍珠奶茶 (大杯)       $65   │  [×] │
│  │ 少糖,去冰 × 1               │       │
│  │ 加料：珍珠 (+$10)           │       │
│  └────────────────────────────┘       │
│                                        │
│  池上便當                              │
│  ┌────────────────────────────┐       │
│  │ 排骨便當 (小份)       $80   │  [×] │
│  │ × 1                         │       │
│  └────────────────────────────┘       │
├────────────────────────────────────────┤
│  小計：$145                            │
│           [清空]      [確認送出]       │
└────────────────────────────────────────┘
```

---

## 🍱 便當訂單設計

### UI 設計

```
┌────────────────────────────────────────┐
│  排骨便當                      [圖片]   │
├────────────────────────────────────────┤
│  份量：※必選                            │
│  ┌──────┐ ┌──────┐                   │
│  │◉ 小份 │ │○ 大份 │                   │
│  │ $80  │ │ $90  │                   │
│  └──────┘ └──────┘                   │
│                                        │
│  備註：                                 │
│  ┌──────────────────────────┐       │
│  │ 例：不要辣椒               │       │
│  └──────────────────────────┘       │
│                                        │
│  數量：[－] 1 [＋]                     │
│                                        │
│         [取消]  [加入購物車 $80]       │
└────────────────────────────────────────┘
```

---

## 💰 分帳邏輯

### 計算公式

```javascript
// 1. 品項小計
itemSubTotal = (basePrice + toppingPrice) × quantity

// 2. 個人品項總額
userItemTotal = Σ(itemSubTotal for all user's items)

// 3. 店家訂餐人數
storeParticipantCount = COUNT(DISTINCT userId WHERE groupId = X)

// 4. 個人外送費分攤（無條件進位）
userDeliveryFeeShare = CEILING(deliveryFee ÷ storeParticipantCount)

// 5. 個人應繳金額
userTotalDue = userItemTotal + Σ(userDeliveryFeeShare for all stores)
```

### 計算範例

**情境：**
- 王小明在 50嵐 點了：
  - 珍珠奶茶(大杯) $55
  - 加料：珍珠 $10
  - 小計：$65
- 50嵐外送費 $30，共 3 人訂購 → 每人分攤 $10
- 王小明在池上便當點了：
  - 排骨便當(小份) $80
- 池上便當無外送費

**計算過程：**
```
50嵐品項總額 = $65
50嵐外送費分攤 = CEILING($30 ÷ 3) = $10
50嵐小計 = $65 + $10 = $75

池上便當品項總額 = $80
池上便當外送費分攤 = $0
池上便當小計 = $80

王小明應付總額 = $75 + $80 = $155
```

### 分帳明細 JSON 範例

```json
{
  "eventId": 1,
  "title": "下午茶 + 午餐揪團",
  "status": "Closed",
  "createdAt": "2026-04-03T09:00:00",
  "closedAt": "2026-04-03T14:05:00",
  "storeSummaries": [
    {
      "groupId": 1,
      "storeName": "50嵐",
      "storeCategory": "Drink",
      "deliveryFee": 30,
      "participantCount": 3,
      "userSummaries": [
        {
          "userId": 1,
          "userName": "王小明",
          "department": "業務部",
          "items": [
            {
              "itemName": "珍珠奶茶",
              "sizeName": "大杯",
              "customOptions": "少糖,去冰",
              "toppings": [
                {"name": "珍珠", "price": 10}
              ],
              "quantity": 1,
              "basePrice": 55,
              "toppingPrice": 10,
              "unitPrice": 65,
              "subTotal": 65
            }
          ],
          "itemTotal": 65,
          "deliveryFeeShare": 10,
          "totalDue": 75
        }
      ],
      "subTotal": 195,
      "total": 225
    },
    {
      "groupId": 2,
      "storeName": "池上便當",
      "storeCategory": "Lunch",
      "deliveryFee": 0,
      "participantCount": 1,
      "userSummaries": [
        {
          "userId": 1,
          "userName": "王小明",
          "department": "業務部",
          "items": [
            {
              "itemName": "排骨便當",
              "sizeName": "小份",
              "quantity": 1,
              "basePrice": 80,
              "toppingPrice": 0,
              "unitPrice": 80,
              "subTotal": 80
            }
          ],
          "itemTotal": 80,
          "deliveryFeeShare": 0,
          "totalDue": 80
        }
      ],
      "subTotal": 80,
      "total": 80
    }
  ],
  "userTotals": [
    {
      "userId": 1,
      "userName": "王小明",
      "department": "業務部",
      "itemTotal": 145,
      "deliveryFeeTotal": 10,
      "totalDue": 155
    }
  ],
  "grandTotal": 155
}
```

### 前端分帳明細顯示

```
┌────────────────────────────────────┐
│  分帳明細 - 下午茶 + 午餐揪團       │
│  總金額: $155                      │
│  狀態: 已結單                       │
├────────────────────────────────────┤
│  👤 王小明 (業務部)    應付: $155  │
├────────────────────────────────────┤
│  【50嵐】                           │
│  • 珍珠奶茶(大杯) × 1              │
│    少糖,去冰                        │
│    加料：珍珠 (+$10)                │
│    小計：$65                        │
│                                    │
│  外送費分攤 (3人)            $10   │
│  ─────────────────────────────────│
│  本店小計：$75                     │
├────────────────────────────────────┤
│  【池上便當】                       │
│  • 排骨便當(小份) × 1       $80    │
│  外送費分攤                  $0    │
│  ─────────────────────────────────│
│  本店小計：$80                     │
├────────────────────────────────────┤
│  總計：$155                        │
│  [匯出 Excel]  [複製明細]         │
└────────────────────────────────────┘
```

---

## 🚀 開發指南

### 技術棧

**後端：**
- ASP.NET 用現行本機版本
- Entity Framework Core 8.0
- SQL Server 2022
- JWT Bearer Authentication
- AutoMapper 12.0
- Hangfire 1.8 (背景任務)
- EPPlus 7.0 (Excel 匯出)
- BCrypt.Net 4.0 (密碼雜湊)

**前端：**
- React 18
- Vite 5.0
- React Router 6
- Zustand / Redux Toolkit
- Ant Design / MUI
- Axios 1.6
- React Hook Form 7.0
- Recharts 2.0 (圖表)

### 環境要求

- .NET SDK 8.0+
- Node.js 18+
- SQL Server 2019+
- Visual Studio 2022 或 VS Code

### 專案結構

```
OfficeOrderSystem/
├── backend/
│   ├── Controllers/
│   │   ├── AuthController.cs
│   │   ├── StoresController.cs
│   │   ├── EventsController.cs
│   │   ├── OrdersController.cs
│   │   └── StatsController.cs
│   ├── Services/
│   │   ├── IAuthService.cs
│   │   ├── IEventService.cs
│   │   ├── IOrderService.cs
│   │   └── IOrderSummaryService.cs
│   ├── Repositories/
│   │   ├── IRepository.cs
│   │   └── Repository.cs
│   ├── Models/
│   │   ├── User.cs
│   │   ├── Store.cs
│   │   ├── MenuItem.cs
│   │   ├── Event.cs
│   │   ├── OrderGroup.cs
│   │   └── OrderItem.cs
│   ├── DTOs/
│   │   ├── CreateEventDto.cs
│   │   ├── CreateOrderDto.cs
│   │   └── EventSummaryDto.cs
│   └── Data/
│       └── AppDbContext.cs
│
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── services/
│   │   ├── hooks/
│   │   └── store/
│   └── public/
│
└── database/
    ├── schema.sql
    └── seed-data.sql
```

### 環境設定

**後端 appsettings.json：**
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=OfficeOrderSystem;Trusted_Connection=True;TrustServerCertificate=True;"
  },
  "Jwt": {
    "Key": "YOUR-SECRET-KEY-AT-LEAST-32-CHARACTERS-LONG",
    "Issuer": "OfficeOrderAPI",
    "Audience": "OfficeOrderClient",
    "ExpiryMinutes": 1440
  }
}
```

**前端 .env：**
```env
VITE_API_URL=https://localhost:5001/api
```

### 啟動步驟

1. **建立資料庫**
   ```bash
   cd database
   sqlcmd -S localhost -i schema.sql
   sqlcmd -S localhost -i seed-data.sql
   ```

2. **啟動後端**
   ```bash
   cd backend
   dotnet restore
   dotnet ef database update
   dotnet run
   # API: https://localhost:5001
   # Swagger: https://localhost:5001/swagger
   ```

3. **啟動前端**
   ```bash
   cd frontend
   npm install
   npm run dev
   # App: http://localhost:5173
   ```

### 測試帳號

| 角色 | Email | 密碼 | 說明 |
|------|-------|------|------|
| 管理員 | admin@company.com | admin123 | 可管理店家和菜單 |
| 一般使用者 | wang@company.com | user123 | 可發起揪團和點餐 |

---

## 📊 開發進度

### Phase 1 - MVP（2-3 週）
- [ ] 資料庫建立與種子資料
- [ ] 使用者登入/註冊（JWT）
- [ ] 發起揪團（多店支援）
- [ ] 點餐功能（飲料 + 便當）
- [ ] 尺寸定價系統
- [ ] 基礎分帳計算

### Phase 2 - 完整客製化（1-2 週）
- [ ] 甜度、溫度選項實作
- [ ] 加料系統（多選、價格計算）
- [ ] 購物車功能
- [ ] 訂單修改/取消（截止前）
- [ ] 分帳明細頁面
- [ ] Excel 匯出功能

### Phase 3 - 統計分析（1 週）
- [ ] 熱門品項排行（TOP 10）
- [ ] 個人消費報表
- [ ] 部門消費分析
- [ ] 圖表視覺化（Recharts）

### Phase 4 - 進階功能（未來規劃）
- [ ] 截止提醒（Hangfire 排程）
- [ ] Email 通知
- [ ] 即時更新（SignalR）
- [ ] 行動版 PWA
- [ ] LINE Bot 整合（暫緩）

---

## 📝 授權

MIT License

---

## 📧 聯絡方式

專案負責人：[Your Name]  
Email: your.email@company.com

專案連結：[https://github.com/your-org/office-order-system](https://github.com/your-org/office-order-system)

---

## 🙏 參考資源

- [ASP.NET Core 文件](https://docs.microsoft.com/aspnet/core)
- [React 官方文件](https://reactjs.org/)
- [Ant Design](https://ant.design/)
- [Entity Framework Core](https://docs.microsoft.com/ef/core)

---

**文件版本：** 2.0（完整版）  
**最後更新：** 2026-04-03  
**包含內容：** 多店訂購、尺寸定價、甜度/溫度/加料、自動分帳邏輯

---

## 🌐 繁體中文編碼說明

### 重要提醒
**本專案所有中文內容必須使用繁體中文（UTF-8）編碼，確保不會出現亂碼。**

### 資料庫操作

#### 1. 插入中文資料
執行SQL時必須使用 `-f 65001` 參數指定UTF-8編碼：

`ash
sqlcmd -S 192.168.207.52 -d L_DBII -U reyi -P "ReyifmE" \
  -i insert_menu_utf8.sql -f 65001
`

#### 2. 查詢中文資料
查詢時也要加上 `-f 65001` 參數：

`ash
sqlcmd -S 192.168.207.52 -d L_DBII -U reyi -P "ReyifmE" \
  -Q "SELECT Name FROM MenuItems" -f 65001 -W
`

#### 3. SQL腳本編寫規則
- 所有中文字串前必須加 `N` 前綴（表示Unicode字串）
- 範例：`INSERT INTO MenuItems (Name) VALUES (N'珍珠奶茶');`
- 文件必須保存為 UTF-8 編碼

### API返回中文

後端API已正確配置UTF-8編碼：
- **.NET Core** 自動使用UTF-8處理JSON
- **Content-Type**: `application/json; charset=utf-8`
- 無需額外配置

### 前端顯示中文

React前端已配置：
- `index.html` 包含 `<meta charset="UTF-8">`
- Ant Design 已設置為 `zhTW` 語系
- 所有中文文字正確顯示

### 驗證中文顯示

`powershell
# 測試資料庫
sqlcmd -S 192.168.207.52 -d L_DBII -U reyi -P "ReyifmE" \
  -Q "SELECT TOP 3 Name FROM MenuItems" -f 65001

# 測試API
$token = (Invoke-RestMethod -Uri "http://localhost:5000/api/auth/login" -Method POST -Body (@{email="admin@company.com";password="admin999"}|ConvertTo-Json) -ContentType "application/json").data.token
Invoke-RestMethod -Uri "http://localhost:5000/api/stores/1" -Headers @{Authorization="Bearer $token"}
`

### 常見問題

**Q: 為什麼資料庫看到亂碼？**  
A: 執行sqlcmd時忘記加 `-f 65001` 參數

**Q: 插入資料後變成???**  
A: SQL字串前忘記加 `N` 前綴

**Q: API返回中文正常，但前端顯示亂碼？**  
A: 檢查 index.html 的 charset 設定

---

## 📞 聯絡資訊

如有任何問題或建議，請聯繫開發團隊。

---

**© 2026 智慧辦公室訂購系統 | 版本 2.0**
