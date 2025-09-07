import SwiftUI
import CoreData

struct QuickAddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager

    let category: ExpenseCategory
    let suggestedAmount: Double?

    @State private var amount: String = ""
    @State private var description: String = ""

    var isValidExpense: Bool {
        !amount.isEmpty && Double(amount) != nil && Double(amount)! > 0
    }

    var body: some View {
        VStack(spacing: 20) {
            // Category header
            HStack {
                ZStack {
                    Circle()
                        .fill(Color(hex: category.color))
                        .frame(width: 60, height: 60)

                    Text(category.icon)
                        .font(.system(size: 30))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Quick Add")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(category.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top)

            // Amount input
            VStack(alignment: .leading, spacing: 8) {
                Text("Amount")
                    .font(.headline)

                TextField("$0.00", text: $amount)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .onAppear {
                        if let suggested = suggestedAmount {
                            amount = String(format: "%.2f", suggested)
                        }
                    }
            }

            // Description
            VStack(alignment: .leading, spacing: 8) {
                Text("Description (Optional)")
                    .font(.headline)

                TextField("What did you spend on?", text: $description)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }

            Spacer()

            // Quick amount buttons
            VStack(alignment: .leading, spacing: 12) {
                Text("Quick Amounts")
                    .font(.headline)

                let quickAmounts = getQuickAmounts(for: category)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                    ForEach(quickAmounts, id: \.self) { quickAmount in
                        Button(action: {
                            amount = String(format: "%.2f", quickAmount)
                        }) {
                            Text("$\(quickAmount, specifier: "%.0f")")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(.systemGray6))
                                .foregroundColor(.primary)
                                .cornerRadius(8)
                        }
                    }
                }
            }

            // Save button
            Button(action: saveExpense) {
                Text("Save Expense")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(isValidExpense ? themeManager.accentColor : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(!isValidExpense)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3).ignoresSafeArea().onTapGesture { dismiss() })
    }

    private func getQuickAmounts(for category: ExpenseCategory) -> [Double] {
        switch category {
        case .foodAndDining:
            return [5, 10, 15, 20, 25, 30]
        case .fuel:
            return [20, 30, 40, 50, 60, 70]
        case .vehicleMaintenance:
            return [50, 100, 150, 200, 300, 500]
        case .rentMortgage:
            return [500, 800, 1000, 1200, 1500, 2000]
        case .shopping:
            return [25, 50, 75, 100, 150, 200]
        case .entertainment:
            return [10, 20, 30, 50, 75, 100]
        case .utilities:
            return [50, 75, 100, 125, 150, 200]
        case .healthcare:
            return [25, 50, 75, 100, 150, 200]
        case .travel:
            return [50, 100, 200, 300, 500, 1000]
        case .other:
            return [10, 25, 50, 75, 100, 200]
        }
    }

    private func saveExpense() {
        guard let amountValue = Double(amount) else { return }

        let newExpense = Expense(context: viewContext)
        newExpense.id = UUID()
        newExpense.amount = amountValue
        newExpense.category = category.rawValue
        newExpense.desc = description.isEmpty ? nil : description
        newExpense.date = Date()

        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving expense: \(error)")
        }
    }
}
