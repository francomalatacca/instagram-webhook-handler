#!/bin/bash
set -e

echo "📦 Verifying AWS SAM CLI is available..."
if ! command -v sam &> /dev/null; then
  echo "❌ SAM CLI not found. Installing via pip..."
  
  # Check if pip is installed
  if ! command -v pip &> /dev/null; then
    echo "❌ pip not found. Attempting to install..."
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3
  fi

  # Install SAM CLI
  pip install aws-sam-cli
else
  echo "✅ SAM CLI is already installed: $(sam --version)"
fi

echo "🔨 Building SAM app..."
sam build

echo "🚀 Deploying SAM stack..."
echo "🧾 Region: ${HARNESS_AWS_REGION}"
echo "🔐 VerifyToken: ${HARNESS_VERIFY_TOKEN}"

echo "🚀 Deploying SAM stack..."
sam deploy \
  --stack-name instagram-webhook-stack \
  --capabilities CAPABILITY_IAM \
  --region "$HARNESS_AWS_REGION" \
  --parameter-overrides VerifyToken="$HARNESS_VERIFY_TOKEN" \
  --no-confirm-changeset \
  --no-fail-on-empty-changeset
