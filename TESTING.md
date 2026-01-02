# Testing GitHub Environment Variables

This guide explains how to test the base64-encoded environment variables in GitHub Actions workflows.

## Setup in GitHub

1. Go to your repository → **Settings** → **Environments**
2. Create environments (e.g., `development`, `production`)
3. Add a single secret named `DEPLOYMENT_POC_ENV_VARS` containing a base64-encoded JSON object with all environment variables

### How to encode values:

The secret should be a base64-encoded JSON object. Example:

**Step 1: Create JSON object**
```json
{
  "PORT": "3000",
  "NODE_ENV": "development",
  "API_KEY": "your-secret-api-key"
}
```

**Step 2: Encode to base64**
```bash
# Using jq to create JSON and encode
echo -n '{"PORT":"3000","NODE_ENV":"development","API_KEY":"your-secret-api-key"}' | base64

# Or use the helper script
./encode-env.sh
```

**Step 3: Add to GitHub**
- Secret Name: `DEPLOYMENT_POC_ENV_VARS`
- Secret Value: The base64-encoded string from step 2

## Testing Methods

### Method 1: Manual Workflow Dispatch (Recommended for Testing)

1. Go to **Actions** tab in your GitHub repository
2. Select **"Test Environment Variables"** workflow
3. Click **"Run workflow"** button
4. Select the branch and environment
5. Click **"Run workflow"** to execute

This workflow will:
- Decode all base64 environment variables
- Display them (masked for security)
- Verify they are not empty
- Test the Express server with decoded variables

### Method 2: Push to Trigger CI

1. Make a commit and push to `main`, `master`, or `develop` branch
2. The CI workflow will automatically run
3. Check the **Actions** tab to see the workflow execution
4. Look for the "Decode base64 environment variables" step to verify decoding

### Method 3: Local Testing with act (Optional)

If you want to test locally before pushing:

```bash
# Install act (GitHub Actions locally)
brew install act  # macOS
# or
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Run the test workflow locally
act -W .github/workflows/test-env.yml --secret-file .env.local
```

## Workflow Files

- **`test-env.yml`** - Dedicated test workflow for environment variables
- **`ci.yml`** - CI workflow that uses environment variables
- **`deploy.yml`** - Deployment workflow with environment variables

## Verifying Decoding Works

Check the workflow logs for:
- ✅ "All environment variables decoded successfully!"
- ✅ "Server started successfully with decoded env vars!"
- The decoded values (masked) in the output

## Troubleshooting

If decoding fails:
1. Verify the secret is named `DEPLOYMENT_POC_ENV_VARS` (exact match, case-sensitive)
2. Check that the value is valid base64-encoded JSON
3. Verify the JSON structure contains `PORT`, `NODE_ENV`, and `API_KEY` keys
4. Ensure the environment is set correctly in the workflow
5. Check workflow logs for specific error messages
6. Test the JSON structure locally:
   ```bash
   # Decode and verify JSON
   echo "YOUR_BASE64_STRING" | base64 -d | jq '.'
   ```

