@echo off
echo Azure Artifacts - Base64 Encoder for Personal Access Token
echo ==========================================================
echo.
echo This tool will help you Base64 encode your Personal Access Token
echo for use with Azure Artifacts npm feed.
echo.
echo Instructions:
echo 1. Run this command: node -e "require('readline').createInterface({input:process.stdin,output:process.stdout,historySize:0}).question('PAT> ',p => { b64=Buffer.from(p.trim()).toString('base64');console.log(b64);process.exit(); })"
echo 2. Paste your Personal Access Token and press Enter
echo 3. Copy the Base64 encoded value
echo 4. Use it in your .npmrc file
echo.
pause
node -e "require('readline').createInterface({input:process.stdin,output:process.stdout,historySize:0}).question('PAT> ',p => { b64=Buffer.from(p.trim()).toString('base64');console.log(b64);process.exit(); })"
