# ================================
# 飲料訂購系統 - 後端 Dockerfile
# 適用於 Render.com 部署
# ================================

# 構建階段 - 使用被驗證穩定的版本
FROM mcr.microsoft.com/dotnet/sdk:3.1.425-alpine3.16 AS builder
WORKDIR /src

# 增加超時時間並配置 NuGet
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1

# 複製專案檔案
COPY OfficeOrderApi.csproj .

# 還原 - 禁用並行下載以提高穩定性
RUN dotnet restore OfficeOrderApi.csproj --disable-parallel

# 複製原始碼
COPY . .

# 發佈 - 添加超時配置
RUN dotnet publish -c Release -o /app/out --packages /var/cache/nuget

# 運行時階段
FROM mcr.microsoft.com/dotnet/aspnet:3.1.32-alpine3.16
WORKDIR /app

# 複製發佈結果
COPY --from=builder /app/out .

# 環境變數
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:5000

# 暴露端口
EXPOSE 5000

# 啟動應用程式
ENTRYPOINT ["dotnet", "OfficeOrderApi.dll"]
