#!/bin/bash
set -e

echo "Deploying the SAM stack..."
sam deploy \
  --stack-name instagram-webhook-stack \
  --capabilities CAPABILITY_IAM \
  --region "$HARNESS_AWS_REGION" \
  --parameter-overrides VerifyToken="$HARNESS_VERIFY_TOKEN" \
  --no-confirm-changeset
