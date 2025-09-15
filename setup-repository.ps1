# PocketWatch Repository Setup Script
# This script automates the creation of a Git repository for the PocketWatch iOS app

Write-Host "🚀 Setting up PocketWatch Repository..." -ForegroundColor Green

# Check if Git is installed
try {
    $gitVersion = git --version
    Write-Host "✅ Git found: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Git is not installed. Please install Git first." -ForegroundColor Red
    Write-Host "Download from: https://git-scm.com/downloads" -ForegroundColor Yellow
    exit 1
}

# Initialize Git repository
Write-Host "📁 Initializing Git repository..." -ForegroundColor Blue
git init

# Create .gitignore file for iOS/Swift projects
Write-Host "📝 Creating .gitignore file..." -ForegroundColor Blue
@"
# Xcode
.DS_Store
*/build/*
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
xcuserdata/
profile
*.moved-aside
DerivedData
.idea/
*.hmap
*.xccheckout
*.xcworkspace
!default.xcworkspace

# CocoaPods
Pods/
*.podspec
Podfile.lock

# Swift Package Manager
.build/
Packages/
Package.pins
Package.resolved
*.xcodeproj

# AppCode
.idea/

# fastlane
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots/**/*.png
fastlane/test_output

# Code Injection
iOSInjectionProject/

# Core Data
*.xcdatamodeld/Contents

# Temporary files
*.tmp
*.temp
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE
.vscode/
*.swp
*.swo

# Logs
*.log
"@ | Out-File -FilePath ".gitignore" -Encoding UTF8

# Create README.md
Write-Host "📖 Creating README.md..." -ForegroundColor Blue
@"
# 💰 PocketWatch

A minimalist iOS expense tracker designed to encourage intentional spending through mindful expense logging.

## ✨ Features

- **Manual Expense Entry**: No automation - every expense requires conscious input
- **Quick Add**: Fast expense logging with category-based quick buttons
- **Comprehensive Analytics**: Weekly, monthly, and yearly spending insights
- **Financial Wrapped**: Spotify Wrapped-style spending summaries
- **Category Breakdown**: Visual analysis of spending patterns
- **Recurring Expenses**: Set up recurring expenses with flexible frequencies
- **Daily Reminders**: Gentle nudges to log expenses
- **Dark Mode**: Full dark mode support with customizable themes
- **Clean Design**: Opal-inspired minimalist aesthetic

## 🏗️ Architecture

- **SwiftUI**: Modern declarative UI framework
- **Core Data**: Local data persistence
- **MVVM Pattern**: Clean separation of concerns
- **Analytics Service**: Comprehensive spending calculations
- **User Notifications**: Daily reminder system

## 📱 Screenshots

*Screenshots coming soon*

## 🚀 Getting Started

1. Clone the repository
2. Open `ExpenseTracker.xcodeproj` in Xcode
3. Build and run on iOS Simulator or device
4. Complete onboarding to start tracking expenses

## 📋 Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## 🎨 Design Philosophy

PocketWatch follows a minimalist, intentional design approach inspired by the Opal app:

- **Clean, spacious layouts** with generous white space
- **Soft, calming colors** that don't overwhelm
- **Intentional, "painful" design** that encourages mindful spending
- **No gamification** - focuses on awareness over rewards
- **Mobile-first** responsive design

## 📊 Core Features

### Expense Tracking
- Manual entry with amount, category, description, and date
- Quick add buttons for common categories
- Recurring expense support with flexible frequencies

### Analytics & Insights
- Real-time spending calculations
- Category-based analysis with visual breakdowns
- Trend detection and period comparisons
- Wrapped-style fun statistics with anonymous comparisons

### Customization
- Dark/light mode toggle
- Customizable accent colors
- Daily reminder notifications
- Flexible date range analysis

## 🔧 Technical Details

### Models
- `Expense`: Core data model for expense entries
- `ExpenseCategory`: Predefined spending categories with icons and colors
- `RecurrenceFrequency`: Recurring expense frequency options
- `ThemeManager`: App-wide theme and color management

### Services
- `AnalyticsService`: Comprehensive spending calculations and pattern analysis
- `PersistenceController`: Core Data stack management

