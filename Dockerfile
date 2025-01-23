# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["GitHubActionsUsageExample.csproj", "GitHubActionsUsageExample/"]
RUN dotnet restore "GitHubActionsUsageExample/GitHubActionsUsageExample.csproj"

WORKDIR "/src/GitHubActionsUsageExample"
COPY . .
RUN dotnet build "GitHubActionsUsageExample.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "GitHubActionsUsageExample.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "GitHubActionsUsageExample.dll"]
