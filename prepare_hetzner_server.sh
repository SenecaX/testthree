#!/bin/bash

# Check if server IP and SSH credentials are provided
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: ./prepare_hetzner_server.sh <server-ip> <ssh-username>"
  exit 1
fi

SERVER_IP=$1
SSH_USER=$2

echo "Preparing Hetzner server at $SERVER_IP..."

# Step 1: SSH into the server and update packages
ssh $SSH_USER@$SERVER_IP <<EOF
  echo "Updating system packages..."
  sudo apt update && sudo apt upgrade -y

  # Step 2: Install Docker
  echo "Checking Docker installation..."
  if ! command -v docker &>/dev/null; then
    echo "Installing Docker..."
    sudo apt install -y docker.io
    sudo systemctl enable docker
    sudo systemctl start docker
  else
    echo "Docker is already installed."
  fi

  # Step 3: Install Docker Compose
  echo "Checking Docker Compose installation..."
  if ! command -v docker-compose &>/dev/null; then
    echo "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  else
    echo "Docker Compose is already installed."
  fi

  # Step 4: Install NGINX (optional)
  echo "Installing NGINX..."
  sudo apt install -y nginx
  sudo systemctl enable nginx
  sudo systemctl start nginx

  # Step 5: Configure firewall (UFW)
  echo "Configuring UFW..."
  sudo apt install -y ufw
  sudo ufw allow OpenSSH
  sudo ufw allow 'Nginx Full'
  sudo ufw enable

  echo "Hetzner server preparation complete!"
EOF
