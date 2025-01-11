#!/bin/bash

# Check if project name is provided
if [ -z "$1" ]; then
  echo "Usage: ./init_dev_env.sh <project-name>"
  exit 1
fi

PROJECT_NAME=$1

echo "Setting up development environment for $PROJECT_NAME..."

# Navigate to the project directory
if [ ! -d "$PROJECT_NAME" ]; then
  echo "Error: Project directory $PROJECT_NAME does not exist. Ensure Phase 1 and Phase 2 have completed successfully."
  exit 1
fi
cd "$PROJECT_NAME"

# Step 1: Frontend Tools Setup
echo "Configuring Frontend tools..."
if [ -d "front" ]; then
  cd front
  # Install ESLint, Prettier, and lint-staged
  yarn add eslint prettier lint-staged husky --dev
  yarn eslint --init # Initializes ESLint interactively

  # Create Prettier config
  cat <<EOL > .prettierrc
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "all"
}
EOL

  # Update package.json for lint-staged and Husky
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
  cd ..
else
  echo "Error: Frontend directory does not exist. Skipping frontend tools setup."
fi

# Step 2: Backend Tools Setup
echo "Configuring Backend tools..."
if [ -d "back" ]; then
  cd back
  # Install nodemon for live reloading
  yarn add nodemon --dev

  # Install Jest and TypeScript support for testing
  yarn add jest @types/jest ts-jest --dev
  npx ts-jest config:init # Initializes Jest configuration for TypeScript
  cd ..
else
  echo "Error: Backend directory does not exist. Skipping backend tools setup."
fi

# Step 3: Shared Tools Setup
echo "Setting up shared tools..."
# Install and configure Husky in the root directory
yarn add husky --dev
npx husky install
npx husky add .husky/pre-commit "npx lint-staged"

echo "Development environment setup for $PROJECT_NAME completed!"
