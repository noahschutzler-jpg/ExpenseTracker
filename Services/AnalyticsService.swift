import Foundation
import CoreData

/// Service responsible for calculating spending analytics and generating insights
class AnalyticsService: ObservableObject {
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    // MARK: - Basic Calculations
    
    /// Calculate total spending for a specific date range
    func totalSpending(from startDate: Date, to endDate: Date) -> Double {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", 
                                      startDate as NSDate, endDate as NSDate)
        
        do {
            let expenses = try viewContext.fetch(request)
            return expenses.reduce(0) { $0 + $1.amount }
        } catch {
            print("Error fetching expenses: \(error)")
            return 0
        }
    }
    
    /// Calculate today's total spending
    func todaysSpending() -> Double {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return totalSpending(from: startOfDay, to: endOfDay)
    }
    
    /// Calculate this week's total spending
    func thisWeeksSpending() -> Double {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        let endOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.end ?? Date()
        
        return totalSpending(from: startOfWeek, to: endOfWeek)
    }
    
    /// Calculate this month's total spending
    func thisMonthsSpending() -> Double {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: Date())?.start ?? Date()
        let endOfMonth = calendar.dateInterval(of: .month, for: Date())?.end ?? Date()
        
        return totalSpending(from: startOfMonth, to: endOfMonth)
    }
    
    // MARK: - Category Analysis
    
    /// Get spending breakdown by category for a date range
    func spendingByCategory(from startDate: Date, to endDate: Date) -> [CategorySpending] {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", 
                                      startDate as NSDate, endDate as NSDate)
        
        do {
            let expenses = try viewContext.fetch(request)
            let grouped = Dictionary(grouping: expenses) { $0.category ?? "Unknown" }
            
            return grouped.map { category, expenses in
                CategorySpending(
                    category: category,
                    total: expenses.reduce(0) { $0 + $1.amount },
                    count: expenses.count,
                    average: expenses.reduce(0) { $0 + $1.amount } / Double(expenses.count)
                )
            }.sorted { $0.total > $1.total }
        } catch {
            print("Error fetching expenses by category: \(error)")
            return []
        }
    }
    
    /// Get the most frequent spending category
    func mostFrequentCategory(from startDate: Date, to endDate: Date) -> String? {
        let categorySpending = spendingByCategory(from: startDate, to: endDate)
        return categorySpending.max { $0.count < $1.count }?.category
    }
    
    /// Get the category with highest spending
    func highestSpendingCategory(from startDate: Date, to endDate: Date) -> String? {
        let categorySpending = spendingByCategory(from: startDate, to: endDate)
        return categorySpending.first?.category
    }
    
    // MARK: - Pattern Analysis
    
    /// Calculate average daily spending for a date range
    func averageDailySpending(from startDate: Date, to endDate: Date) -> Double {
        let total = totalSpending(from: startDate, to: endDate)
        let days = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 1
        return total / Double(max(days, 1))
    }
    
    /// Get the largest single expense in a date range
    func largestExpense(from startDate: Date, to endDate: Date) -> Expense? {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", 
                                      startDate as NSDate, endDate as NSDate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Expense.amount, ascending: false)]
        request.fetchLimit = 1
        
        do {
            let expenses = try viewContext.fetch(request)
            return expenses.first
        } catch {
            print("Error fetching largest expense: \(error)")
            return nil
        }
    }
    
    /// Calculate spending trend (comparing two periods)
    func spendingTrend(currentPeriod: (start: Date, end: Date), 
                      previousPeriod: (start: Date, end: Date)) -> SpendingTrend {
        let currentSpending = totalSpending(from: currentPeriod.start, to: currentPeriod.end)
        let previousSpending = totalSpending(from: previousPeriod.start, to: previousPeriod.end)
        
        let difference = currentSpending - previousSpending
        let percentageChange = previousSpending > 0 ? (difference / previousSpending) * 100 : 0
        
        return SpendingTrend(
            currentAmount: currentSpending,
            previousAmount: previousSpending,
            difference: difference,
            percentageChange: percentageChange
        )
    }
    
    // MARK: - Wrapped-Style Insights
    
    /// Generate fun, shareable insights for the Wrapped view
    func generateWrappedInsights() -> WrappedInsights {
        let calendar = Calendar.current
        let now = Date()
        
        // This month's data
        let thisMonthStart = calendar.dateInterval(of: .month, for: now)?.start ?? now
        let thisMonthEnd = calendar.dateInterval(of: .month, for: now)?.end ?? now
        let thisMonthSpending = totalSpending(from: thisMonthStart, to: thisMonthEnd)
        let thisMonthCategories = spendingByCategory(from: thisMonthStart, to: thisMonthEnd)
        
        // Last month's data for comparison
        let lastMonthStart = calendar.date(byAdding: .month, value: -1, to: thisMonthStart) ?? now
        let lastMonthEnd = calendar.date(byAdding: .month, value: -1, to: thisMonthEnd) ?? now
        let lastMonthSpending = totalSpending(from: lastMonthStart, to: lastMonthEnd)
        
        // This year's data
        let thisYearStart = calendar.dateInterval(of: .year, for: now)?.start ?? now
        let thisYearEnd = calendar.dateInterval(of: .year, for: now)?.end ?? now
        let thisYearSpending = totalSpending(from: thisYearStart, to: thisYearEnd)
        
        return WrappedInsights(
            totalThisMonth: thisMonthSpending,
            totalLastMonth: lastMonthSpending,
            totalThisYear: thisYearSpending,
            topCategory: thisMonthCategories.first?.category ?? "Unknown",
            topCategoryAmount: thisMonthCategories.first?.total ?? 0,
            largestExpense: largestExpense(from: thisMonthStart, to: thisMonthEnd),
            averageDailySpending: averageDailySpending(from: thisMonthStart, to: thisMonthEnd),
            totalTransactions: countTransactions(from: thisMonthStart, to: thisMonthEnd),
            categoryBreakdown: thisMonthCategories
        )
    }
    
    /// Count total transactions in a date range
    private func countTransactions(from startDate: Date, to endDate: Date) -> Int {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", 
                                      startDate as NSDate, endDate as NSDate)
        
        do {
            return try viewContext.fetch(request).count
        } catch {
            print("Error counting transactions: \(error)")
            return 0
        }
    }
}

// MARK: - Data Models

struct CategorySpending: Identifiable {
    let id = UUID()
    let category: String
    let total: Double
    let count: Int
    let average: Double
}

struct SpendingTrend {
    let currentAmount: Double
    let previousAmount: Double
    let difference: Double
    let percentageChange: Double
    
    var isIncreasing: Bool { difference > 0 }
    var isDecreasing: Bool { difference < 0 }
}

struct WrappedInsights {
    let totalThisMonth: Double
    let totalLastMonth: Double
    let totalThisYear: Double
    let topCategory: String
    let topCategoryAmount: Double
    let largestExpense: Expense?
    let averageDailySpending: Double
    let totalTransactions: Int
    let categoryBreakdown: [CategorySpending]
    
    /// Generate a fun comparison percentage (simulated aggregate data)
    var topCategoryComparison: Int {
        // Simulate comparison with other users
        let basePercentage = Int.random(in: 60...85)
        return basePercentage
    }
    
    /// Generate spending comparison (simulated)
    var spendingComparison: Int {
        // Simulate comparison with other users
        let basePercentage = Int.random(in: 45...75)
        return basePercentage
    }
}
