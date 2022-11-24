#Stage 1: Define base image that will be used for production
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

#Stage 2: Build and publish the code
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /app
COPY WebAPI/WebAPI.csproj .
RUN dotnet restore 
COPY . .

FROM build AS publish
RUN dotnet publish -c Release -o /publish

#Stage 3: Build and publish the code
FROM base AS final
WORKDIR /app
COPY --from=publish /publish .
HEALTHCHECK CMD curl --fail http://localhost:8080/ || exit 1
ENTRYPOINT ["dotnet", "WebAPI.dll"]
