using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using OfficeOrderApi.Data;
using OfficeOrderApi.DTOs;

namespace OfficeOrderApi.Services
{
    /// <summary>
    /// 店家管理服務
    /// </summary>
    public class StoreService
    {
        private readonly AppDbContext _context;
        private readonly ILogger<StoreService> _logger;

        public StoreService(AppDbContext context, ILogger<StoreService> logger)
        {
            _context = context;
            _logger = logger;
        }

        /// <summary>
        /// 取得所有店家列表
        /// </summary>
        public async Task<List<StoreSimpleDto>> GetAllStoresAsync(string? category = null)
        {
            try
            {
                var query = _context.Stores.AsQueryable();

                if (!string.IsNullOrEmpty(category))
                {
                    query = query.Where(s => s.Category == category);
                }

                var stores = await query
                    .OrderBy(s => s.Category)
                    .ThenBy(s => s.Name)
                    .ToListAsync();

                return stores.Select(s => new StoreSimpleDto
                {
                    StoreId = s.StoreId,
                    StoreName = s.Name,
                    Category = s.Category,
                    Phone = s.Phone,
                    Address = s.Address
                }).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得店家列表失敗");
                throw;
            }
        }

        /// <summary>
        /// 取得店家詳情（含菜單）
        /// </summary>
        public async Task<StoreDto?> GetStoreByIdAsync(int storeId)
        {
            try
            {
                var store = await _context.Stores
                    .Include(s => s.MenuItems)
                    .FirstOrDefaultAsync(s => s.StoreId == storeId);

                if (store == null)
                {
                    return null;
                }

                return new StoreDto
                {
                    StoreId = store.StoreId,
                    StoreName = store.Name,
                    Category = store.Category,
                    Phone = store.Phone,
                    Address = store.Address,
                    CreatedAt = store.CreatedAt,
                    MenuItems = store.MenuItems
                        .Where(m => m.IsAvailable)
                        .Select(m => new MenuItemDto
                    {
                        MenuItemId = m.ItemId,
                        ItemName = m.Name,
                        Category = m.Category,
                        PriceRules = m.PriceRules,
                        Options = m.Options,
                        IsAvailable = m.IsAvailable,
                        CreatedAt = m.CreatedAt
                    }).ToList()
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得店家詳情失敗：StoreId={StoreId}", storeId);
                throw;
            }
        }

        /// <summary>
        /// 取得店家的可用菜單
        /// </summary>
        public async Task<List<MenuItemDto>> GetStoreMenuAsync(int storeId)
        {
            try
            {
                var menuItems = await _context.MenuItems
                    .Where(m => m.StoreId == storeId && m.IsAvailable)
                    .OrderBy(m => m.Category)
                    .ThenBy(m => m.Name)
                    .ToListAsync();

                return menuItems.Select(m => new MenuItemDto
                {
                    MenuItemId = m.ItemId,
                    ItemName = m.Name,
                    Category = m.Category,
                    PriceRules = m.PriceRules,
                    Options = m.Options,
                    IsAvailable = m.IsAvailable,
                    CreatedAt = m.CreatedAt
                }).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得店家菜單失敗：StoreId={StoreId}", storeId);
                throw;
            }
        }

        /// <summary>
        /// 創建新店家
        /// </summary>
        public async Task<StoreSimpleDto> CreateStoreAsync(CreateStoreRequestDto request)
        {
            try
            {
                _logger.LogInformation("創建新店家：{Name}", request.Name);

                var store = new Models.Store
                {
                    Name = request.Name,
                    Category = request.Category,
                    Phone = request.Phone,
                    Address = request.Address,
                    CreatedAt = DateTime.Now
                };

                _context.Stores.Add(store);
                await _context.SaveChangesAsync();

                _logger.LogInformation("店家創建成功：StoreId={StoreId}", store.StoreId);

                return new StoreSimpleDto
                {
                    StoreId = store.StoreId,
                    StoreName = store.Name,
                    Category = store.Category,
                    Phone = store.Phone,
                    Address = store.Address
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "創建店家失敗：{Name}", request.Name);
                throw;
            }
        }

        /// <summary>
        /// 更新店家資訊
        /// </summary>
        public async Task<StoreSimpleDto> UpdateStoreAsync(int storeId, UpdateStoreRequestDto request)
        {
            try
            {
                _logger.LogInformation("更新店家：StoreId={StoreId}", storeId);

                var store = await _context.Stores.FindAsync(storeId);
                if (store == null)
                {
                    throw new KeyNotFoundException($"店家不存在：StoreId={storeId}");
                }

                store.Name = request.Name;
                store.Category = request.Category;
                store.Phone = request.Phone;
                store.Address = request.Address;

                await _context.SaveChangesAsync();

                _logger.LogInformation("店家更新成功：StoreId={StoreId}", storeId);

                return new StoreSimpleDto
                {
                    StoreId = store.StoreId,
                    StoreName = store.Name,
                    Category = store.Category,
                    Phone = store.Phone,
                    Address = store.Address
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "更新店家失敗：StoreId={StoreId}", storeId);
                throw;
            }
        }

        /// <summary>
        /// 刪除店家
        /// </summary>
        public async Task<bool> DeleteStoreAsync(int storeId)
        {
            try
            {
                _logger.LogInformation("刪除店家：StoreId={StoreId}", storeId);

                var store = await _context.Stores.FindAsync(storeId);
                if (store == null)
                {
                    throw new KeyNotFoundException($"店家不存在：StoreId={storeId}");
                }

                // 檢查是否有相關訂單
                var hasOrders = await _context.OrderGroups.AnyAsync(og => og.StoreId == storeId);
                if (hasOrders)
                {
                    throw new InvalidOperationException("此店家有相關訂單記錄，無法刪除");
                }

                _context.Stores.Remove(store);
                await _context.SaveChangesAsync();

                _logger.LogInformation("店家刪除成功：StoreId={StoreId}", storeId);
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "刪除店家失敗：StoreId={StoreId}", storeId);
                throw;
            }
        }

