import SwiftUI

struct AchievementsView: View {
    var body: some View {
        VStack {
            Text("AchievementsView")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Coming Soon!")
                .font(.title2)
                .foregroundColor(.secondary)

            Spacer()
        }
        .navigationTitle("AchievementsView")
    }
}
