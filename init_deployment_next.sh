#!/bin/bash

# Load environment variables
if [ ! -f .env ]; then
  echo "Error: .env file not found."
  exit 1
fi
source .env

# Check required environment variables
if [ -z "$VM_IP" ] || [ -z "$SSH_USER" ] || [ -z "$PROJECT_NAME" ]; then
  echo "Error: Missing required environment variables (VM_IP, SSH_USER, PROJECT_NAME)."
  exit 1
fi

echo "Setting up deployment environment for $PROJECT_NAME on Hetzner VM ($VM_IP)..."

# Navigate to project directory
if [ ! -d "$PROJECT_NAME" ]; then
  echo "Error: Project directory $PROJECT_NAME does not exist. Ensure previous phases are completed."
  exit 1
fi
cd "$PROJECT_NAME"

# Rest of your script (Dockerfile creation, docker-compose.yml, etc.)

# Deployment steps using .env variables
echo "Deploying to Hetzner VM..."
scp docker-compose.yml $SSH_USER@$VM_IP:/home/$SSH_USER/$PROJECT_NAME/
ssh $SSH_USER@$VM_IP <<EOF
  cd /home/$SSH_USER/$PROJECT_NAME
  docker-compose up -d
EOF

echo "Deployment to Hetzner VM ($VM_IP) completed successfully!"
