# PocketWatch Project Structure Creator
# This script creates the proper iOS project structure

Write-Host "📁 Creating PocketWatch project structure..." -ForegroundColor Green

# Create main directories
$directories = @(
    "PocketWatch",
    "PocketWatch/Models",
    "PocketWatch/Views", 
    "PocketWatch/Services",
    "PocketWatch/Extensions",
    "PocketWatch/ViewModels",
    "PocketWatch/Resources",
    "PocketWatch/Resources/Assets.xcassets",
    "PocketWatch/Resources/Assets.xcassets/AppIcon.appiconset",
    "PocketWatch/Resources/Assets.xcassets/Contents.xcassets"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "✅ Created: $dir" -ForegroundColor Green
    }
}

Write-Host "🎉 Project structure created successfully!" -ForegroundColor Green
Write-Host "📁 Ready for Xcode project creation" -ForegroundColor Cyan
