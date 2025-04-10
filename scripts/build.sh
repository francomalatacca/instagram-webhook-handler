#!/bin/bash
set -e

echo "🧠 Environment Information"
echo "-----------------------------"
echo "🐧 OS:"
uname -a
echo "📂 Current Directory:"
pwd
echo "📦 Disk Space:"
df -h
echo "👤 User:"
whoami
echo "🌐 Network:"
ip addr || ifconfig || echo "No network tool found"
echo "💻 CPU Info:"
nproc || echo "nproc not found"
echo "🐍 Python:"
python3 --version 2>/dev/null || echo "python3 not installed"
echo "📦 Pip:"
pip3 --version 2>/dev/null || echo "pip3 not installed"
echo "🐳 Docker:"
docker --version 2>/dev/null || echo "Docker not installed"
echo "🗂️ Installed Packages:"
if command -v apt &> /dev/null; then
  dpkg -l | grep -E 'python|pip|sam' || echo "No relevant packages"
elif command -v apk &> /dev/null; then
  apk info || echo "No apk info available"
else
  echo "⚠️ Package manager unknown"
fi
echo "-----------------------------"

echo "🔍 Checking for python3..."
if ! command -v python3 &> /dev/null; then
  echo "📦 Installing Python 3..."
  if command -v apt-get &> /dev/null; then
    apt-get update && apt-get install -y python3
  elif command -v apk &> /dev/null; then
    apk update && apk add python3
  else
    echo "❌ No supported package manager found to install python3"
    exit 1
  fi
fi

echo "🔍 Checking for pip3..."
if ! command -v pip3 &> /dev/null; then
  echo "📦 Installing pip3..."
  if command -v apt-get &> /dev/null; then
    apt-get install -y python3-pip
  elif command -v apk &> /dev/null; then
    apk add py3-pip
  else
    echo "❌ No supported package manager found to install pip3"
    exit 1
  fi
fi

echo "🔧 Upgrading pip..."
pip3 install --upgrade pip

echo "📦 Installing AWS SAM CLI..."
pip3 install aws-sam-cli

echo "🧪 SAM CLI version:"
sam --version

echo "🔨 Building SAM app..."
sam build
