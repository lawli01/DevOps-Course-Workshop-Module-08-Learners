# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /source

# Install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

# Copy source code to container
COPY ./ /source/
WORKDIR /source/DotnetTemplate.Web
RUN npm install
RUN npm run build
WORKDIR /source

# copy csproj and restore as distinct layers
RUN dotnet restore

# copy and publish app and libraries
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "DotnetTemplate.Web.dll"]