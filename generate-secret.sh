#!/bin/bash

# Quick script to generate base64-encoded JSON for GitHub secret
# Usage: ./generate-secret.sh

echo "=== GitHub Secret Generator ==="
echo ""
echo "Enter your environment variables:"
echo ""

read -p "PORT (default: 3000): " PORT
PORT=${PORT:-3000}

read -p "NODE_ENV (default: development): " NODE_ENV
NODE_ENV=${NODE_ENV:-development}

read -p "API_KEY: " API_KEY

if [ -z "$API_KEY" ]; then
  echo "ERROR: API_KEY is required"
  exit 1
fi

# Create JSON object
JSON_OBJECT=$(jq -n \
  --arg port "$PORT" \
  --arg node_env "$NODE_ENV" \
  --arg api_key "$API_KEY" \
  '{PORT: $port, NODE_ENV: $node_env, API_KEY: $api_key}')

echo ""
echo "=== JSON Object ==="
echo "$JSON_OBJECT" | jq '.'

echo ""
echo "=== Base64 Encoded (for GitHub Secret) ==="
ENCODED=$(echo -n "$JSON_OBJECT" | base64)
echo "$ENCODED"

echo ""
echo "=== Instructions ==="
echo "1. Copy the base64 string above"
echo "2. Go to: GitHub Repository → Settings → Environments"
echo "3. Select your environment (development or production)"
echo "4. Add secret named: DEPLOYMENT_POC_ENV_VARS"
echo "5. Paste the base64 string as the value"
echo ""

