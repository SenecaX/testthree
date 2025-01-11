#!/bin/bash

# Check if project name is provided
if [ -z "$1" ]; then
  echo "Usage: ./init_dev_env.sh <project-name>"
  exit 1
fi

PROJECT_NAME=$1

echo "Setting up development environment for $PROJECT_NAME..."

# Navigate to the project directory
cd "$PROJECT_NAME" || { echo "Error: Project directory $PROJECT_NAME does not exist."; exit 1; }

# Step 1: Frontend Tools Setup
echo "Configuring Frontend tools..."
cd front || { echo "Error: Frontend directory does not exist."; exit 1; }

# Install ESLint, Prettier, and lint-staged
yarn add eslint prettier lint-staged husky --dev
yarn eslint --init # Initializes ESLint with basic configuration

# Create Prettier config
cat <<EOL > .prettierrc
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "all"
}
EOL

# Update package.json for lint-staged
npx husky install
npx husky add .husky/pre-commit "npx lint-staged"
cat <<EOL > lint-staged.config.js
module.exports = {
  "**/*.{js,ts,tsx,json,css,scss,md}": [
    "prettier --write",
    "eslint --fix"
  ]
};
EOL

# Step 2: Backend Tools Setup
echo "Configuring Backend tools..."
cd ../back || { echo "Error: Backend directory does not exist."; exit 1; }

# Install nodemon for live reloading
yarn add nodemon --dev

# Install Jest and @types/jest for TypeScript testing
yarn add jest @types/jest ts-jest --dev
npx ts-jest config:init # Initializes Jest configuration for TypeScript

# Step 3: Shared Tools Setup
echo "Setting up shared tools..."

# Navigate to project root
cd ..

# Install and configure Husky in both front and back
echo "Configuring Husky for pre-commit hooks..."
yarn add husky --dev
npx husky install
npx husky add .husky/pre-commit "npx lint-staged"

echo "Development environment setup for $PROJECT_NAME completed!"
