import SwiftUI

struct ContentView: View {
    @AppStorage("onboardingCompleted") private var onboardingCompleted: Bool = false

    var body: some View {
        if !onboardingCompleted {
            OnboardingView()
        } else {
            TabView {
                DashboardView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }

                ReportsView()
                    .tabItem {
                        Label("Reports", systemImage: "chart.bar")
                    }

                AchievementsView()
                    .tabItem {
                        Label("Goals", systemImage: "star")
                    }

                OverviewView()
                    .tabItem {
                        Label("Overview", systemImage: "chart.pie")
                    }

                FinancialWrappedView()
                    .tabItem {
                        Label("Insights", systemImage: "sparkles")
                    }

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            .accentColor(.teal)
        }
    }
}
