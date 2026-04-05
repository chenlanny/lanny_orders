namespace OfficeOrderApi.DTOs
{
    /// <summary>
    /// API 統一回應格式
    /// </summary>
    /// <typeparam name="T">資料類型</typeparam>
    public class ApiResponse<T>
    {
        /// <summary>
        /// 是否成功
        /// </summary>
        public bool Success { get; set; }

        /// <summary>
        /// 訊息
        /// </summary>
        public string Message { get; set; } = string.Empty;

        /// <summary>
        /// 資料內容
        /// </summary>
        public T Data { get; set; }

        /// <summary>
        /// 錯誤詳情（開發模式才回傳）
        /// </summary>
        public string? Error { get; set; }

        /// <summary>
        /// 建立成功回應
        /// </summary>
        public static ApiResponse<T> Ok(T data, string message = "操作成功")
        {
            return new ApiResponse<T>
            {
                Success = true,
                Message = message,
                Data = data
            };
        }

        /// <summary>
        /// 建立失敗回應
        /// </summary>
        public static ApiResponse<T> Fail(string message, string? error = null)
        {
            return new ApiResponse<T>
            {
                Success = false,
                Message = message,
                Error = error
            };
        }
    }
}
