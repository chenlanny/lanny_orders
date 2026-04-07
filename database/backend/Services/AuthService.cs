using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using OfficeOrderApi.Data;
using OfficeOrderApi.Models;
using OfficeOrderApi.DTOs;

namespace OfficeOrderApi.Services
{
    /// <summary>
    /// 驗證服務
    /// </summary>
    public class AuthService
    {
        private readonly AppDbContext _context;
        private readonly IConfiguration _configuration;
        private readonly ILogger<AuthService> _logger;

        public AuthService(AppDbContext context, IConfiguration configuration, ILogger<AuthService> logger)
        {
            _context = context;
            _configuration = configuration;
            _logger = logger;
        }

        /// <summary>
        /// 用戶登入
        /// </summary>
        public async Task<LoginResponseDto?> LoginAsync(LoginRequestDto request)
        {
            try
            {
                _logger.LogInformation("用戶嘗試登入：{Email}", request.Email);

                // 查詢用戶
                _logger.LogInformation("開始查詢資料庫用戶：{Email}", request.Email);
                var user = await _context.Users
                    .FirstOrDefaultAsync(u => u.Email == request.Email);

                if (user == null)
                {
                    _logger.LogWarning("登入失敗：用戶不存在 {Email}", request.Email);
                    return null;
                }

                _logger.LogInformation("找到用戶，驗證密碼：{Email}", request.Email);

                // 驗證密碼
                if (!BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
                {
                    _logger.LogWarning("登入失敗：密碼錯誤 {Email}", request.Email);
                    return null;
                }

                _logger.LogInformation("密碼驗證成功，檢查帳號狀態：{Email}", request.Email);

                // 檢查帳號是否已停用
                if (!user.IsActive)
                {
                    _logger.LogWarning("登入失敗：帳號已停用 {Email}", request.Email);
                    return null;
                }

                // 生成 JWT Token
                _logger.LogInformation("開始生成 JWT Token：{Email}", request.Email);
                var token = GenerateJwtToken(user);

                _logger.LogInformation("用戶登入成功：{Email}", request.Email);

                return new LoginResponseDto
                {
                    Token = token,
                    User = MapToUserDto(user)
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "❌ 登入過程發生異常：{Email}, 異常類型：{ExceptionType}, 訊息：{Message}", 
                    request.Email, ex.GetType().Name, ex.Message);
                if (ex.InnerException != null)
                {
                    _logger.LogError("內層異常：{InnerExceptionType} - {InnerMessage}", 
                        ex.InnerException.GetType().Name, ex.InnerException.Message);
                }
                throw;
            }
        }

        /// <summary>
        /// 用戶註冊
        /// </summary>
        public async Task<UserDto?> RegisterAsync(RegisterRequestDto request)
        {
            try
            {
                _logger.LogInformation("新用戶嘗試註冊：{Email}", request.Email);

                // 檢查 Email 是否已存在
                if (await _context.Users.AnyAsync(u => u.Email == request.Email))
                {
                    _logger.LogWarning("註冊失敗：Email 已被使用 {Email}", request.Email);
                    return null;
                }

                // 建立新用戶
                var user = new User
                {
                    Name = request.Name,
                    Email = request.Email,
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.Password),
                    Department = request.Department,
                    Role = "User", // 預設角色
                    CreatedAt = DateTime.Now
                };

                _context.Users.Add(user);
                await _context.SaveChangesAsync();

                _logger.LogInformation("用戶註冊成功：{Email}, UserId={UserId}", user.Email, user.UserId);

                return MapToUserDto(user);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "註冊過程發生錯誤：{Email}", request.Email);
                throw;
            }
        }

        /// <summary>
        /// 根據 UserId 取得用戶資訊
        /// </summary>
        public async Task<UserDto?> GetUserByIdAsync(int userId)
        {
            var user = await _context.Users.FindAsync(userId);
            return user == null ? null : MapToUserDto(user);
        }

