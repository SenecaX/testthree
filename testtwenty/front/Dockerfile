# Build Stage
FROM node:18-alpine AS build
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json yarn.lock ./
RUN yarn install

# Copy source code and build the application using Vite
COPY . .
RUN yarn run vite build

# Serve Stage
FROM node:18-alpine
WORKDIR /app

# Copy build artifacts from the previous stage
COPY --from=build /app/dist ./dist

# Install the static file server
RUN yarn global add serve

# Serve the application
CMD ["serve", "-s", "dist", "-l", "5000"]
EXPOSE 5000
