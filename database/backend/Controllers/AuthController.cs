using System;
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
    public class AuthController : ControllerBase
    {
        private readonly AuthService _authService;
        private readonly ILogger<AuthController> _logger;

        public AuthController(AuthService authService, ILogger<AuthController> logger)
        {
            _authService = authService;
            _logger = logger;
        }

        /// <summary>
        /// 用戶登入
        /// </summary>
        [HttpPost("login")]
        public async Task<ActionResult<ApiResponse<LoginResponseDto>>> Login([FromBody] LoginRequestDto request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ApiResponse<LoginResponseDto>.Fail("請求資料格式不正確"));
                }

                var result = await _authService.LoginAsync(request);

                if (result == null)
                {
                    return Unauthorized(ApiResponse<LoginResponseDto>.Fail("電子郵件或密碼錯誤"));
                }

                return Ok(ApiResponse<LoginResponseDto>.Ok(result, "登入成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "登入失敗");
                var inner = ex.InnerException?.InnerException?.Message ?? ex.InnerException?.Message ?? ex.Message;
                return StatusCode(500, ApiResponse<LoginResponseDto>.Fail("伺服器錯誤", $"{ex.Message} | INNER: {inner}"));
            }
        }

        /// <summary>
        /// 用戶註冊
        /// </summary>
        [HttpPost("register")]
        public async Task<ActionResult<ApiResponse<UserDto>>> Register([FromBody] RegisterRequestDto request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ApiResponse<UserDto>.Fail("請求資料格式不正確"));
                }

                var result = await _authService.RegisterAsync(request);

                if (result == null)
                {
                    return Conflict(ApiResponse<UserDto>.Fail("電子郵件已被使用"));
                }

                return Ok(ApiResponse<UserDto>.Ok(result, "註冊成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "註冊失敗");
                return StatusCode(500, ApiResponse<UserDto>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 變更密碼
        /// </summary>
        [Authorize]
        [HttpPost("change-password")]
        public async Task<ActionResult<ApiResponse<object>>> ChangePassword([FromBody] ChangePasswordRequestDto request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ApiResponse<object>.Fail("請求資料格式不正確"));
                }

                // 從 JWT Token 中取得 UserId
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int userId))
                {
                    return Unauthorized(ApiResponse<object>.Fail("無效的使用者驗證"));
                }

                var result = await _authService.ChangePasswordAsync(userId, request);

                if (!result)
                {
                    return BadRequest(ApiResponse<object>.Fail("目前密碼錯誤"));
                }

                return Ok(ApiResponse<object>.Ok(null, "密碼變更成功"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "密碼變更失敗");
                return StatusCode(500, ApiResponse<object>.Fail("伺服器錯誤", ex.Message));
            }
        }

        /// <summary>
        /// 診斷端點 - 檢查網絡連接
        /// </summary>
        [HttpGet("diag")]
        public async Task<ActionResult<object>> Diagnosis()
        {
            try
            {
                var diagnostics = new
                {
                    timestamp = DateTime.UtcNow,
                    hostname = System.Net.Dns.GetHostName(),
                };

                // 嘗試 DNS 解析
                try
                {
                    var host = await System.Net.Dns.GetHostEntryAsync("aws-0-ap-southeast-1.pooler.supabase.com");
                    diagnostics = new
                    {
                        diagnostics.timestamp,
                        diagnostics.hostname,
                        dnsResolved = true,
                        ipAddresses = host.AddressList.Length
                    };
                }
                catch (Exception dnsEx)
                {
                    diagnostics = new
                    {
                        diagnostics.timestamp,
                        diagnostics.hostname,
                        dnsResolved = false,
                        dnsError = dnsEx.Message
                    };
                }

                return Ok(new { success = true, data = diagnostics });
            }
            catch (Exception ex)
            {
                return Ok(new { success = false, error = ex.Message });
            }
        }
    }
}
