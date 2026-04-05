using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using OfficeOrderApi.Services;
using OfficeOrderApi.DTOs;

namespace OfficeOrderApi.Controllers
{
    /// <summary>
    /// 用戶訂單控制器（不限特定活動）
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class UserOrdersController : ControllerBase
    {
        private readonly OrderService _orderService;
        private readonly ILogger<UserOrdersController> _logger;

        public UserOrdersController(OrderService orderService, ILogger<UserOrdersController> logger)
        {
            _orderService = orderService;
            _logger = logger;
        }

        /// <summary>
        /// 取得當前用戶 ID
        /// </summary>
        private int GetCurrentUserId()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.Parse(userIdClaim);
        }

        /// <summary>
        /// 檢查是否為管理員
        /// </summary>
        private bool IsAdmin()
        {
            var roleClaim = User.FindFirst(ClaimTypes.Role)?.Value;
            return roleClaim == "Admin";
        }

        /// <summary>
        /// 取得當前用戶的所有歷史訂單（管理員可查看所有用戶）
        /// </summary>
        /// <param name="pageSize">每頁數量（預設50）</param>
        /// <param name="page">頁碼（預設1）</param>
        [HttpGet("history")]
        public async Task<ActionResult<ApiResponse<List<OrderHistoryDto>>>> GetOrderHistory(
            [FromQuery] int pageSize = 50, 
            [FromQuery] int page = 1)
        {
            try
            {
                if (pageSize > 100) pageSize = 100;
                if (page < 1) page = 1;

                var userId = GetCurrentUserId();
                var isAdmin = IsAdmin();
                
                // 管理員可以查看所有用戶的訂單，普通用戶只能查看自己的訂單
                var orders = await _orderService.GetUserOrderHistoryAsync(
                    isAdmin ? (int?)null : userId, 
                    pageSize, 
                    page
                );

                return Ok(ApiResponse<List<OrderHistoryDto>>.Ok(orders, "查詢成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得用戶歷史訂單失敗");
                return StatusCode(500, ApiResponse<List<OrderHistoryDto>>.Fail("伺服器錯誤", ex.Message));
            }
        }
    }
}
