#!/bin/bash

# Load environment variables from .env file
if [ ! -f .env ]; then
  echo "Error: .env file not found! Create one with the required variables."
  exit 1
fi

# Export variables from .env
export $(grep -v '^#' .env | xargs)

# Check required variables
if [ -z "$VM_IP" ] || [ -z "$SSH_USER" ] || [ -z "$PROJECT_NAME" ] || [ -z "$SSH_KEY_PATH" ]; then
  echo "Error: Missing required environment variables in .env file."
  exit 1
fi

# Ensure SSH key exists
if [ ! -f "$SSH_KEY_PATH" ]; then
  echo "Error: SSH key not found at $SSH_KEY_PATH."
  exit 1
fi

echo "Starting deployment to Hetzner server at $VM_IP..."

# Step 1: SSH into the server and prepare it
ssh -i "$SSH_KEY_PATH" $SSH_USER@$VM_IP <<EOF
  echo "Updating system packages..."
  sudo apt update && sudo apt upgrade -y

  echo "Installing Git..."
  sudo apt install -y git

  echo "Installing Docker..."
  if ! command -v docker &>/dev/null; then
    sudo apt install -y docker.io
    sudo systemctl enable docker
    sudo systemctl start docker
  else
    echo "Docker is already installed."
  fi

  echo "Installing Docker Compose..."
  if ! command -v docker-compose &>/dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-\$(uname -s)-\$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  else
    echo "Docker Compose is already installed."
  fi

  echo "Server preparation complete!"
EOF

# Step 2: Clone the GitHub repository
ssh -i "$SSH_KEY_PATH" $SSH_USER@$VM_IP <<EOF
  echo "Cloning repository..."
  if [ ! -d "$PROJECT_NAME" ]; then
    git clone $GITHUB_REPO $PROJECT_NAME
  else
    echo "Repository already exists. Pulling latest changes..."
    cd $PROJECT_NAME
    git pull
  fi
EOF

# Step 3: Build and run the application using Docker Compose
ssh -i "$SSH_KEY_PATH" $SSH_USER@$VM_IP <<EOF
  echo "Building and running the application..."
  cd $PROJECT_NAME
  docker-compose up -d
  echo "Application is now running!"
EOF

echo "Deployment to Hetzner server complete!"
