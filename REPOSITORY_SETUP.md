# 🚀 PocketWatch Repository Setup Guide

This guide will help you set up a Git repository for your PocketWatch iOS app using PowerShell.

## 📋 Prerequisites

1. **Git installed** - Download from [git-scm.com](https://git-scm.com/downloads)
2. **GitHub account** - Sign up at [github.com](https://github.com)
3. **PowerShell** - Available on Windows 10/11

## 🎯 Quick Start

### Option 1: Complete Setup (Recommended)
Run the complete setup script that will initialize everything:

```powershell
.\setup-repository.ps1
```

This script will:
- ✅ Initialize Git repository
- ✅ Create .gitignore for iOS/Swift
- ✅ Generate README.md with full documentation
- ✅ Add MIT License
- ✅ Create initial commit
- ✅ Guide you through GitHub setup

### Option 2: Quick Push (If repository exists)
If you already have a GitHub repository:

```powershell
.\push-to-github.ps1
```

### Option 3: Manual Setup
If you prefer to set up manually:

```powershell
# Initialize Git
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: PocketWatch iOS expense tracker"

# Add remote (replace with your GitHub URL)
git remote add origin https://github.com/yourusername/pocketwatch.git

# Push to GitHub
git push -u origin main
```

## 📁 Project Structure

Your repository will have this structure:

```
PocketWatch/
├── 📱 ExpenseTrackerApp.swift          # Main app entry point
├── 📁 Models/
│   ├── Expense.swift                   # Core data model
│   ├── ExpenseCategory.swift          # Category definitions
│   ├── RecurrenceFrequency.swift      # Recurring expense options
│   └── ThemeManager.swift             # Theme management
├── 📁 Views/
│   ├── ContentView.swift              # Main tab view
│   ├── DashboardView.swift            # Home dashboard
│   ├── AddExpenseView.swift           # Expense entry form
│   ├── ReportsView.swift              # Analytics reports
│   ├── OverviewView.swift             # Category breakdown
│   ├── FinancialWrappedView.swift     # Wrapped insights
│   ├── SettingsView.swift             # App settings
│   ├── OnboardingView.swift           # First-time setup
│   ├── QuickAddView.swift             # Quick expense entry
│   └── AchievementsView.swift         # Goals/achievements
├── 📁 Services/
│   ├── PersistenceController.swift    # Core Data setup
│   └── AnalyticsService.swift         # Analytics calculations
├── 📁 Extensions/
│   └── Color+Hex.swift                # Color utilities
├── 📁 ViewModels/                     # (Empty - using MVVM pattern)
├── 📄 README.md                       # Project documentation
├── 📄 LICENSE                         # MIT License
├── 🚫 .gitignore                      # Git ignore rules
└── 🔧 setup-repository.ps1            # Setup script
```

## 🌐 GitHub Repository Setup

### Step 1: Create Repository on GitHub
1. Go to [github.com/new](https://github.com/new)
2. Repository name: `pocketwatch` (or your preferred name)
3. Description: "Minimalist iOS expense tracker for mindful spending"
4. Set to Public or Private (your choice)
5. **Don't** initialize with README, .gitignore, or license (we have these)
6. Click "Create repository"

### Step 2: Get Repository URL
Copy the repository URL from GitHub. It will look like:
- HTTPS: `https://github.com/yourusername/pocketwatch.git`
- SSH: `git@github.com:yourusername/pocketwatch.git`

### Step 3: Run Setup Script
```powershell
.\setup-repository.ps1
```

When prompted, paste your GitHub repository URL.

## 🔄 Daily Workflow

After making changes to your code:

```powershell
# Stage changes
git add .

# Commit with message
git commit -m "Add new feature: [description]"

# Push to GitHub
git push origin main
```

Or use the quick push script:
```powershell
.\push-to-github.ps1
```

## 📝 Commit Message Guidelines

Use clear, descriptive commit messages:

```bash
# Good examples:
git commit -m "Add recurring expense functionality"
git commit -m "Fix emoji display in category icons"
git commit -m "Update OverviewView with date range selector"
git commit -m "Refactor AnalyticsService for better performance"

# Bad examples:
git commit -m "fix"
git commit -m "updates"
git commit -m "stuff"
```

## 🛠️ Troubleshooting

### Git Not Found
```powershell
# Install Git from: https://git-scm.com/downloads
# Or use Chocolatey:
choco install git
```

### Permission Denied
```powershell
# Configure Git with your credentials
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Repository Already Exists
```powershell
# Remove existing remote
git remote remove origin

# Add new remote
git remote add origin https://github.com/yourusername/pocketwatch.git
```

### Large File Issues
```powershell
# Check for large files
git ls-files | ForEach-Object { if ((Get-Item $_).Length -gt 100MB) { $_ } }

# Add to .gitignore if needed
echo "*.largefile" >> .gitignore
```

## 🎉 Next Steps

After setting up your repository:

1. **Open in Xcode**: Open `ExpenseTracker.xcodeproj`
2. **Build & Run**: Test the app on simulator
3. **Make Changes**: Start developing new features
4. **Commit Regularly**: Make small, frequent commits
5. **Push to GitHub**: Keep your repository updated

## 📚 Additional Resources

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Guides](https://guides.github.com/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Core Data Documentation](https://developer.apple.com/documentation/coredata)

## 🤝 Contributing

If you want to contribute to PocketWatch:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Commit: `git commit -m "Add amazing feature"`
5. Push: `git push origin feature/amazing-feature`
6. Open a Pull Request

---

**Happy coding! 🚀**

*Made with ❤️ for mindful spending*
