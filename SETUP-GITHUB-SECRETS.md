# Setting Up GitHub Environment Secrets

## Quick Setup Guide

### Step 1: Create the JSON Object

Create a JSON object with your environment variables:

```json
{
  "PORT": "3000",
  "NODE_ENV": "development",
  "API_KEY": "your-secret-api-key-here"
}
```

### Step 2: Encode to Base64

```bash
# Option 1: Using the helper script
./encode-env.sh

# Option 2: Manual encoding
echo -n '{"PORT":"3000","NODE_ENV":"development","API_KEY":"your-secret-api-key"}' | base64
```

Example output:
```
eyJQT1JUIjoiMzAwMCIsIk5PREVfRU5WIjoiZGV2ZWxvcG1lbnQiLCJBUElfS0VZIjoieW91ci1zZWNyZXQtYXBpLWtleSJ9
```

### Step 3: Add to GitHub

1. Go to your repository on GitHub
2. Click **Settings** → **Environments**
3. Create environments if they don't exist:
   - `development` (for develop branch and PRs)
   - `production` (for main/master branch)
4. For each environment:
   - Click on the environment name
   - Under **Secrets**, click **Add secret**
   - Name: `DEPLOYMENT_POC_ENV_VARS` (exact match, case-sensitive)
   - Value: Paste the base64-encoded string from Step 2
   - Click **Add secret**

### Step 4: Verify

Run the "Test Environment Variables" workflow:
1. Go to **Actions** tab
2. Select **"Test Environment Variables"** workflow
3. Click **"Run workflow"**
4. Select the branch and environment
5. Click **"Run workflow"**

## Important Notes

- **Secret name must be exactly**: `DEPLOYMENT_POC_ENV_VARS` (case-sensitive)
- **Environments must match**: The workflow uses `development` for non-main branches and `production` for main/master
- **Base64 encoding**: The entire JSON object must be base64-encoded, not individual values
- **JSON format**: Use double quotes for keys and string values

## Troubleshooting

### Secret not found error

If you see "DEPLOYMENT_POC_ENV_VARS secret is not set or empty":
1. Verify the environment name matches (check workflow logs for "Environment name")
2. Verify the secret name is exactly `DEPLOYMENT_POC_ENV_VARS`
3. Make sure you added the secret to the correct environment
4. Check that the secret value is not empty

### Invalid JSON error

If you see "Decoded value is not valid JSON":
1. Verify your base64 string is correct
2. Test decoding locally: `echo "YOUR_BASE64_STRING" | base64 -d`
3. Ensure the decoded output is valid JSON

### Empty values after decoding

If PORT, NODE_ENV, or API_KEY are empty:
1. Check that your JSON has the correct keys: `PORT`, `NODE_ENV`, `API_KEY`
2. Verify the keys are uppercase (case-sensitive)
3. Check the decoded JSON in workflow logs

