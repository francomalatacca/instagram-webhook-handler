#!/bin/bash
set -e

# Fix for SAM runtime python3.11 validation
echo "🔧 Checking for python3.11 compatibility..."
if ! command -v python3.11 &> /dev/null; then
  echo "⚙️ Adding python3.11 symlink to PATH..."
  ln -s $(which python3) /usr/bin/python3.11 || true
fi

echo "🚀 Deploying the SAM stack..."
sam deploy --guided
