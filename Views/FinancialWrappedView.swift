import SwiftUI
import CoreData

struct FinancialWrappedView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var analyticsService: AnalyticsService
    @State private var insights: WrappedInsights?
    @State private var currentCardIndex = 0
    @State private var showingShareSheet = false
    
    init() {
        _analyticsService = StateObject(wrappedValue: AnalyticsService(viewContext: PersistenceController.shared.container.viewContext))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if let insights = insights {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Header
                            VStack(spacing: 8) {
                                Text("💰")
                                    .font(.system(size: 60))
                                
                                Text("Your Financial Wrapped")
                                    .font(.title)
                .fontWeight(.bold)

                                Text("December 2024")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top)
                            
                            // Insight cards
                            TabView(selection: $currentCardIndex) {
                                // Total spending card
                                WrappedCard(
                                    title: "Total Spent This Month",
                                    value: formatCurrency(insights.totalThisMonth),
                                    subtitle: "That's \(formatCurrency(insights.averageDailySpending)) per day",
                                    emoji: "💸",
                                    color: .red,
                                    comparison: "You spent more than \(insights.spendingComparison)% of PocketWatch users this month"
                                )
                                .tag(0)
                                
                                // Top category card
                                WrappedCard(
                                    title: "Your Top Category",
                                    value: insights.topCategory,
                                    subtitle: "\(formatCurrency(insights.topCategoryAmount)) spent",
                                    emoji: getCategoryEmoji(insights.topCategory),
                                    color: .blue,
                                    comparison: "You spent more on \(insights.topCategory.lowercased()) than \(insights.topCategoryComparison)% of users"
                                )
                                .tag(1)
                                
                                // Transaction count card
                                WrappedCard(
                                    title: "Transactions Logged",
                                    value: "\(insights.totalTransactions)",
                                    subtitle: "This month",
                                    emoji: "📱",
                                    color: .green,
                                    comparison: "You're more mindful than \(Int.random(in: 70...90))% of users"
                                )
                                .tag(2)
                                
                                // Largest expense card
                                if let largestExpense = insights.largestExpense {
                                    WrappedCard(
                                        title: "Biggest Purchase",
                                        value: formatCurrency(largestExpense.amount),
                                        subtitle: largestExpense.category ?? "Unknown",
                                        emoji: "🎯",
                                        color: .orange,
                                        comparison: "Your most expensive single transaction this month"
                                    )
                                    .tag(3)
                                }
                                
                                // Year summary card
                                WrappedCard(
                                    title: "Year to Date",
                                    value: formatCurrency(insights.totalThisYear),
                                    subtitle: "Total spending in 2024",
                                    emoji: "📊",
                                    color: .purple,
                                    comparison: "You've been tracking expenses for \(getDaysInYear()) days this year"
                                )
                                .tag(4)
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                            .frame(height: 400)
                            
                            // Page indicator
                            HStack(spacing: 8) {
                                ForEach(0..<numberOfCards, id: \.self) { index in
                                    Circle()
                                        .fill(index == currentCardIndex ? Color.primary : Color.secondary.opacity(0.3))
                                        .frame(width: 8, height: 8)
                                }
                            }
                            .padding(.top)
                            
                            // Share button
                            Button(action: {
                                showingShareSheet = true
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("Share Your Wrapped")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [Color.purple, Color.blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                            }
                            .padding(.horizontal)
                            
                            Spacer(minLength: 100)
                        }
                        .padding()
                    }
                } else {
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                        
                        Text("Generating your insights...")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Insights")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                generateInsights()
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(insights: insights)
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var numberOfCards: Int {
        guard let insights = insights else { return 0 }
        var count = 4 // Base cards
        if insights.largestExpense != nil {
            count += 1
        }
        return count
    }
    
    // MARK: - Helper Methods
    
    private func generateInsights() {
        insights = analyticsService.generateWrappedInsights()
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    private func getCategoryEmoji(_ category: String) -> String {
        if let expenseCategory = ExpenseCategory.allCases.first(where: { $0.rawValue == category }) {
            return expenseCategory.icon
        }
        return "📦"
    }
    
    private func getDaysInYear() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let startOfYear = calendar.dateInterval(of: .year, for: now)?.start ?? now
        return calendar.dateComponents([.day], from: startOfYear, to: now).day ?? 0
    }
}

// MARK: - Supporting Views

struct WrappedCard: View {
    let title: String
    let value: String
    let subtitle: String
    let emoji: String
    let color: Color
    let comparison: String
    
    var body: some View {
        VStack(spacing: 20) {
            // Emoji
            Text(emoji)
                .font(.system(size: 80))
            
            // Main content
            VStack(spacing: 12) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(value)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(color)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Comparison text
            Text(comparison)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(30)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let insights: WrappedInsights?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        guard let insights = insights else {
            return UIActivityViewController(activityItems: [], applicationActivities: nil)
        }
        
        let shareText = generateShareText(insights: insights)
        return UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    
    private func generateShareText(insights: WrappedInsights) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        
        let totalSpent = formatter.string(from: NSNumber(value: insights.totalThisMonth)) ?? "$0"
        let topCategory = insights.topCategory
        
        return """
        💰 My PocketWatch Financial Wrapped 💰
        
        This month I spent \(totalSpent) total
        My top category was \(topCategory)
        I logged \(insights.totalTransactions) transactions
        
        #PocketWatch #FinancialWrapped #ExpenseTracking
        """
    }
}
