# Build Stage
FROM node:18-alpine AS build
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json yarn.lock ./
RUN yarn install

# Copy source code
COPY . .

# Compile TypeScript
RUN yarn run tsc -b

# Serve Stage
FROM node:18-alpine
WORKDIR /app

# Copy compiled build artifacts
COPY --from=build /app/dist ./dist
COPY package*.json yarn.lock ./

# Install production dependencies
RUN yarn install --production

# Serve the application
CMD ["node", "dist/app.js"]
EXPOSE 3000
