FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /src
EXPOSE 80
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["WebAPI/WebAPI.csproj", "WebAPI/"]
RUN dotnet restore "./WebAPI.csproj"
COPY . "WebAPI/"
WORKDIR "/src/WebAPI"
RUN dotnet build "WebAPI.csproj" -c Release -o /src/build
FROM build AS publish
RUN dotnet publish "WebAPI.csproj" -c Release -o /src/publish
FROM base AS final
WORKDIR /src
COPY --from=publish /src/publish .
ENTRYPOINT ["dotnet", "WebAPI.dll"]
