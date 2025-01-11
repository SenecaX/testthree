#!/bin/bash

# Check if project name is provided
if [ -z "$1" ]; then
  echo "Usage: ./init_deployment.sh <project-name>"
  exit 1
fi

PROJECT_NAME=$1

echo "Setting up deployment environment for $PROJECT_NAME..."

# Navigate to project directory
if [ ! -d "$PROJECT_NAME" ]; then
  echo "Error: Project directory $PROJECT_NAME does not exist. Ensure previous phases are completed."
  exit 1
fi
cd "$PROJECT_NAME"

# Step 1: Create Dockerfiles for Frontend and Backend
echo "Creating Dockerfiles and updating tsconfig.json..."

# Frontend Setup
if [ -d "front" ]; then
  echo "Updating tsconfig.json for frontend..."
  cat <<EOL > front/tsconfig.json
{
  "compilerOptions": {
    "target": "ES6",
    "module": "ESNext",
    "jsx": "react-jsx",
    "allowImportingTsExtensions": true,
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
EOL

  echo "Creating Frontend Dockerfile..."
  cat <<EOL > front/Dockerfile
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
EOL
  echo "Frontend Dockerfile created."
else
  echo "Error: Frontend directory does not exist. Skipping Frontend Dockerfile."
fi

# Backend Setup
if [ -d "back" ]; then
  echo "Creating Backend Dockerfile..."
  cat <<EOL > back/Dockerfile
# Build Stage
FROM node:18-alpine AS build
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json yarn.lock ./
RUN yarn install

# Copy source code
COPY . .

# Serve Stage
FROM node:18-alpine
WORKDIR /app

# Copy build artifacts
COPY --from=build /app .

# Serve the application
CMD ["node", "dist/app.js"]
EXPOSE 3000
EOL
  echo "Backend Dockerfile created."
else
  echo "Error: Backend directory does not exist. Skipping Backend Dockerfile."
fi

# Step 2: Create Docker Compose File
echo "Creating docker-compose.yml..."
cat <<EOL > docker-compose.yml
version: "3.9"
services:
  frontend:
    build: ./front
    ports:
      - "80:5000"
  backend:
    build: ./back
    ports:
      - "3000:3000"
EOL
echo "docker-compose.yml created."

# Step 3: Configure GitHub Actions Workflow
echo "Setting up GitHub Actions workflow for CI/CD..."
mkdir -p .github/workflows
cat <<EOL > .github/workflows/deploy.yml
name: CI/CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Set up Docker
        uses: docker/setup-buildx-action@v2

      - name: Build and push Docker images
        run: |
          docker build -t frontend ./front
          docker build -t backend ./back

      - name: Deploy to Hetzner
        env:
          SSH_KEY: \${{ secrets.SSH_KEY }}
          VM_IP: \${{ secrets.VM_IP }}
        run: |
          scp docker-compose.yml user@\${{ env.VM_IP }}:/home/user/$PROJECT_NAME/
          ssh user@\${{ env.VM_IP }} 'cd /home/user/$PROJECT_NAME && docker-compose up -d'
EOL
echo "GitHub Actions workflow created."

echo "Deployment environment setup for $PROJECT_NAME completed successfully!"
