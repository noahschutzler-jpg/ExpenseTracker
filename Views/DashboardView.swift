import SwiftUI
import CoreData

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Expense.date, ascending: false)],
        predicate: NSPredicate(format: "date >= %@", Calendar.current.startOfDay(for: Date()) as NSDate),
        animation: .default)
    private var todaysExpenses: FetchedResults<Expense>

    @State private var showingAddExpense = false
    @State private var showingQuickAdd = false
    @State private var selectedQuickAddCategory: ExpenseCategory = .foodAndDining

    var todaysTotal: Double {
        todaysExpenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Today'\''s total
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Today'\''s Spending")
                            .font(.headline)
                            .foregroundColor(.secondary)

                        Text("$\(todaysTotal, specifier: "%.2f")")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // Quick add buttons
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Quick Add")
                            .font(.title3)
                            .fontWeight(.semibold)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(ExpenseCategory.defaultCategories.prefix(6)) { category in
                                Button(action: {
                                    selectedQuickAddCategory = category
                                    showingQuickAdd = true
                                }) {
                                    VStack(spacing: 8) {
                                        Text(category.icon)
                                            .font(.title2)
                                        Text(category.rawValue)
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                    }
                                    .frame(height: 80)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Recent expenses
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Expenses")
                            .font(.title3)
                            .fontWeight(.semibold)

                        ForEach(todaysExpenses.prefix(5)) { expense in
                            HStack {
                                Text(expense.category ?? "Unknown")
                                    .font(.subheadline)
                                Spacer()
                                Text("$\(expense.amount, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("PocketWatch")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddExpense = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView()
            }
            .sheet(isPresented: $showingQuickAdd) {
                QuickAddView(category: selectedQuickAddCategory, suggestedAmount: nil)
            }
        }
    }
}
