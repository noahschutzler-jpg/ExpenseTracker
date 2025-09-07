import SwiftUI

struct RecurringExpensesView: View {
    var body: some View {
        VStack {
            Text("RecurringExpensesView")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Coming Soon!")
                .font(.title2)
                .foregroundColor(.secondary)

            Spacer()
        }
        .navigationTitle("RecurringExpensesView")
    }
}