        /// <summary>
        /// 創建菜單項目
        /// </summary>
        public async Task<MenuItemDto> CreateMenuItemAsync(int storeId, CreateMenuItemRequestDto request)
        {
            try
            {
                _logger.LogInformation("為店家 {StoreId} 創建菜單：{ItemName}", storeId, request.ItemName);

                // 確認店家存在
                var storeExists = await _context.Stores.AnyAsync(s => s.StoreId == storeId);
                if (!storeExists)
                {
                    throw new KeyNotFoundException($"店家不存在：StoreId={storeId}");
                }

                var menuItem = new Models.MenuItem
                {
                    StoreId = storeId,
                    Name = request.ItemName,
                    Category = request.Category,
                    PriceRules = request.PriceRules,
                    Options = request.Options,
                    IsAvailable = request.IsAvailable,
                    CreatedAt = DateTime.Now
                };

                _context.MenuItems.Add(menuItem);
                await _context.SaveChangesAsync();

                _logger.LogInformation("菜單項目創建成功：ItemId={ItemId}", menuItem.ItemId);

                return new MenuItemDto
                {
                    MenuItemId = menuItem.ItemId,
                    ItemName = menuItem.Name,
                    Category = menuItem.Category,
                    PriceRules = menuItem.PriceRules,
                    Options = menuItem.Options,
                    IsAvailable = menuItem.IsAvailable,
                    CreatedAt = menuItem.CreatedAt
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "創建菜單項目失敗：StoreId={StoreId}", storeId);
                throw;
            }
        }

        /// <summary>
        /// 更新菜單項目
        /// </summary>
        public async Task<MenuItemDto> UpdateMenuItemAsync(int menuItemId, UpdateMenuItemRequestDto request)
        {
            try
            {
                _logger.LogInformation("更新菜單項目：ItemId={ItemId}", menuItemId);

                var menuItem = await _context.MenuItems.FindAsync(menuItemId);
                if (menuItem == null)
                {
                    throw new KeyNotFoundException($"菜單項目不存在：ItemId={menuItemId}");
                }

                menuItem.Name = request.ItemName;
                menuItem.Category = request.Category;
                menuItem.PriceRules = request.PriceRules;
                menuItem.Options = request.Options;
                menuItem.IsAvailable = request.IsAvailable;

                await _context.SaveChangesAsync();

                _logger.LogInformation("菜單項目更新成功：ItemId={ItemId}", menuItemId);

                return new MenuItemDto
                {
                    MenuItemId = menuItem.ItemId,
                    ItemName = menuItem.Name,
                    Category = menuItem.Category,
                    PriceRules = menuItem.PriceRules,
                    Options = menuItem.Options,
                    IsAvailable = menuItem.IsAvailable,
                    CreatedAt = menuItem.CreatedAt
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "更新菜單項目失敗：ItemId={ItemId}", menuItemId);
                throw;
            }
        }

        /// <summary>
        /// 刪除菜單項目
        /// </summary>
        public async Task<bool> DeleteMenuItemAsync(int menuItemId)
        {
            try
            {
                _logger.LogInformation("刪除菜單項目：ItemId={ItemId}", menuItemId);

                var menuItem = await _context.MenuItems.FindAsync(menuItemId);
                if (menuItem == null)
                {
                    throw new KeyNotFoundException($"菜單項目不存在：ItemId={menuItemId}");
                }

                // 檢查是否有相關訂單
                var hasOrders = await _context.OrderItems.AnyAsync(oi => oi.ItemId == menuItemId);
                if (hasOrders)
                {
                    // 不刪除，只設為不可用
                    menuItem.IsAvailable = false;
                    await _context.SaveChangesAsync();
                    _logger.LogInformation("菜單項目已有訂單記錄，設為不可用：ItemId={ItemId}", menuItemId);
                }
                else
                {
                    _context.MenuItems.Remove(menuItem);
                    await _context.SaveChangesAsync();
                    _logger.LogInformation("菜單項目刪除成功：ItemId={ItemId}", menuItemId);
                }

                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "刪除菜單項目失敗：ItemId={ItemId}", menuItemId);
                throw;
            }
        }

        /// <summary>
        /// 取得店家的所有菜單（含不可用項目，供管理用）
        /// </summary>
        public async Task<List<MenuItemDto>> GetAllMenuItemsAsync(int storeId)
        {
            try
            {
                var menuItems = await _context.MenuItems
                    .Where(m => m.StoreId == storeId)
                    .OrderBy(m => m.Category)
                    .ThenBy(m => m.Name)
                    .ToListAsync();

                return menuItems.Select(m => new MenuItemDto
                {
                    MenuItemId = m.ItemId,
                    ItemName = m.Name,
                    Category = m.Category,
                    PriceRules = m.PriceRules,
                    Options = m.Options,
                    IsAvailable = m.IsAvailable,
                    CreatedAt = m.CreatedAt
                }).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得所有菜單項目失敗：StoreId={StoreId}", storeId);
                throw;
            }
        }
    }
}
