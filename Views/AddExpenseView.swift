import SwiftUI

struct AddExpenseView: View {
    var body: some View {
        VStack {
            Text("AddExpenseView")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Coming Soon!")
                .font(.title2)
                .foregroundColor(.secondary)

            Spacer()
        }
        .navigationTitle("AddExpenseView")
    }
}
