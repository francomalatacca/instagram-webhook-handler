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

if [ -z "$HARNESS_AWS_REGION" ]; then
  export AWS_DEFAULT_REGION="eu-central-1"  # or your default
  echo "⚠️ HARNESS_AWS_REGION is not set. Falling back to AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION"
else
  export AWS_DEFAULT_REGION="$HARNESS_AWS_REGION"
  echo "✅ Using region: $AWS_DEFAULT_REGION"
fi

echo "🚀 Preparing SAM deployment..."

# ✅ Ensure region is available
if [ -z "$HARNESS_AWS_REGION" ]; then
  export AWS_DEFAULT_REGION="eu-central-1"  # fallback default region
  echo "⚠️ HARNESS_AWS_REGION is not set. Using fallback: $AWS_DEFAULT_REGION"
else
  export AWS_DEFAULT_REGION="$HARNESS_AWS_REGION"
  echo "✅ Region set to: $AWS_DEFAULT_REGION"
fi

# ✅ Ensure VerifyToken is available
if [ -z "$HARNESS_VERIFY_TOKEN" ]; then
  export HARNESS_VERIFY_TOKEN="default-token-placeholder"
  echo "⚠️ HARNESS_VERIFY_TOKEN is not set. Using fallback token: $HARNESS_VERIFY_TOKEN"
else
  echo "✅ Verify token loaded."
fi

# ✅ Proceed with deploy
echo "🚀 Deploying SAM stack..."
sam deploy \
  --stack-name instagram-webhook-stack \
  --capabilities CAPABILITY_IAM \
  --region $AWS_DEFAULT_REGION \
  --parameter-overrides VerifyToken=$HARNESS_VERIFY_TOKEN \
  --no-confirm-changeset \
  --no-fail-on-empty-changeset
