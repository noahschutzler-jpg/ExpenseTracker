import SwiftUI
import CoreData

struct AddExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var amount: String = ""
    @State private var selectedCategory: ExpenseCategory = .other
    @State private var description: String = ""
    @State private var selectedDate: Date = Date()
    @State private var showingDatePicker = false
    @State private var isRecurring: Bool = false
    @State private var selectedFrequency: RecurrenceFrequency = .weekly
    @State private var customInterval: String = "1"
    @State private var customUnit: String = "weeks"
    
    var isValidExpense: Bool {
        !amount.isEmpty && Double(amount) != nil && Double(amount)! > 0
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Amount input section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Amount")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            Text("$")
                                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.secondary)
                            
                            TextField("0.00", text: $amount)
                                .keyboardType(.decimalPad)
                                .font(.system(size: 32, weight: .bold))
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Category selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Category")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(ExpenseCategory.allCases) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    HStack(spacing: 8) {
                                        Text(category.icon)
                                            .font(.title2)
                                        
                                        Text(category.rawValue)
                                            .font(.subheadline)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(2)
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(selectedCategory == category ? 
                                              Color(hex: category.color).opacity(0.2) : 
                                              Color(.systemGray6))
                                    .foregroundColor(selectedCategory == category ? 
                                                   Color(hex: category.color) : 
                                                   .primary)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedCategory == category ? 
                                                  Color(hex: category.color) : 
                                                  Color.clear, lineWidth: 2)
                                    )
                                }
                            }
                        }
                    }
                    
                    // Description input
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Description (Optional)")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("What did you spend on?", text: $description)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    
                    // Date selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Date")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Button(action: {
                            showingDatePicker = true
                        }) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(themeManager.accentColor)
                                
                                Text(selectedDate, style: .date)
                                    .foregroundColor(.primary)

            Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    
                    // Recurring expense toggle
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "repeat")
                                .foregroundColor(.orange)
                                .frame(width: 24)
                            
                            Toggle("Recurring Expense", isOn: $isRecurring)
                                .font(.headline)
                        }
                        
                        if isRecurring {
                            VStack(spacing: 12) {
                                // Frequency selection
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Frequency")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                        ForEach(RecurrenceFrequency.allCases) { frequency in
                                            Button(action: {
                                                selectedFrequency = frequency
                                            }) {
                                                HStack(spacing: 6) {
                                                    Text(frequency.icon)
                                                        .font(.title3)
                                                    
                                                    Text(frequency.rawValue)
                                                        .font(.caption)
                                                        .fontWeight(.medium)
                                                }
                                                .padding(.vertical, 8)
                                                .padding(.horizontal, 12)
                                                .frame(maxWidth: .infinity)
                                                .background(selectedFrequency == frequency ? 
                                                          themeManager.accentColor.opacity(0.2) : 
                                                          Color(.systemGray6))
                                                .foregroundColor(selectedFrequency == frequency ? 
                                                               themeManager.accentColor : 
                                                               .primary)
                                                .cornerRadius(8)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(selectedFrequency == frequency ? 
                                                              themeManager.accentColor : 
                                                              Color.clear, lineWidth: 1)
                                                )
                                            }
                                        }
                                    }
                                }
                                
                                // Custom interval input (only for custom frequency)
                                if selectedFrequency == .custom {
                                    HStack(spacing: 12) {
                                        TextField("1", text: $customInterval)
                                            .keyboardType(.numberPad)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .frame(width: 60)
                                        
                                        Picker("Unit", selection: $customUnit) {
                                            Text("Days").tag("days")
                                            Text("Weeks").tag("weeks")
                                            Text("Months").tag("months")
                                        }
                                        .pickerStyle(SegmentedPickerStyle())
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6).opacity(0.5))
                            .cornerRadius(12)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveExpense()
                    }
                    .disabled(!isValidExpense)
                    .foregroundColor(isValidExpense ? themeManager.accentColor : .gray)
                }
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerSheet(selectedDate: $selectedDate)
        }
    }
    
    private func saveExpense() {
        guard let amountValue = Double(amount) else { return }
        
        let newExpense = Expense.create(
            in: viewContext,
            amount: amountValue,
            category: selectedCategory.rawValue,
            description: description.isEmpty ? nil : description,
            date: selectedDate
        )
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving expense: \(error)")
        }
    }
}

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
