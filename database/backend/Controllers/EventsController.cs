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
    [Route("api/[controller]")]
    [Authorize]
    public class EventsController : ControllerBase
    {
        private readonly EventService _eventService;
        private readonly SummaryService _summaryService;
        private readonly ILogger<EventsController> _logger;

        public EventsController(
            EventService eventService,
            SummaryService summaryService,
            ILogger<EventsController> logger)
        {
            _eventService = eventService;
            _summaryService = summaryService;
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
        /// 建立訂購活動
        /// </summary>
        [HttpPost]
        public async Task<ActionResult<ApiResponse<EventDto>>> CreateEvent([FromBody] CreateEventRequestDto request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ApiResponse<EventDto>.Fail("請求資料格式不正確"));
                }

                var userId = GetCurrentUserId();
                var result = await _eventService.CreateEventAsync(request, userId);

                return Ok(ApiResponse<EventDto>.Ok(result, "活動建立成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "建立活動失敗");
                return StatusCode(500, ApiResponse<EventDto>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 取得所有進行中的活動
        /// </summary>
        [HttpGet]
        public async Task<ActionResult<ApiResponse<List<EventDto>>>> GetActiveEvents()
        {
            try
            {
                var events = await _eventService.GetActiveEventsAsync();
                return Ok(ApiResponse<List<EventDto>>.Ok(events, "查詢成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得活動列表失敗");
                return StatusCode(500, ApiResponse<List<EventDto>>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 取得活動詳情
        /// </summary>
        [HttpGet("{eventId}")]
        public async Task<ActionResult<ApiResponse<EventDto>>> GetEventById(int eventId)
        {
            try
            {
                var eventDto = await _eventService.GetEventByIdAsync(eventId);
                return Ok(ApiResponse<EventDto>.Ok(eventDto, "查詢成功"));
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ApiResponse<EventDto>.Fail(ex.Message));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得活動詳情失敗：EventId={EventId}", eventId);
                return StatusCode(500, ApiResponse<EventDto>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 關閉活動（截止訂購）
        /// </summary>
        [HttpPost("{eventId}/close")]
        public async Task<ActionResult<ApiResponse<bool>>> CloseEvent(int eventId)
        {
            try
            {
                var userId = GetCurrentUserId();
                var result = await _eventService.CloseEventAsync(eventId, userId);

                if (!result)
                {
                    return Forbid();
                }

                return Ok(ApiResponse<bool>.Ok(true, "活動已關閉"));
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ApiResponse<bool>.Fail(ex.Message));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "關閉活動失敗：EventId={EventId}", eventId);
                return StatusCode(500, ApiResponse<bool>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 更新訂單群組截止時間（活動創建者可提早截止）
        /// </summary>
        [HttpPut("groups/{groupId}/deadline")]
        public async Task<ActionResult<ApiResponse<OrderGroupSimpleDto>>> UpdateOrderGroupDeadline(
            int groupId, 
            [FromBody] UpdateOrderGroupDeadlineDto request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ApiResponse<OrderGroupSimpleDto>.Fail("請求資料格式不正確"));
                }

                var userId = GetCurrentUserId();
                var result = await _eventService.UpdateOrderGroupDeadlineAsync(groupId, request, userId);

                return Ok(ApiResponse<OrderGroupSimpleDto>.Ok(result, "截止時間更新成功"));
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ApiResponse<OrderGroupSimpleDto>.Fail(ex.Message));
            }
            catch (UnauthorizedAccessException ex)
            {
                return StatusCode(403, ApiResponse<OrderGroupSimpleDto>.Fail(ex.Message));
            }
            catch (ArgumentException ex)
            {
                return BadRequest(ApiResponse<OrderGroupSimpleDto>.Fail(ex.Message));
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest(ApiResponse<OrderGroupSimpleDto>.Fail(ex.Message));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "更新訂單群組截止時間失敗：GroupId={GroupId}", groupId);
                return StatusCode(500, ApiResponse<OrderGroupSimpleDto>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 取得活動結算摘要
        /// </summary>
        [HttpGet("{eventId}/summary")]
        public async Task<ActionResult<ApiResponse<EventSummaryDto>>> GetEventSummary(int eventId)
        {
            try
            {
                var summary = await _summaryService.GetEventSummaryAsync(eventId);
                return Ok(ApiResponse<EventSummaryDto>.Ok(summary, "結算完成"));
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ApiResponse<EventSummaryDto>.Fail(ex.Message));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "取得活動結算失敗：EventId={EventId}", eventId);
                return StatusCode(500, ApiResponse<EventSummaryDto>.Fail("伺服器錯誤", ex.Message));
            }
        }
    }
}
