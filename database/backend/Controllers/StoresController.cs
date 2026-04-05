using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using OfficeOrderApi.Services;
using OfficeOrderApi.DTOs;

namespace OfficeOrderApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class StoresController : ControllerBase
    {
        private readonly StoreService _storeService;
        private readonly ILogger<StoresController> _logger;

        public StoresController(StoreService storeService, ILogger<StoresController> logger)
        {
            _storeService = storeService;
            _logger = logger;
        }

        /// <summary>
        /// 取得所有店家列表
        /// </summary>
        [HttpGet]
        public async Task<ActionResult<ApiResponse<List<StoreSimpleDto>>>> GetAllStores([FromQuery] string? category = null)
        {
            try
            {
                var stores = await _storeService.GetAllStoresAsync(category);
                return Ok(ApiResponse<List<StoreSimpleDto>>.Ok(stores, "查詢成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得店家列表失敗");
                return StatusCode(500, ApiResponse<List<StoreSimpleDto>>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 取得店家詳情（含菜單）
        /// </summary>
        [HttpGet("{storeId}")]
        public async Task<ActionResult<ApiResponse<StoreDto>>> GetStoreById(int storeId)
        {
            try
            {
                var store = await _storeService.GetStoreByIdAsync(storeId);

                if (store == null)
                {
                    return NotFound(ApiResponse<StoreDto>.Fail("店家不存在"));
                }

                return Ok(ApiResponse<StoreDto>.Ok(store, "查詢成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得店家詳情失敗：StoreId={StoreId}", storeId);
                return StatusCode(500, ApiResponse<StoreDto>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 取得店家菜單
        /// </summary>
        [HttpGet("{storeId}/menu")]
        public async Task<ActionResult<ApiResponse<List<MenuItemDto>>>> GetStoreMenu(int storeId)
        {
            try
            {
                var menu = await _storeService.GetStoreMenuAsync(storeId);
                return Ok(ApiResponse<List<MenuItemDto>>.Ok(menu, "查詢成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得店家菜單失敗：StoreId={StoreId}", storeId);
                return StatusCode(500, ApiResponse<List<MenuItemDto>>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 創建新店家（管理員）
        /// </summary>
        [HttpPost]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<ApiResponse<StoreSimpleDto>>> CreateStore([FromBody] CreateStoreRequestDto request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ApiResponse<StoreSimpleDto>.Fail("請求資料格式不正確"));
                }

                var result = await _storeService.CreateStoreAsync(request);
                return Ok(ApiResponse<StoreSimpleDto>.Ok(result, "店家創建成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "創建店家失敗");
                return StatusCode(500, ApiResponse<StoreSimpleDto>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 更新店家資訊（管理員）
        /// </summary>
        [HttpPut("{storeId}")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<ApiResponse<StoreSimpleDto>>> UpdateStore(int storeId, [FromBody] UpdateStoreRequestDto request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ApiResponse<StoreSimpleDto>.Fail("請求資料格式不正確"));
                }

                var result = await _storeService.UpdateStoreAsync(storeId, request);
                return Ok(ApiResponse<StoreSimpleDto>.Ok(result, "店家更新成功"));
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ApiResponse<StoreSimpleDto>.Fail(ex.Message));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "更新店家失敗：StoreId={StoreId}", storeId);
                return StatusCode(500, ApiResponse<StoreSimpleDto>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 刪除店家（管理員）
        /// </summary>
        [HttpDelete("{storeId}")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<ApiResponse<bool>>> DeleteStore(int storeId)
        {
            try
            {
                var result = await _storeService.DeleteStoreAsync(storeId);
                return Ok(ApiResponse<bool>.Ok(result, "店家刪除成功"));
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ApiResponse<bool>.Fail(ex.Message));
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest(ApiResponse<bool>.Fail(ex.Message));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "刪除店家失敗：StoreId={StoreId}", storeId);
                return StatusCode(500, ApiResponse<bool>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 取得店家所有菜單（含不可用項目，管理用）
        /// </summary>
        [HttpGet("{storeId}/menu/all")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<ApiResponse<List<MenuItemDto>>>> GetAllMenuItems(int storeId)
        {
            try
            {
                var menu = await _storeService.GetAllMenuItemsAsync(storeId);
                return Ok(ApiResponse<List<MenuItemDto>>.Ok(menu, "查詢成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得所有菜單項目失敗：StoreId={StoreId}", storeId);
                return StatusCode(500, ApiResponse<List<MenuItemDto>>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 創建菜單項目（管理員）
        /// </summary>
        [HttpPost("{storeId}/menu")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<ApiResponse<MenuItemDto>>> CreateMenuItem(int storeId, [FromBody] CreateMenuItemRequestDto request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ApiResponse<MenuItemDto>.Fail("請求資料格式不正確"));
                }

                var result = await _storeService.CreateMenuItemAsync(storeId, request);
                return Ok(ApiResponse<MenuItemDto>.Ok(result, "菜單項目創建成功"));
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ApiResponse<MenuItemDto>.Fail(ex.Message));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "創建菜單項目失敗：StoreId={StoreId}", storeId);
                return StatusCode(500, ApiResponse<MenuItemDto>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 更新菜單項目（管理員）
        /// </summary>
        [HttpPut("menu/{menuItemId}")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<ApiResponse<MenuItemDto>>> UpdateMenuItem(int menuItemId, [FromBody] UpdateMenuItemRequestDto request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ApiResponse<MenuItemDto>.Fail("請求資料格式不正確"));
                }

                var result = await _storeService.UpdateMenuItemAsync(menuItemId, request);
                return Ok(ApiResponse<MenuItemDto>.Ok(result, "菜單項目更新成功"));
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ApiResponse<MenuItemDto>.Fail(ex.Message));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "更新菜單項目失敗：ItemId={ItemId}", menuItemId);
                return StatusCode(500, ApiResponse<MenuItemDto>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 刪除菜單項目（管理員）
        /// </summary>
        [HttpDelete("menu/{menuItemId}")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<ApiResponse<bool>>> DeleteMenuItem(int menuItemId)
        {
            try
            {
                var result = await _storeService.DeleteMenuItemAsync(menuItemId);
                return Ok(ApiResponse<bool>.Ok(result, "菜單項目刪除成功"));
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ApiResponse<bool>.Fail(ex.Message));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "刪除菜單項目失敗：ItemId={ItemId}", menuItemId);
                return StatusCode(500, ApiResponse<bool>.Fail("伺服器錯誤", ex.Message));
            }
        }
    }
}
