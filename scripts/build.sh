#!/bin/bash
set -e

# Install Python 3 and pip3 if missing
if ! command -v python3 &> /dev/null; then
  echo "🔧 Installing Python 3 and pip..."
  apt-get update && apt-get install -y python3 python3-pip
fi

# Use pip3 always
echo "📦 Installing AWS SAM CLI..."
pip3 install aws-sam-cli

echo "🧪 SAM CLI version:"
sam --version

echo "🔨 Building the SAM application..."
sam build
