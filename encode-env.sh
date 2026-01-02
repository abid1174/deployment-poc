#!/bin/bash

# Helper script to encode environment variables as JSON and then base64
# Usage: ./encode-env.sh

echo "=== Base64 Encoder for GitHub Secrets ==="
echo ""
echo "Enter values to encode (press Enter for each):"
echo ""

read -p "PORT (e.g., 3000): " PORT
read -p "NODE_ENV (e.g., development): " NODE_ENV
read -p "API_KEY (e.g., your-secret-key): " API_KEY

echo ""
echo "=== Creating JSON and encoding to base64 ==="
echo ""

# Create JSON object
JSON_OBJECT=$(jq -n \
  --arg port "$PORT" \
  --arg node_env "$NODE_ENV" \
  --arg api_key "$API_KEY" \
  '{PORT: $port, NODE_ENV: $node_env, API_KEY: $api_key}')

echo "JSON Object:"
echo "$JSON_OBJECT" | jq '.'

echo ""
echo "=== Base64 Encoded Value ==="
echo ""

# Encode JSON to base64
ENCODED=$(echo -n "$JSON_OBJECT" | base64)
echo "DEPLOYMENT_POC_ENV_VARS: $ENCODED"

echo ""
echo "=== Copy this value to GitHub Repository Settings → Environments → Secrets ==="
echo "Secret Name: DEPLOYMENT_POC_ENV_VARS"
echo "Secret Value: $ENCODED"

