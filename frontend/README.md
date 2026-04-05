# 智慧辦公室訂購系統 - 前端

基於 React 18 + Vite 5 + Ant Design 5 的前端應用程式。

## 技術棧

- **React 18** - UI 框架
- **Vite 5** - 建置工具
- **Ant Design 5** - UI 組件庫
- **React Router 6** - 路由管理
- **Zustand** - 狀態管理
- **Axios** - HTTP 客戶端
- **Day.js** - 日期處理

## 快速開始

### 安裝依賴

```bash
npm install
```

### 啟動開發伺服器

```bash
npm run dev
```

前端將運行在: **http://localhost:5173**

### 建置生產版本

```bash
npm run build
```

### 預覽生產版本

```bash
npm run preview
```

## 專案結構

```
frontend/
├── src/
│   ├── components/         # 可重用組件
│   │   ├── Layout/        # 佈局組件 (Header, Sidebar, Layout)
│   │   ├── Menu/          # 菜單組件 (MenuItemCard)
│   │   └── Order/         # 訂單組件 (ShoppingCart)
│   ├── pages/             # 頁面組件
│   │   ├── Login.jsx      # 登入頁
│   │   ├── Dashboard.jsx  # 首頁
│   │   ├── CreateEvent.jsx # 發起揪團
│   │   ├── EventDetail.jsx # 揪團詳情
│   │   ├── Summary.jsx    # 分帳明細
│   │   ├── History.jsx    # 歷史訂單
│   │   └── Stats.jsx      # 統計分析
│   ├── services/          # API 服務
│   │   ├── api.js         # Axios 配置
│   │   ├── authService.js # 認證服務
│   │   ├── eventService.js # 揪團服務
│   │   ├── orderService.js # 訂單服務
│   │   └── storeService.js # 店家服務
│   ├── store/             # 狀態管理
│   │   ├── authStore.js   # 認證狀態
│   │   └── cartStore.js   # 購物車狀態
│   ├── App.jsx            # 根組件
│   ├── main.jsx           # 入口文件
│   └── index.css          # 全局樣式
├── index.html             # HTML 模板
├── vite.config.js         # Vite 配置
├── package.json           # 項目配置
└── .env                   # 環境變量
```

## 環境變量

在 `.env` 文件中配置：

```
VITE_API_URL=http://localhost:5000/api
```

## 測試帳號

- **管理員**: admin@company.com / admin123
- **一般使用者**: wang@company.com / user123

## API 代理配置

開發模式下，Vite 會自動代理 `/api` 請求到後端 API (http://localhost:5000)。

配置位於 `vite.config.js`:

```javascript
server: {
  port: 5173,
  proxy: {
    '/api': {
      target: 'http://localhost:5000',
      changeOrigin: true,
      secure: false
    }
  }
}
```

## 功能頁面

### 已實現

- ✅ 登入頁面 (JWT 認證)
- ✅ 首頁 (進行中的揪團列表)
- ✅ 發起新揪團 (多店家支持)
- ✅ 揪團詳情 (店家分頁、菜單瀏覽)
- ✅ 點餐功能 (尺寸、甜度、溫度、加料選擇)
- ✅ 購物車 (數量調整、品項刪除)
- ✅ 分帳明細 (用戶統計、店家匯總)

### 待開發

- ⏳ 歷史訂單查詢
- ⏳ 統計分析圖表
- ⏳ 個人資料設定
- ⏳ 管理後台 (店家管理、菜單管理)

## 注意事項

1. **後端 API 必須先啟動**
   - 確保後端 API 運行在 http://localhost:5000
   - 檢查資料庫連接正常

2. **中文字符支持**
   - 使用 UTF-8 編碼
   - Ant Design 已配置繁體中文語系

3. **跨域請求**
   - 開發模式使用 Vite 代理
   - 生產環境需要後端配置 CORS

## 開發建議

- 使用 React DevTools 進行調試
- 使用 VS Code 並安裝 ESLint 和 Prettier 擴展
- 遵循 React Hooks 最佳實踐
- 組件保持單一職責原則

## 版本

- 版本: 1.0.0
- 最後更新: 2026-04-03
