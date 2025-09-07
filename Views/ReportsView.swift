import SwiftUI

struct ReportsView: View {
    var body: some View {
        VStack {
            Text("ReportsView")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Coming Soon!")
                .font(.title2)
                .foregroundColor(.secondary)

            Spacer()
        }
        .navigationTitle("ReportsView")
    }
}
