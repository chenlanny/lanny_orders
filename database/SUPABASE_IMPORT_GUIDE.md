# 🚀 Supabase 数据导入指南

## 📋 导出数据摘要

| 表名 | 数量 | 说明 |
|------|------|------|
| 👤 Users | 6 条 | 系统用户（admin + 5 个普通用户） |
| 🏪 Stores | 6 个 | 餐饮店铺 |
| 🥤 MenuItems | 46 项 | 菜单项目 |
| 📅 Events | 10 个 | 订购活动 |
| 📦 OrderGroups | 15 个 | 订单组 |
| 🛒 OrderItems | 13 项 | 订单明细 |
| **总计** | **97** | **完整业务数据** |

## 🔑 测试账号

### 管理员账号
- **邮箱**: admin@company.com
- **密码**: （需查看数据库中的 BCrypt hash）
- **角色**: Admin

### 普通用户账号
- 1@company.com - 王小明
- 2@company.com - 李小華
- 3@company.com - 華經理
- 4@company.com - EC
- 5@company.com - 物流

## 📂 导出文件位置

```
D:\github\ORDERS\A_order\database\
├── export_complete_with_users.sql   ← 完整导出（优先使用）
├── export_final.sql                  ← 不含用户的导出
├── import_1_Users.sql
├── import_2_Stores.sql
├── import_3_MenuItems.sql
├── import_4_Events.sql
├── import_5_OrderGroups.sql
└── import_6_OrderItems.sql
```

## 📊 数据导入步骤

### 方式 A：**完整导入**（推荐）

1. **登录 Supabase**
   ```
   https://app.supabase.com/
   项目 ID: idyfbtswixhfahddnlkw
   ```

2. **打开 SQL Editor**
   - 左侧菜单 → SQL Editor
   - 或直接访问: https://app.supabase.com/project/idyfbtswixhfahddnlkw/sql/new

3. **复制导出内容**
   ```bash
   # Windows PowerShell 中快速复制
   Get-Content "D:\github\ORDERS\A_order\database\export_complete_with_users.sql" | Set-Clipboard
   ```

4. **粘贴并执行**
   - 在 SQL Editor 中粘贴全部代码
   - 点击 "Run" 或 Ctrl+Enter
   - 等待执行完成

### 方式 B：**分段导入**（如果方式 A 超时）

依次在 Supabase SQL Editor 中执行：

```sql
-- 1️⃣ 第一步：导入用户
-- (复制 import_1_Users.sql 的内容)

-- 2️⃣ 第二步：导入店铺
-- (复制 import_2_Stores.sql 的内容)

-- 3️⃣ 第三步：导入菜单
-- (复制 import_3_MenuItems.sql 的内容)

-- 4️⃣ 第四步：导入活动
-- (复制 import_4_Events.sql 的内容)

-- 5️⃣ 第五步：导入订单组
-- (复制 import_5_OrderGroups.sql 的内容)

-- 6️⃣ 第六步：导入订单明细
-- (复制 import_6_OrderItems.sql 的内容)
```

## ✅ 验证导入成功

导入完成后，执行以下 SQL 验证：

```sql
-- 检查数据统计
SELECT 'Users' as table_name, COUNT(*) as count FROM "Users"
UNION ALL
SELECT 'Stores', COUNT(*) FROM "Stores"
UNION ALL
SELECT 'MenuItems', COUNT(*) FROM "MenuItems"
UNION ALL
SELECT 'Events', COUNT(*) FROM "Events"
UNION ALL
SELECT 'OrderGroups', COUNT(*) FROM "OrderGroups"
UNION ALL
SELECT 'OrderItems', COUNT(*) FROM "OrderItems";
```

预期输出：
```
   table_name    | count
──────────────────│──────
   Users         |    6
   Stores        |    6
   MenuItems     |   46
   Events        |   10
   OrderGroups   |   15
   OrderItems    |   13
```

## 🧪 系统测试

导入完成后可以进行以下测试：

### 1. 登录测试
```
前端地址: https://playful-centaur-98df6f.netlify.app/login
测试账号: admin@company.com
```

### 2. API 测试
```bash
# 1. 获取店铺列表（需要认证）
curl -X GET "https://order-system-api-2tve.onrender.com/api/stores" \
  -H "Authorization: Bearer {JWT_TOKEN}"

# 2. 获取菜单项目
curl -X GET "https://order-system-api-2tve.onrender.com/api/menu-items?storeId=1"

# 3. 查看活动列表
curl -X GET "https://order-system-api-2tve.onrender.com/api/events"
```

## 🔧 常见问题

### Q: 导入时报错 "duplicate key value"
**A**: 表中可能已有数据。解决方法：
```sql
-- 清空所有表（仅在开发时使用）
TRUNCATE TABLE "OrderItems" CASCADE;
TRUNCATE TABLE "OrderGroups" CASCADE;
TRUNCATE TABLE "Events" CASCADE;
TRUNCATE TABLE "MenuItems" CASCADE;
TRUNCATE TABLE "Stores" CASCADE;
TRUNCATE TABLE "Users" CASCADE;
```
然后重新执行导入。

### Q: 导入超时了怎么办？
**A**: 使用方式 B 的分段导入，或者：
- 增加 SQL Editor 的超时时间
- 在 pgAdmin 或 psql 客户端执行

### Q: 如何获取系统中的 JWT Token 用于 API 测试？
**A**: 使用登录 API：
```bash
curl -X POST "https://order-system-api-2tve.onrender.com/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@company.com","password":"..."}' 
```

## 📞 其他帮助

- **Backend API**: https://order-system-api-2tve.onrender.com
- **Frontend UI**: https://playful-centaur-98df6f.netlify.app
- **Supabase 项目**: https://app.supabase.com/project/idyfbtswixhfahddnlkw

---

**导出日期**: 2026-04-06
**数据来源**: SQL Server (192.168.207.52) - L_DBII 数据库
**转换格式**: PostgreSQL (Supabase 兼容)
