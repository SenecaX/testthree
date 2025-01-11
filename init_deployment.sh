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
echo "Creating Dockerfiles..."

# Frontend Dockerfile
if [ -d "front" ]; then
  echo "FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN yarn install
COPY . .
RUN yarn build
CMD [\"npx\", \"serve\", \"-s\", \"dist\", \"-l\", \"5000\"]
EXPOSE 5000
" > front/Dockerfile
  echo "Frontend Dockerfile created."
else
  echo "Error: Frontend directory does not exist. Skipping Frontend Dockerfile."
fi

# Backend Dockerfile
if [ -d "back" ]; then
  echo "FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN yarn install
COPY . .
CMD [\"node\", \"src/app.js\"]
EXPOSE 3000
" > back/Dockerfile
  echo "Backend Dockerfile created."
else
  echo "Error: Backend directory does not exist. Skipping Backend Dockerfile."
fi

# Step 2: Create Docker Compose File
echo "Creating docker-compose.yml..."
echo "version: \"3.9\"
services:
  frontend:
    build: ./front
    ports:
      - \"80:5000\"
  backend:
    build: ./back
    ports:
      - \"3000:3000\"
" > docker-compose.yml
echo "docker-compose.yml created."

# Step 3: Configure GitHub Actions Workflow
echo "Setting up GitHub Actions workflow for CI/CD..."
mkdir -p .github/workflows
echo "name: CI/CD Pipeline

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
" > .github/workflows/deploy.yml
echo "GitHub Actions workflow created."

echo "Deployment environment setup for $PROJECT_NAME completed!"
