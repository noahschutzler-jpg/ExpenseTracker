import SwiftUI
import CoreData

struct ReportsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var analyticsService: AnalyticsService
    @State private var selectedTimeframe: TimeFrame = .month
    @State private var selectedDate = Date()
    
    init() {
        // We'll initialize this properly in onAppear
        _analyticsService = StateObject(wrappedValue: AnalyticsService(viewContext: PersistenceController.shared.container.viewContext))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Time frame selector
                    Picker("Time Frame", selection: $selectedTimeframe) {
                        ForEach(TimeFrame.allCases, id: \.self) { timeframe in
                            Text(timeframe.rawValue).tag(timeframe)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Summary cards
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        SummaryCard(
                            title: "Total Spent",
                            value: formatCurrency(currentPeriodTotal),
                            subtitle: selectedTimeframe.rawValue,
                            color: .blue
                        )
                        
                        SummaryCard(
                            title: "Daily Average",
                            value: formatCurrency(averageDailySpending),
                            subtitle: "per day",
                            color: .green
                        )
                        
                        SummaryCard(
                            title: "Transactions",
                            value: "\(transactionCount)",
                            subtitle: "this \(selectedTimeframe.rawValue.lowercased())",
                            color: .orange
                        )
                        
                        SummaryCard(
                            title: "Top Category",
                            value: topCategory,
                            subtitle: formatCurrency(topCategoryAmount),
                            color: .purple
                        )
                    }
                    .padding(.horizontal)
                    
                    // Category breakdown
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Spending by Category")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        ForEach(categoryBreakdown) { category in
                            CategoryBreakdownRow(
                                category: category,
                                total: currentPeriodTotal
                            )
                        }
                    }
                    
                    // Trend analysis
                    if let trend = spendingTrend {
                        TrendCard(trend: trend, timeframe: selectedTimeframe)
                            .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.top)
            }
            .navigationTitle("Reports")
            .onAppear {
                analyticsService = AnalyticsService(viewContext: viewContext)
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var currentPeriodTotal: Double {
        let (start, end) = getDateRange(for: selectedTimeframe, from: selectedDate)
        return analyticsService.totalSpending(from: start, to: end)
    }
    
    private var averageDailySpending: Double {
        let (start, end) = getDateRange(for: selectedTimeframe, from: selectedDate)
        return analyticsService.averageDailySpending(from: start, to: end)
    }
    
    private var transactionCount: Int {
        let (start, end) = getDateRange(for: selectedTimeframe, from: selectedDate)
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", start as NSDate, end as NSDate)
        
        do {
            return try viewContext.fetch(request).count
        } catch {
            return 0
        }
    }
    
    private var topCategory: String {
        let (start, end) = getDateRange(for: selectedTimeframe, from: selectedDate)
        return analyticsService.highestSpendingCategory(from: start, to: end) ?? "None"
    }
    
    private var topCategoryAmount: Double {
        let (start, end) = getDateRange(for: selectedTimeframe, from: selectedDate)
        let categories = analyticsService.spendingByCategory(from: start, to: end)
        return categories.first?.total ?? 0
    }
    
    private var categoryBreakdown: [CategorySpending] {
        let (start, end) = getDateRange(for: selectedTimeframe, from: selectedDate)
        return analyticsService.spendingByCategory(from: start, to: end)
    }
    
    private var spendingTrend: SpendingTrend? {
        let (currentStart, currentEnd) = getDateRange(for: selectedTimeframe, from: selectedDate)
        let (previousStart, previousEnd) = getPreviousPeriodRange(for: selectedTimeframe, from: selectedDate)
        
        return analyticsService.spendingTrend(
            currentPeriod: (currentStart, currentEnd),
            previousPeriod: (previousStart, previousEnd)
        )
    }
    
    // MARK: - Helper Methods
    
    private func getDateRange(for timeframe: TimeFrame, from date: Date) -> (start: Date, end: Date) {
        let calendar = Calendar.current
        
        switch timeframe {
        case .week:
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? date
            let endOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.end ?? date
            return (startOfWeek, endOfWeek)
        case .month:
            let startOfMonth = calendar.dateInterval(of: .month, for: date)?.start ?? date
            let endOfMonth = calendar.dateInterval(of: .month, for: date)?.end ?? date
            return (startOfMonth, endOfMonth)
        case .year:
            let startOfYear = calendar.dateInterval(of: .year, for: date)?.start ?? date
            let endOfYear = calendar.dateInterval(of: .year, for: date)?.end ?? date
            return (startOfYear, endOfYear)
        }
    }
    
    private func getPreviousPeriodRange(for timeframe: TimeFrame, from date: Date) -> (start: Date, end: Date) {
        let calendar = Calendar.current
        
        switch timeframe {
        case .week:
            let previousWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: date) ?? date
            return getDateRange(for: timeframe, from: previousWeek)
        case .month:
            let previousMonth = calendar.date(byAdding: .month, value: -1, to: date) ?? date
            return getDateRange(for: timeframe, from: previousMonth)
        case .year:
            let previousYear = calendar.date(byAdding: .year, value: -1, to: date) ?? date
            return getDateRange(for: timeframe, from: previousYear)
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

// MARK: - Supporting Views

struct SummaryCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct CategoryBreakdownRow: View {
    let category: CategorySpending
    let total: Double
    
    private var percentage: Double {
        total > 0 ? (category.total / total) * 100 : 0
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(category.category)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("\(category.count) transactions")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(category.total, specifier: "%.2f")")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("\(percentage, specifier: "%.1f")%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

struct TrendCard: View {
    let trend: SpendingTrend
    let timeframe: TimeFrame
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trend Analysis")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                Image(systemName: trend.isIncreasing ? "arrow.up.right" : "arrow.down.right")
                    .foregroundColor(trend.isIncreasing ? .red : .green)
                
                Text(trend.isIncreasing ? "Increased" : "Decreased")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(abs(trend.percentageChange), specifier: "%.1f")%")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(trend.isIncreasing ? .red : .green)
            }
            
            Text("vs previous \(timeframe.rawValue.lowercased())")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

enum TimeFrame: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}
