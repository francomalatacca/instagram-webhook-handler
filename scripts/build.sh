#!/bin/bash
set -e

echo "Installing AWS SAM CLI..."
pip install aws-sam-cli

echo "Building the SAM application..."
sam build
