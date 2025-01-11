#!/bin/bash

# Check if project name is provided
if [ -z "$1" ]; then
  echo "Usage: ./init_mvp.sh <project-name>"
  exit 1
fi

PROJECT_NAME=$1

echo "Initializing MVP environment for $PROJECT_NAME..."

# Create the main project folder
mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Frontend setup
echo "Setting up Frontend..."
mkdir front
cd front
yarn create vite . --template react-ts
mkdir -p src/{components,pages,features}

# Overwrite tsconfig.json for frontend
cat <<EOL > tsconfig.json
{
  "compilerOptions": {
    "target": "ES6",
    "module": "ESNext",
    "moduleResolution": "node",
    "strict": true,
    "jsx": "react",
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "baseUrl": "./src",
    "paths": {
      "@components/*": ["components/*"],
      "@pages/*": ["pages/*"],
      "@features/*": ["features/*"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
EOL

cat <<EOL > src/App.tsx
import React from 'react';

const App: React.FC = () => {
    return <h1>Hello MVP!</h1>;
};

export default App;
EOL
cd ..

# Backend setup
echo "Setting up Backend..."
mkdir back
cd back
yarn init -y
yarn add express typescript ts-node dotenv
yarn add @types/express --dev
mkdir -p src/{controllers,services,models}

# Overwrite tsconfig.json with required settings for backend
cat <<EOL > tsconfig.json
{
  "compilerOptions": {
    "target": "ES6",
    "module": "commonjs",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
EOL

# Add build script to package.json
if command -v jq &>/dev/null; then
  # Using jq if installed
  jq '.scripts.build = "tsc"' package.json > temp.json && mv temp.json package.json
else
  # Using node if jq is not installed
  node -e "let pkg = require('./package.json'); pkg.scripts = { ...pkg.scripts, build: 'tsc' }; require('fs').writeFileSync('./package.json', JSON.stringify(pkg, null, 2));"
fi

cat <<EOL > src/app.ts
import express, { Request, Response } from 'express';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.get('/', (req: Request, res: Response) => {
    res.send('Hello MVP!');
});

app.listen(port, () => {
    console.log(\`Server running on port \${port}\`);
});
EOL
cd ..

# Environment setup
echo "Creating .env and .env.example files..."
cat <<EOL > .env
NODE_ENV=development
PORT=3000
DB_URI=mongodb://localhost:27017/$PROJECT_NAME
EOL

cp .env .env.example
sed -i '' 's/3000/<PORT>/g' .env.example || sed -i 's/3000/<PORT>/g' .env.example
sed -i '' "s/mongodb:\/\/localhost:27017\/$PROJECT_NAME/<DB_URI>/g" .env.example || sed -i "s/mongodb:\/\/localhost:27017\/$PROJECT_NAME/<DB_URI>/g" .env.example

echo "MVP setup for $PROJECT_NAME is complete!"
