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
    [ApiController]
    [Route("api/events/{eventId}/[controller]")]
    [Authorize]
    public class OrdersController : ControllerBase
    {
        private readonly OrderService _orderService;
        private readonly ILogger<OrdersController> _logger;

        public OrdersController(OrderService orderService, ILogger<OrdersController> logger)
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
        /// 下訂單
        /// </summary>
        [HttpPost]
        public async Task<ActionResult<ApiResponse<List<OrderItemDto>>>> PlaceOrder(int eventId, [FromBody] SubmitBatchOrderRequestDto request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ApiResponse<List<OrderItemDto>>.Fail("請求資料格式不正確"));
                }

                var userId = GetCurrentUserId();
                var result = await _orderService.SubmitBatchOrderAsync(eventId, request, userId);

                return Ok(ApiResponse<List<OrderItemDto>>.Ok(result, "訂單建立成功"));
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ApiResponse<List<OrderItemDto>>.Fail(ex.Message));
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest(ApiResponse<List<OrderItemDto>>.Fail(ex.Message));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "下訂單失敗：EventId={EventId}", eventId);
                return StatusCode(500, ApiResponse<List<OrderItemDto>>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 取得用戶在特定活動的所有訂單
        /// </summary>
        [HttpGet("my-orders")]
        public async Task<ActionResult<ApiResponse<List<OrderItemDto>>>> GetMyOrders(int eventId)
        {
            try
            {
                var userId = GetCurrentUserId();
                var orders = await _orderService.GetUserOrdersInEventAsync(eventId, userId);

                return Ok(ApiResponse<List<OrderItemDto>>.Ok(orders, "查詢成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得用戶訂單失敗：EventId={EventId}", eventId);
                return StatusCode(500, ApiResponse<List<OrderItemDto>>.Fail("伺服器錯誤", ex.Message));
            }
        }
    }
}
