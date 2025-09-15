import SwiftUI

struct OnboardingView: View {
    @AppStorage("onboardingCompleted") private var onboardingCompleted = false

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Text("ðŸ’°")
                .font(.system(size: 80))

            Text("PocketWatch")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Track your expenses with ease")
                .font(.title2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 16) {
                HStack {
                    Text("ðŸ“Š")
                        .font(.title)
                    VStack(alignment: .leading) {
                        Text("Smart Analytics")
                            .font(.headline)
                        Text("Get insights into your spending habits")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }

                HStack {
                    Text("ðŸŽ¯")
                        .font(.title)
                    VStack(alignment: .leading) {
                        Text("Budget Goals")
                            .font(.headline)
                        Text("Set and track your financial goals")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }

                HStack {
                    Text("ðŸ“±")
                        .font(.title)
                    VStack(alignment: .leading) {
                        Text("Easy to Use")
                            .font(.headline)
                        Text("Simple interface for daily expense tracking")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
            }
            .padding(.horizontal)

            Spacer()

            Button(action: {
                onboardingCompleted = true
            }) {
                Text("Get Started")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.teal)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
