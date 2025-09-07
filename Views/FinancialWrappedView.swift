import SwiftUI

struct FinancialWrappedView: View {
    var body: some View {
        VStack {
            Text("FinancialWrappedView")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Coming Soon!")
                .font(.title2)
                .foregroundColor(.secondary)

            Spacer()
        }
        .navigationTitle("FinancialWrappedView")
    }
}