### Views
- `DashboardView`: Main expense overview and quick add
- `AddExpenseView`: Detailed expense entry form
- `ReportsView`: Comprehensive spending analytics
- `OverviewView`: Category breakdown and insights
- `FinancialWrappedView`: Spotify Wrapped-style summaries
- `SettingsView`: App customization and preferences

## 📈 Future Enhancements

- [ ] Data export/import functionality
- [ ] Budget goals and spending limits
- [ ] Advanced chart visualizations
- [ ] iOS widget support
- [ ] Apple Watch companion app
- [ ] iCloud synchronization
- [ ] Achievement system

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Design inspiration from the Opal app
- Built with SwiftUI and Core Data
- Icons from SF Symbols

---

Made with ❤️ for mindful spending
"@ | Out-File -FilePath "README.md" -Encoding UTF8

# Create LICENSE file
Write-Host "📄 Creating LICENSE file..." -ForegroundColor Blue
@"
MIT License

Copyright (c) 2024 PocketWatch

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"@ | Out-File -FilePath "LICENSE" -Encoding UTF8

# Add all files to Git
Write-Host "📦 Adding files to Git..." -ForegroundColor Blue
git add .

# Create initial commit
Write-Host "💾 Creating initial commit..." -ForegroundColor Blue
git commit -m "Initial commit: PocketWatch iOS expense tracker

✨ Features:
- Manual expense entry with categories
- Quick add functionality
- Comprehensive analytics and reports
- Financial Wrapped insights
- Recurring expense support
- Dark mode and theme customization
- Daily reminder notifications

🏗️ Architecture:
- SwiftUI + Core Data
- MVVM pattern
- Analytics service for calculations
- Clean, minimalist design

📱 Ready for iOS development"

# Get repository name from current directory
$repoName = Split-Path -Leaf (Get-Location)
Write-Host "📁 Repository name: $repoName" -ForegroundColor Yellow

# Ask user if they want to create a GitHub repository
Write-Host ""
Write-Host "🎯 Next steps:" -ForegroundColor Green
Write-Host "1. Go to https://github.com/new" -ForegroundColor White
Write-Host "2. Create a new repository named: $repoName" -ForegroundColor White
Write-Host "3. Don't initialize with README (we already have one)" -ForegroundColor White
Write-Host "4. Copy the repository URL" -ForegroundColor White
Write-Host ""

# Ask for GitHub repository URL
$githubUrl = Read-Host "Enter your GitHub repository URL (or press Enter to skip)"

if ($githubUrl -ne "") {
    Write-Host "🔗 Adding remote origin..." -ForegroundColor Blue
    git remote add origin $githubUrl
    
    Write-Host "🚀 Pushing to GitHub..." -ForegroundColor Blue
    git branch -M main
    git push -u origin main
    
    Write-Host "✅ Successfully pushed to GitHub!" -ForegroundColor Green
    Write-Host "🌐 Your repository is now available at: $githubUrl" -ForegroundColor Cyan
} else {
    Write-Host "⏭️ Skipping GitHub setup. You can add a remote later with:" -ForegroundColor Yellow
    Write-Host "git remote add origin <your-repo-url>" -ForegroundColor White
    Write-Host "git push -u origin main" -ForegroundColor White
}

Write-Host ""
Write-Host "🎉 Repository setup complete!" -ForegroundColor Green
Write-Host "📁 Local repository initialized" -ForegroundColor White
Write-Host "📝 README.md created with project documentation" -ForegroundColor White
Write-Host "📄 LICENSE file added (MIT License)" -ForegroundColor White
Write-Host "🚫 .gitignore configured for iOS/Swift projects" -ForegroundColor White
Write-Host ""
Write-Host "💡 To continue development:" -ForegroundColor Cyan
Write-Host "1. Open ExpenseTracker.xcodeproj in Xcode" -ForegroundColor White
Write-Host "2. Build and run the project" -ForegroundColor White
Write-Host "3. Start adding features and making commits" -ForegroundColor White
Write-Host ""
Write-Host "Happy coding! 🚀" -ForegroundColor Green
