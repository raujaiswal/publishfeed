# Azure Artifacts npm Setup Guide

## Overview
This guide will help you set up npm to work with Azure Artifacts so you can publish packages to your organization's artifact feed.

## Prerequisites
- Node.js and npm installed
- Access to Azure DevOps organization: `raujaiswal`
- Permissions to the artifact feed: `raunakfeed`

## Step-by-Step Setup

### Step 1: Generate Personal Access Token
1. Go to: https://dev.azure.com/raujaiswal/_usersSettings/tokens
2. Click **"New Token"**
3. Set the following:
   - **Name**: `npm-feed-access`
   - **Expiration**: Choose appropriate duration (90 days recommended)
   - **Scopes**: Select **"Packaging (read & write)"**
4. Click **"Create"**
5. **Important**: Copy the token immediately (you won't see it again!)

### Step 2: Base64 Encode Your Token
You have two options:

#### Option A: Use the provided batch file
```cmd
encode-token.bat
```

#### Option B: Use Node.js command directly
```cmd
node -e "require('readline').createInterface({input:process.stdin,output:process.stdout,historySize:0}).question('PAT> ',p => { b64=Buffer.from(p.trim()).toString('base64');console.log(b64);process.exit(); })"
```

Paste your token and press Enter. Copy the Base64 encoded result.

### Step 3: Configure User .npmrc
Create or update your user-level .npmrc file:

**Location**: `%USERPROFILE%\.npmrc` (usually `C:\Users\{username}\.npmrc`)

**Content**:
```
; begin auth token
//pkgs.dev.azure.com/raujaiswal/_packaging/raunakfeed/npm/registry/:username=raujaiswal
//pkgs.dev.azure.com/raujaiswal/_packaging/raunakfeed/npm/registry/:_password=[BASE64_ENCODED_PERSONAL_ACCESS_TOKEN]
//pkgs.dev.azure.com/raujaiswal/_packaging/raunakfeed/npm/registry/:email=npm requires email to be set but doesn't use the value
//pkgs.dev.azure.com/raujaiswal/_packaging/raunakfeed/npm/:username=raujaiswal
//pkgs.dev.azure.com/raujaiswal/_packaging/raunakfeed/npm/:_password=[BASE64_ENCODED_PERSONAL_ACCESS_TOKEN]
//pkgs.dev.azure.com/raujaiswal/_packaging/raunakfeed/npm/:email=npm requires email to be set but doesn't use the value
; end auth token
```

Replace `[BASE64_ENCODED_PERSONAL_ACCESS_TOKEN]` with your encoded token from Step 2.

### Step 4: Project Configuration
Your project already has:
- `.npmrc` file pointing to the Azure Artifacts registry
- `package.json` with `publishConfig` section

### Step 5: Install Dependencies
```cmd
npm install
```

### Step 6: Publish Your Package
```cmd
npm publish
```

## Project Structure
```
publishingfeed/
├── .npmrc                    # Project-level npm configuration
├── package.json             # Package configuration
├── index.js                 # Main package file
├── README.md               # Package documentation
├── .gitignore              # Git ignore rules
├── setup-azure-artifacts.ps1  # PowerShell setup script
├── encode-token.bat        # Token encoding helper
└── SETUP_GUIDE.md         # This guide
```

## Troubleshooting

### Common Issues:
1. **401 Unauthorized**: Check your Personal Access Token and ensure it's correctly Base64 encoded
2. **403 Forbidden**: Verify you have write permissions to the artifact feed
3. **404 Not Found**: Check the registry URL in your .npmrc files

### Verification:
```cmd
npm whoami --registry=https://pkgs.dev.azure.com/raujaiswal/_packaging/raunakfeed/npm/registry/
```

This should return your username if authentication is working.

## Security Notes
- Keep your Personal Access Token secure
- Never commit your user .npmrc file to version control
- Set appropriate expiration dates for your tokens
- Regularly rotate your tokens for security

## Support
For issues with Azure Artifacts, consult the Azure DevOps documentation or contact your organization's DevOps team.
