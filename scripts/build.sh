#!/bin/bash
set -e

# Only install if not already available
if ! command -v python3 &> /dev/null; then
  echo "Installing Python 3 and pip..."
  apt-get update && apt-get install -y python3 python3-pip
fi

echo "Installing AWS SAM CLI..."
pip3 install aws-sam-cli

echo "SAM version:"
sam --version

echo "Building SAM app..."
sam build
