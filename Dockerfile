FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["src/DockerDucks.Api/DockerDucks.Api.csproj", "src/DockerDucks.Api/"]
RUN dotnet restore "src/DockerDucks.Api/DockerDucks.Api.csproj"

COPY src/DockerDucks.Api/ src/DockerDucks.Api/
WORKDIR /src/src/DockerDucks.Api
RUN dotnet publish "DockerDucks.Api.csproj" -c Release -o /app/publish --no-restore /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
USER $APP_UID

COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "DockerDucks.Api.dll"]
