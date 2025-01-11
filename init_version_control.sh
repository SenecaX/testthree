#!/bin/bash

# Check if project name is provided
if [ -z "$1" ]; then
  echo "Usage: ./init_version_control.sh <project-name>"
  exit 1
fi

PROJECT_NAME=$1

echo "Setting up version control for $PROJECT_NAME..."

# Step 1: Initialize Git
echo "Initializing Git repository..."
git init
if [ $? -ne 0 ]; then
  echo "Error: Failed to initialize Git repository."
  exit 1
fi

# Step 2: Create .gitignore
echo "Creating .gitignore..."
cat <<EOL > .gitignore
# Node.js
node_modules/
.env
.DS_Store
EOL

# Step 3: Add and commit initial files
echo "Staging and committing initial files..."
git add .
git commit -m "Initial commit"
if [ $? -ne 0 ]; then
  echo "Error: Failed to create initial commit."
  exit 1
fi

# Step 4: Check GitHub Authentication
echo "Checking GitHub authentication..."
gh auth status
if [ $? -ne 0 ]; then
  echo "GitHub CLI is not authenticated. Initiating login..."
  gh auth login
  if [ $? -ne 0 ]; then
    echo "Error: Failed to authenticate with GitHub CLI."
    exit 1
  fi
fi

# Step 5: Create GitHub Repository
echo "Creating GitHub repository..."
gh repo create "$PROJECT_NAME" --public --source=. --remote=origin
if [ $? -ne 0 ]; then
  echo "Error: Failed to create GitHub repository."
  exit 1
fi

# Step 6: Push initial commit to main branch
echo "Pushing initial commit to main branch..."
git branch -M main
git push -u origin main
if [ $? -ne 0 ]; then
  echo "Error: Failed to push main branch to GitHub."
  exit 1
fi

# Step 7: Create and push additional branches
echo "Creating and pushing dev and staging branches..."
git branch dev
git branch staging
git push origin dev
git push origin staging
if [ $? -ne 0 ]; then
  echo "Error: Failed to push branches to GitHub."
  exit 1
fi

echo "Version control setup for $PROJECT_NAME is complete!"
