#!/bin/bash

# Check if project name is provided
if [ -z "$1" ]; then
  echo "Usage: ./main_init.sh <project-name>"
  exit 1
fi

PROJECT_NAME=$1

echo "Starting the MVP initialization for project: $PROJECT_NAME"

# Run Phase 1: MVP Setup
echo "==============================="
echo "Running Phase 1: Project Setup"
echo "==============================="
./init_mvp.sh "$PROJECT_NAME"
if [ $? -ne 0 ]; then
  echo "Error: Phase 1 (Project Setup) failed. Exiting."
  exit 1
fi

# Run Phase 2: Version Control Setup
echo "======================================"
echo "Running Phase 2: Version Control Setup"
echo "======================================"
./init_version_control.sh "$PROJECT_NAME"
if [ $? -ne 0 ]; then
  echo "Error: Phase 2 (Version Control Setup) failed. Exiting."
  exit 1
fi

echo "======================================"
echo "MVP initialization for $PROJECT_NAME completed successfully!"
echo "======================================"
