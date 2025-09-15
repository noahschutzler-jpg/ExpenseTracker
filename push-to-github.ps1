# Quick GitHub Push Script for PocketWatch
# Use this if you already have a GitHub repository set up

Write-Host "🚀 Pushing PocketWatch to GitHub..." -ForegroundColor Green

# Check if we're in a Git repository
if (-not (Test-Path ".git")) {
    Write-Host "❌ Not in a Git repository. Run setup-repository.ps1 first." -ForegroundColor Red
    exit 1
}

# Check for uncommitted changes
$status = git status --porcelain
if ($status) {
    Write-Host "📝 Staging changes..." -ForegroundColor Blue
    git add .
    
    $commitMessage = Read-Host "Enter commit message (or press Enter for default)"
    if ($commitMessage -eq "") {
        $commitMessage = "Update PocketWatch: Enhanced features and UI improvements"
    }
    
    Write-Host "💾 Committing changes..." -ForegroundColor Blue
    git commit -m $commitMessage
} else {
    Write-Host "✅ No changes to commit" -ForegroundColor Green
}

# Check if remote exists
$remote = git remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0) {
    $githubUrl = Read-Host "Enter your GitHub repository URL"
    Write-Host "🔗 Adding remote origin..." -ForegroundColor Blue
    git remote add origin $githubUrl
}

# Push to GitHub
Write-Host "🚀 Pushing to GitHub..." -ForegroundColor Blue
git push origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Successfully pushed to GitHub!" -ForegroundColor Green
    Write-Host "🌐 Repository: $remote" -ForegroundColor Cyan
} else {
    Write-Host "❌ Push failed. Check your repository URL and try again." -ForegroundColor Red
}
