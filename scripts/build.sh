#!/bin/bash
set -e

# Install Python (if needed)
if ! command -v python3 &> /dev/null; then
  echo "Installing Python..."
  apt-get update && apt-get install -y python3 python3-pip
fi

# Use pip3 instead of pip (more portable)
echo "Installing AWS SAM CLI..."
pip3 install aws-sam-cli

# Confirm install
echo "SAM CLI version:"
sam --version

echo "Building the SAM application..."
sam build
