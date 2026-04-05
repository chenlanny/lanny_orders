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
    /// 用戶管理控制器（僅限管理員）
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    [Authorize(Roles = "Admin")]
    public class UsersController : ControllerBase
    {
        private readonly AuthService _authService;
        private readonly ILogger<UsersController> _logger;

        public UsersController(AuthService authService, ILogger<UsersController> logger)
        {
            _authService = authService;
            _logger = logger;
        }

        /// <summary>
        /// 獲取所有用戶列表
        /// </summary>
        [HttpGet]
        public async Task<ActionResult<ApiResponse<List<UserListDto>>>> GetAllUsers()
        {
            try
            {
                var users = await _authService.GetAllUsersAsync();
                return Ok(ApiResponse<List<UserListDto>>.Ok(users, "獲取用戶列表成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "獲取用戶列表失敗");
                return StatusCode(500, ApiResponse<List<UserListDto>>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 根據 ID 獲取用戶資訊
        /// </summary>
        [HttpGet("{id}")]
        public async Task<ActionResult<ApiResponse<UserDto>>> GetUserById(int id)
        {
            try
            {
                var user = await _authService.GetUserByIdAsync(id);

                if (user == null)
                {
                    return NotFound(ApiResponse<UserDto>.Fail("用戶不存在"));
                }

                return Ok(ApiResponse<UserDto>.Ok(user, "獲取用戶資訊成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "獲取用戶資訊失敗：UserId={UserId}", id);
                return StatusCode(500, ApiResponse<UserDto>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 新增用戶（管理員專用）
        /// </summary>
        [HttpPost]
        public async Task<ActionResult<ApiResponse<UserListDto>>> CreateUser([FromBody] CreateUserDto request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ApiResponse<UserListDto>.Fail("請求資料格式不正確"));
                }

                var user = await _authService.AdminCreateUserAsync(request);

                if (user == null)
                {
                    return BadRequest(ApiResponse<UserListDto>.Fail("Email 已被使用"));
                }

                return Ok(ApiResponse<UserListDto>.Ok(user, "新增用戶成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "新增用戶失敗");
                return StatusCode(500, ApiResponse<UserListDto>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 更新用戶資訊
        /// </summary>
        [HttpPut("{id}")]
        public async Task<ActionResult<ApiResponse<UserListDto>>> UpdateUser(int id, [FromBody] UpdateUserDto request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ApiResponse<UserListDto>.Fail("請求資料格式不正確"));
                }

                var user = await _authService.UpdateUserAsync(id, request);

                if (user == null)
                {
                    return NotFound(ApiResponse<UserListDto>.Fail("用戶不存在"));
                }

                return Ok(ApiResponse<UserListDto>.Ok(user, "用戶資訊更新成功"));
            }
            catch (ArgumentException ex)
            {
                _logger.LogWarning(ex, "更新用戶資訊失敗：{Message}", ex.Message);
                return BadRequest(ApiResponse<UserListDto>.Fail(ex.Message));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "更新用戶資訊失敗：UserId={UserId}", id);
                return StatusCode(500, ApiResponse<UserListDto>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 重置用戶密碼
        /// </summary>
        [HttpPut("{id}/reset-password")]
        public async Task<ActionResult<ApiResponse<object>>> ResetPassword(int id, [FromBody] AdminResetPasswordDto request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ApiResponse<object>.Fail("請求資料格式不正確"));
                }

                var success = await _authService.AdminResetPasswordAsync(id, request);

                if (!success)
                {
                    return NotFound(ApiResponse<object>.Fail("用戶不存在"));
                }

                return Ok(ApiResponse<object>.Ok(null, "密碼重置成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "重置密碼失敗：UserId={UserId}", id);
                return StatusCode(500, ApiResponse<object>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 刪除用戶（軟刪除）
        /// </summary>
        [HttpDelete("{id}")]
        public async Task<ActionResult<ApiResponse<object>>> DeleteUser(int id)
        {
            try
            {
                // 防止管理員刪除自己
                var currentUserId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "0");
                if (currentUserId == id)
                {
                    return BadRequest(ApiResponse<object>.Fail("無法刪除自己的帳號"));
                }

                var success = await _authService.DeleteUserAsync(id);

                if (!success)
                {
                    return NotFound(ApiResponse<object>.Fail("用戶不存在"));
                }

                return Ok(ApiResponse<object>.Ok(null, "用戶已停用"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "刪除用戶失敗：UserId={UserId}", id);
                return StatusCode(500, ApiResponse<object>.Fail("伺服器錯誤", ex.Message));
            }
        }
    }
}
