import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("SettingsView")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Coming Soon!")
                .font(.title2)
                .foregroundColor(.secondary)

            Spacer()
        }
        .navigationTitle("SettingsView")
    }
}
