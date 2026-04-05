# ================================
# 飲料訂購系統 - 後端 Dockerfile
# 適用於 Render.com 部署
# ================================

# 階段 1: 建置階段
FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /app

# 複製專案檔案並還原套件
COPY OfficeOrderApi.csproj ./
RUN dotnet restore

# 複製所有原始碼
COPY . ./

# 建置應用程式（Release 模式）
RUN dotnet publish -c Release -o /app/publish

# ================================
# 階段 2: 運行階段
FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS runtime
WORKDIR /app

# 從建置階段複製編譯結果
COPY --from=build /app/publish .

# 設定環境變數
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:5000

# 暴露端口（Render.com 會自動映射）
EXPOSE 5000

# 啟動應用程式
ENTRYPOINT ["dotnet", "OfficeOrderApi.dll"]
