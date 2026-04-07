# ================================
# 飲料訂購系統 - 後端 Dockerfile
# 適用於 Render.com 部署
# ================================

# 使用較新的 SDK 版本以獲得更好的構建穩定性
FROM mcr.microsoft.com/dotnet/sdk:3.1.426 AS build
WORKDIR /src

# 複製專案檔案
COPY ["OfficeOrderApi.csproj", "./"]

# 還原套件
RUN dotnet restore "OfficeOrderApi.csproj"

# 複製所有源代碼
COPY . .

# 構建應用程式
RUN dotnet build "OfficeOrderApi.csproj" -c Release -o /app/build

# 發佈應用程式
FROM build AS publish
RUN dotnet publish "OfficeOrderApi.csproj" -c Release -o /app/publish

# ================================
# 運行時階段
FROM mcr.microsoft.com/dotnet/aspnet:3.1.32
WORKDIR /app

# 複製編譯結果
COPY --from=publish /app/publish .

# 設定環境變數
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:5000

# 公開端口
EXPOSE 5000

# 啟動應用程式
ENTRYPOINT ["dotnet", "OfficeOrderApi.dll"]

# 設定環境變數
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:5000

# 暴露端口（Render.com 會自動映射）
EXPOSE 5000

# 啟動應用程式
ENTRYPOINT ["dotnet", "OfficeOrderApi.dll"]
