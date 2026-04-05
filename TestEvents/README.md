# 測試文件整理說明

## 📁 目錄結構

### TestEvents/ (測試事件)
存放所有測試相關的數據和腳本文件：

- **JSON 測試數據文件**：
  - `pool_bento_menu.json` - 池上便當菜單測試數據
  - `store1_menu.json` - 店家1菜單測試數據
  - `test-event.json` - 測試事件數據
  - `test_store1_output.json` - 店家 1 輸出測試數據
  - `wutao_bento_menu.json` - 悟饕便當菜單測試數據

- **PowerShell 測試腳本**：
  - `test-create-event.ps1` - 測試創建揪團 API
  - `test-event-detail.ps1` - 測試事件詳情 API
  - `test-menu-api.ps1` - 測試菜單 API
  - `整理測試文件.ps1` - 整理測試文件的腳本

### TestReports/ (測試報告)
存放所有測試報告和說明文檔：

- `便當菜單新增報告.md` - 便當菜單新增功能測試報告
- `截止時間顯示測試說明.md` - 截止時間顯示功能說明
- `繁體中文測試報告.md` - 繁體中文編碼測試報告
- `繁體中文編碼說明.md` - 繁體中文編碼實做說明

## 📝 使用說明

### 執行測試腳本

1. **測試創建揪團**：
   ```powershell
   cd TestEvents
   .\test-create-event.ps1
   ```

2. **測試事件詳情**：
   ```powershell
   cd TestEvents
   .\test-event-detail.ps1
   ```

3. **測試菜單API**：
   ```powershell
   cd TestEvents
   .\test-menu-api.ps1
   ```

### 查看測試報告

測試報告位於 `TestReports/` 目錄，使用任何 Markdown 編輯器或 VS Code 查看。

## 📋 文件格式說明

### JSON 測試數據格式

所有 JSON 文件都使用 **UTF-8 編碼**，確保繁體中文正確顯示。

範例結構：
```json
{
  "success": true,
  "data": {
    "storeName": "店家名稱",
    "menuItems": [...]
  }
}
```

### PowerShell 腳本說明

所有測試腳本都包含：
- 自動登入取得 Token
- API 端點測試
- 結果輸出與驗證
- UTF-8 編碼支持（使用 `-f 65001` 參數）

## 🔧 維護說明

### 添加新的測試文件

1. **測試數據**：放入 `TestEvents/` 目錄
2. **測試報告**：放入 `TestReports/` 目錄
3. 使用 UTF-8 編碼儲存所有文件
4. JSON 文件中的中文字串使用 `N''` 前綴（SQL）或直接使用 UTF-8

### 整理文件結構

如需重新整理，執行：
```powershell
cd A_order
.\TestEvents\整理測試文件.ps1
```

## ✅ 整理完成狀態

- ✅ 所有 JSON 測試數據已移至 `TestEvents/`
- ✅ 所有 PowerShell 測試腳本已移至 `TestEvents/`
- ✅ 所有測試報告已移至 `TestReports/`
- ✅ A_order 根目錄保持整潔

---

**整理日期**：2026-04-03  
**整理目的**：避免 A_order 根目錄檔案過多，提升專案可維護性
