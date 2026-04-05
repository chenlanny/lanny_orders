using System;
using System.ComponentModel.DataAnnotations;

namespace OfficeOrderApi.DTOs
{
    /// <summary>
    /// 登入請求 DTO
    /// </summary>
    public class LoginRequestDto
    {
        [Required(ErrorMessage = "電子郵件為必填")]
        [EmailAddress(ErrorMessage = "電子郵件格式不正確")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "密碼為必填")]
        public string Password { get; set; } = string.Empty;
    }

    /// <summary>
    /// 登入回應 DTO
    /// </summary>
    public class LoginResponseDto
    {
        public string Token { get; set; } = string.Empty;
        public UserDto User { get; set; } = null!;
    }

    /// <summary>
    /// 註冊請求 DTO
    /// </summary>
    public class RegisterRequestDto
    {
        [Required(ErrorMessage = "姓名為必填")]
        [StringLength(50, ErrorMessage = "姓名長度不可超過50字")]
        public string Name { get; set; } = string.Empty;

        [Required(ErrorMessage = "電子郵件為必填")]
        [EmailAddress(ErrorMessage = "電子郵件格式不正確")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "密碼為必填")]
        [StringLength(100, MinimumLength = 6, ErrorMessage = "密碼長度必須在6-100字之間")]
        public string Password { get; set; } = string.Empty;

        [StringLength(50, ErrorMessage = "部門長度不可超過50字")]
        public string? Department { get; set; }
    }

    /// <summary>
    /// 用戶資訊 DTO（不包含密碼）
    /// </summary>
    public class UserDto
    {
        public int UserId { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string? Department { get; set; }
        public string Role { get; set; } = "User";
        public DateTime CreatedAt { get; set; }
    }

    /// <summary>
    /// 密碼變更請求 DTO
    /// </summary>
    public class ChangePasswordRequestDto
    {
        [Required(ErrorMessage = "目前密碼為必填")]
        public string OldPassword { get; set; } = string.Empty;

        [Required(ErrorMessage = "新密碼為必填")]
        [StringLength(100, MinimumLength = 6, ErrorMessage = "密碼長度必須在6-100字之間")]
        public string NewPassword { get; set; } = string.Empty;
    }

    /// <summary>
    /// 管理員新增用戶 DTO
    /// </summary>
    public class CreateUserDto
    {
        [Required(ErrorMessage = "姓名為必填")]
        [StringLength(50, ErrorMessage = "姓名長度不可超過50字")]
        public string Name { get; set; } = string.Empty;

        [Required(ErrorMessage = "電子郵件為必填")]
        [EmailAddress(ErrorMessage = "電子郵件格式不正確")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "密碼為必填")]
        [StringLength(100, MinimumLength = 6, ErrorMessage = "密碼長度必須在6-100字之間")]
        public string Password { get; set; } = string.Empty;

        [StringLength(50, ErrorMessage = "部門長度不可超過50字")]
        public string? Department { get; set; }

        [StringLength(50, ErrorMessage = "角色長度不可超過50字")]
        public string Role { get; set; } = "User";
    }

    /// <summary>
    /// 管理員更新用戶資訊 DTO
    /// </summary>
    public class UpdateUserDto
    {
        [Required(ErrorMessage = "姓名為必填")]
        [StringLength(50, ErrorMessage = "姓名長度不可超過50字")]
        public string Name { get; set; } = string.Empty;

        [Required(ErrorMessage = "電子郵件為必填")]
        [EmailAddress(ErrorMessage = "電子郵件格式不正確")]
        public string Email { get; set; } = string.Empty;

        [StringLength(50, ErrorMessage = "部門長度不可超過50字")]
        public string? Department { get; set; }

        [Required(ErrorMessage = "角色為必填")]
        [StringLength(50, ErrorMessage = "角色長度不可超過50字")]
        public string Role { get; set; } = "User";

        public bool IsActive { get; set; } = true;
    }

    /// <summary>
    /// 管理員重置用戶密碼 DTO
    /// </summary>
    public class AdminResetPasswordDto
    {
        [Required(ErrorMessage = "新密碼為必填")]
        [StringLength(100, MinimumLength = 6, ErrorMessage = "密碼長度必須在6-100字之間")]
        public string NewPassword { get; set; } = string.Empty;
    }

    /// <summary>
    /// 用戶列表 DTO（包含 IsActive 和 LastLoginAt）
    /// </summary>
    public class UserListDto
    {
        public int UserId { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string? Department { get; set; }
        public string Role { get; set; } = "User";
        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? LastLoginAt { get; set; }
    }
}
