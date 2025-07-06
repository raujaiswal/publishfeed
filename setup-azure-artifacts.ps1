# Azure Artifacts npm Configuration Script
# This script helps you set up authentication for Azure Artifacts

Write-Host "Azure Artifacts npm Configuration Setup" -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green

# Get the user's home directory
$userHome = $env:USERPROFILE
$userNpmrcPath = Join-Path $userHome ".npmrc"

Write-Host "`nUser .npmrc location: $userNpmrcPath" -ForegroundColor Yellow

# Check if user .npmrc exists
if (Test-Path $userNpmrcPath) {
    Write-Host "User .npmrc file already exists." -ForegroundColor Yellow
    $overwrite = Read-Host "Do you want to backup and update it? (y/n)"
    if ($overwrite -eq "y" -or $overwrite -eq "Y") {
        # Create backup
        $backupPath = "$userNpmrcPath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item $userNpmrcPath $backupPath
        Write-Host "Backup created: $backupPath" -ForegroundColor Green
    } else {
        Write-Host "Exiting without changes." -ForegroundColor Red
        exit
    }
}

Write-Host "`nStep 1: Generate Personal Access Token" -ForegroundColor Cyan
Write-Host "1. Go to https://dev.azure.com/raujaiswal/_usersSettings/tokens" -ForegroundColor White
Write-Host "2. Click 'New Token'" -ForegroundColor White
Write-Host "3. Set name: 'npm-feed-access'" -ForegroundColor White
Write-Host "4. Select scope: 'Packaging (read & write)'" -ForegroundColor White
Write-Host "5. Click 'Create'" -ForegroundColor White
Write-Host "6. Copy the token (you won't see it again!)" -ForegroundColor White

Write-Host "`nStep 2: Enter your Personal Access Token" -ForegroundColor Cyan
$pat = Read-Host "Paste your Personal Access Token" -AsSecureString
$patPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pat))

Write-Host "`nStep 3: Base64 encoding the token..." -ForegroundColor Cyan
$base64Pat = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($patPlainText))

Write-Host "`nStep 4: Creating user .npmrc file..." -ForegroundColor Cyan

# Create the .npmrc content
$npmrcContent = @"
; begin auth token
//pkgs.dev.azure.com/raujaiswal/_packaging/raunakfeed/npm/registry/:username=raujaiswal
//pkgs.dev.azure.com/raujaiswal/_packaging/raunakfeed/npm/registry/:_password=$base64Pat
//pkgs.dev.azure.com/raujaiswal/_packaging/raunakfeed/npm/registry/:email=npm requires email to be set but doesn't use the value
//pkgs.dev.azure.com/raujaiswal/_packaging/raunakfeed/npm/:username=raujaiswal
//pkgs.dev.azure.com/raujaiswal/_packaging/raunakfeed/npm/:_password=$base64Pat
//pkgs.dev.azure.com/raujaiswal/_packaging/raunakfeed/npm/:email=npm requires email to be set but doesn't use the value
; end auth token
"@

# Write to user .npmrc
$npmrcContent | Out-File -FilePath $userNpmrcPath -Encoding utf8

Write-Host "`nConfiguration completed successfully!" -ForegroundColor Green
Write-Host "Your user .npmrc file has been created/updated at: $userNpmrcPath" -ForegroundColor Green

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Navigate to your project directory: cd '$((Get-Location).Path)'" -ForegroundColor White
Write-Host "2. Install dependencies: npm install" -ForegroundColor White
Write-Host "3. Ensure your package name is unique (avoid conflicts with existing packages)" -ForegroundColor White
Write-Host "4. Publish your package: npm publish" -ForegroundColor White

Write-Host "`nImportant Notes:" -ForegroundColor Yellow
Write-Host "- Keep your Personal Access Token secure and never share it!" -ForegroundColor Red
Write-Host "- Use scoped packages (@username/package-name) to avoid naming conflicts" -ForegroundColor Cyan
Write-Host "- Check package.json for proper registry configuration" -ForegroundColor Cyan