        /// <summary>
        /// 變更密碼
        /// </summary>
        public async Task<bool> ChangePasswordAsync(int userId, ChangePasswordRequestDto request)
        {
            try
            {
                _logger.LogInformation("用戶嘗試變更密碼：UserId={UserId}", userId);

                // 查詢用戶
                var user = await _context.Users.FindAsync(userId);
                if (user == null)
                {
                    _logger.LogWarning("變更密碼失敗：用戶不存在 UserId={UserId}", userId);
                    return false;
                }

                // 驗證舊密碼
                if (!BCrypt.Net.BCrypt.Verify(request.OldPassword, user.PasswordHash))
                {
                    _logger.LogWarning("變更密碼失敗：舊密碼錯誤 UserId={UserId}", userId);
                    return false;
                }

                // 更新密碼
                user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.NewPassword);
                await _context.SaveChangesAsync();

                _logger.LogInformation("密碼變更成功：UserId={UserId}", userId);
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "變更密碼過程發生錯誤：UserId={UserId}", userId);
                throw;
            }
        }

        /// <summary>
        /// 生成 JWT Token
        /// </summary>
        private string GenerateJwtToken(User user)
        {
            var jwtSettings = _configuration.GetSection("Jwt");
            var key = Encoding.UTF8.GetBytes(jwtSettings["Key"]);

            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.UserId.ToString()),
                new Claim(ClaimTypes.Name, user.Name),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Role, user.Role)
            };

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.UtcNow.AddMinutes(double.Parse(jwtSettings["ExpiryMinutes"])),
                Issuer = jwtSettings["Issuer"],
                Audience = jwtSettings["Audience"],
                SigningCredentials = new SigningCredentials(
                    new SymmetricSecurityKey(key),
                    SecurityAlgorithms.HmacSha256Signature)
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.CreateToken(tokenDescriptor);

            return tokenHandler.WriteToken(token);
        }

        /// <summary>
        /// 映射至 UserDto
        /// </summary>
        private static UserDto MapToUserDto(User user)
        {
            return new UserDto
            {
                UserId = user.UserId,
                Name = user.Name,
                Email = user.Email,
                Department = user.Department,
                Role = user.Role,
                CreatedAt = user.CreatedAt
            };
        }

        /// <summary>
        /// 映射至 UserListDto
        /// </summary>
        private static UserListDto MapToUserListDto(User user)
        {
            return new UserListDto
            {
                UserId = user.UserId,
                Name = user.Name,
                Email = user.Email,
                Department = user.Department,
                Role = user.Role,
                IsActive = user.IsActive,
                CreatedAt = user.CreatedAt,
                LastLoginAt = user.LastLoginAt
            };
        }

        /// <summary>
        /// 獲取所有用戶列表（管理員專用）
        /// </summary>
        public async Task<List<UserListDto>> GetAllUsersAsync()
        {
            try
            {
                _logger.LogInformation("管理員獲取所有用戶列表");

                var users = await _context.Users
                    .OrderByDescending(u => u.CreatedAt)
                    .ToListAsync();

                return users.Select(MapToUserListDto).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "獲取用戶列表發生錯誤");
                throw;
            }
        }

        /// <summary>
        /// 新增用戶（管理員專用）
        /// </summary>
        public async Task<UserListDto?> AdminCreateUserAsync(CreateUserDto request)
        {
            try
            {
                _logger.LogInformation("管理員新增用戶：{Email}", request.Email);

                // 檢查 Email 是否已存在
                if (await _context.Users.AnyAsync(u => u.Email == request.Email))
                {
                    _logger.LogWarning("新增用戶失敗：Email 已被使用 {Email}", request.Email);
                    return null;
                }

                // 建立新用戶
                var user = new User
                {
                    Name = request.Name,
                    Email = request.Email,
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.Password),
                    Department = request.Department,
                    Role = request.Role ?? "User", // 使用指定角色或預設為 User
                    IsActive = true,
                    CreatedAt = DateTime.Now
                };

                _context.Users.Add(user);
                await _context.SaveChangesAsync();

                _logger.LogInformation("管理員新增用戶成功：{Email}, UserId={UserId}, Role={Role}", 
                    user.Email, user.UserId, user.Role);

                return MapToUserListDto(user);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "管理員新增用戶發生錯誤：{Email}", request.Email);
                throw;
            }
        }

        /// <summary>
        /// 更新用戶資訊（管理員專用）
        /// </summary>
        public async Task<UserListDto?> UpdateUserAsync(int userId, UpdateUserDto request)
        {
            try
            {
                _logger.LogInformation("管理員更新用戶資訊：UserId={UserId}", userId);

                // 查詢用戶
                var user = await _context.Users.FindAsync(userId);
                if (user == null)
                {
                    _logger.LogWarning("更新失敗：用戶不存在 UserId={UserId}", userId);
                    return null;
                }

                // 檢查 Email 是否與其他用戶重複
                if (await _context.Users.AnyAsync(u => u.Email == request.Email && u.UserId != userId))
                {
                    _logger.LogWarning("更新失敗：Email 已被其他用戶使用 {Email}", request.Email);
                    throw new ArgumentException($"Email {request.Email} 已被其他用戶使用");
                }

                // 更新用戶資訊
                user.Name = request.Name;
                user.Email = request.Email;
                user.Department = request.Department;
                user.Role = request.Role;
                user.IsActive = request.IsActive;

                await _context.SaveChangesAsync();

                _logger.LogInformation("用戶資訊更新成功：UserId={UserId}", userId);
                return MapToUserListDto(user);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "更新用戶資訊發生錯誤：UserId={UserId}", userId);
                throw;
            }
        }

        /// <summary>
        /// 重置用戶密碼（管理員專用）
        /// </summary>
        public async Task<bool> AdminResetPasswordAsync(int userId, AdminResetPasswordDto request)
        {
            try
            {
                _logger.LogInformation("管理員重置用戶密碼：UserId={UserId}", userId);

                // 查詢用戶
                var user = await _context.Users.FindAsync(userId);
                if (user == null)
                {
                    _logger.LogWarning("重置密碼失敗：用戶不存在 UserId={UserId}", userId);
                    return false;
                }

                // 更新密碼
                user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.NewPassword);
                await _context.SaveChangesAsync();

                _logger.LogInformation("密碼重置成功：UserId={UserId}", userId);
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "重置密碼過程發生錯誤：UserId={UserId}", userId);
                throw;
            }
        }

        /// <summary>
        /// 刪除用戶（管理員專用）- 軟刪除，設為非活躍
        /// </summary>
        public async Task<bool> DeleteUserAsync(int userId)
        {
            try
            {
                _logger.LogInformation("管理員刪除用戶：UserId={UserId}", userId);

                // 查詢用戶
                var user = await _context.Users.FindAsync(userId);
                if (user == null)
                {
                    _logger.LogWarning("刪除失敗：用戶不存在 UserId={UserId}", userId);
                    return false;
                }

                // 軟刪除：設為非活躍
                user.IsActive = false;
                await _context.SaveChangesAsync();

                _logger.LogInformation("用戶刪除成功（軟刪除）：UserId={UserId}", userId);
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "刪除用戶過程發生錯誤：UserId={UserId}", userId);
                throw;
            }
        }
    }
}
