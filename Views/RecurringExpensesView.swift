import SwiftUI
import CoreData

struct OverviewView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var analyticsService: AnalyticsService
    @State private var selectedTimeRange: TimeRange = .thisMonth
    @State private var customStartDate = Date()
    @State private var customEndDate = Date()
    @State private var showingCustomDatePicker = false
    
    init() {
        _analyticsService = StateObject(wrappedValue: AnalyticsService(viewContext: PersistenceController.shared.container.viewContext))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Time range selector
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Time Range")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(TimeRange.allCases, id: \.self) { range in
                                    Button(action: {
                                        selectedTimeRange = range
                                        if range == .custom {
                                            showingCustomDatePicker = true
                                        }
                                    }) {
                                        Text(range.displayName)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(selectedTimeRange == range ? 
                                                      Color.blue : 
                                                      Color(.systemGray6))
                                            .foregroundColor(selectedTimeRange == range ? 
                                                           .white : 
                                                           .primary)
                                            .cornerRadius(20)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Summary cards
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        OverviewCard(
                            title: "Total Spent",
                            value: formatCurrency(totalSpending),
                            icon: "dollarsign.circle.fill",
                            color: .blue
                        )
                        
                        OverviewCard(
                            title: "Categories",
                            value: "\(categoryCount)",
                            icon: "list.bullet.circle.fill",
                            color: .green
                        )
                        
                        OverviewCard(
                            title: "Transactions",
                            value: "\(transactionCount)",
                            icon: "number.circle.fill",
                            color: .orange
                        )
                        
                        OverviewCard(
                            title: "Average",
                            value: formatCurrency(averagePerTransaction),
                            icon: "chart.bar.fill",
                            color: .purple
                        )
                    }
                    .padding(.horizontal)
                    
                    // Category breakdown chart
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Spending by Category")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            ForEach(categoryBreakdown) { category in
                                CategoryOverviewRow(
                                    category: category,
                                    total: totalSpending,
                                    maxAmount: categoryBreakdown.first?.total ?? 1
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Top insights
                    if !insights.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Insights")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                ForEach(insights, id: \.self) { insight in
                                    InsightCard(insight: insight)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.top)
            }
            .navigationTitle("Overview")
            .onAppear {
                analyticsService = AnalyticsService(viewContext: viewContext)
            }
            .sheet(isPresented: $showingCustomDatePicker) {
                CustomDateRangePicker(
                    startDate: $customStartDate,
                    endDate: $customEndDate,
                    selectedTimeRange: $selectedTimeRange
                )
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var dateRange: (start: Date, end: Date) {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedTimeRange {
        case .today:
            let startOfDay = calendar.startOfDay(for: now)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            return (startOfDay, endOfDay)
        case .thisWeek:
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            let endOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.end ?? now
            return (startOfWeek, endOfWeek)
        case .thisMonth:
            let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
            let endOfMonth = calendar.dateInterval(of: .month, for: now)?.end ?? now
            return (startOfMonth, endOfMonth)
        case .thisYear:
            let startOfYear = calendar.dateInterval(of: .year, for: now)?.start ?? now
            let endOfYear = calendar.dateInterval(of: .year, for: now)?.end ?? now
            return (startOfYear, endOfYear)
        case .custom:
            return (customStartDate, customEndDate)
        }
    }
    
    private var totalSpending: Double {
        let (start, end) = dateRange
        return analyticsService.totalSpending(from: start, to: end)
    }
    
    private var categoryBreakdown: [CategorySpending] {
        let (start, end) = dateRange
        return analyticsService.spendingByCategory(from: start, to: end)
    }
    
    private var categoryCount: Int {
        categoryBreakdown.count
    }
    
    private var transactionCount: Int {
        let (start, end) = dateRange
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", start as NSDate, end as NSDate)
        
        do {
            return try viewContext.fetch(request).count
        } catch {
            return 0
        }
    }
    
    private var averagePerTransaction: Double {
        transactionCount > 0 ? totalSpending / Double(transactionCount) : 0
    }
    
    private var insights: [String] {
        var insights: [String] = []
        
        if let topCategory = categoryBreakdown.first {
            let percentage = (topCategory.total / totalSpending) * 100
            insights.append("You spent \(String(format: "%.1f", percentage))% on \(topCategory.category)")
        }
        
        if let largestExpense = analyticsService.largestExpense(from: dateRange.start, to: dateRange.end) {
            insights.append("Your biggest expense was \(formatCurrency(largestExpense.amount)) on \(largestExpense.category ?? "Unknown")")
        }
        
        let dailyAverage = analyticsService.averageDailySpending(from: dateRange.start, to: dateRange.end)
        insights.append("You spent an average of \(formatCurrency(dailyAverage)) per day")
        
        return insights
    }
    
    // MARK: - Helper Methods
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

// MARK: - Supporting Views

struct OverviewCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct CategoryOverviewRow: View {
    let category: CategorySpending
    let total: Double
    let maxAmount: Double
    
    private var percentage: Double {
        total > 0 ? (category.total / total) * 100 : 0
    }
    
    private var barWidth: CGFloat {
        maxAmount > 0 ? CGFloat(category.total / maxAmount) : 0
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(category.category)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(formatCurrency(category.total))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text("\(percentage, specifier: "%.1f")%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 4)
                        .cornerRadius(2)
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * barWidth, height: 4)
                        .cornerRadius(2)
                }
            }
            .frame(height: 4)
            
            HStack {
                Text("\(category.count) transactions")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Avg: \(formatCurrency(category.average))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

struct InsightCard: View {
    let insight: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.yellow)
                .font(.title3)
            
            Text(insight)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct CustomDateRangePicker: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var selectedTimeRange: TimeRange
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Start Date")
                        .font(.headline)
                    
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("End Date")
                        .font(.headline)
                    
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Custom Range")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        selectedTimeRange = .custom
                        dismiss()
                    }
                }
            }
        }
    }
}

enum TimeRange: CaseIterable {
    case today
    case thisWeek
    case thisMonth
    case thisYear
    case custom
    
    var displayName: String {
        switch self {
        case .today: return "Today"
        case .thisWeek: return "This Week"
        case .thisMonth: return "This Month"
        case .thisYear: return "This Year"
        case .custom: return "Custom"
        }
    }
}
