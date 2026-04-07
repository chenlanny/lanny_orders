# ================================
# 飲料訂購系統 - 後端 Dockerfile
# 適用於 Render.com 部署
# ================================

# 構建階段
FROM mcr.microsoft.com/dotnet/sdk:3.1 AS builder
WORKDIR /src

# 複製專案檔案並還原
COPY OfficeOrderApi.csproj .
RUN dotnet restore OfficeOrderApi.csproj

# 複製原始碼
COPY . .

# 發佈（不需要分開 build 和 publish）
RUN dotnet publish -c Release -o /app/out

# 運行時階段
FROM mcr.microsoft.com/dotnet/aspnet:3.1
WORKDIR /app

# 複製發佈結果
COPY --from=builder /app/out .

# 環境變數
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:5000

EXPOSE 5000
ENTRYPOINT ["dotnet", "OfficeOrderApi.dll"]

# 設定環境變數
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:5000

# 暴露端口（Render.com 會自動映射）
EXPOSE 5000

# 啟動應用程式
ENTRYPOINT ["dotnet", "OfficeOrderApi.dll"]
