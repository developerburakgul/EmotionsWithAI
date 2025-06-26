import SwiftUI

struct EmptyAnalysisResultView: View {
    let name: String
    let sinceDate: Date?
    let dismissAction: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Image(systemName: "exclamationmark.bubble.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .foregroundColor(.orange)

            VStack(spacing: 12) {
                Text(name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)

                Text("Since \(formattedDate)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 8) {
                Text("No Emotional Messages Detected")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("We couldn’t find enough expressive messages with \(name). Try selecting another conversation or wait for more messages.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Spacer()

            Button(action: dismissAction) {
                Image(systemName: "xmark")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 64, height: 64)
                    .background(Circle().fill(Color.red))
                    .shadow(radius: 4)
            }
            .padding(.bottom, 32)
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(UIColor.systemBackground), Color(UIColor.secondarySystemBackground)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .toolbarVisibility(.hidden, for: .navigationBar)
    }

    private var formattedDate: String {
        guard let sinceDate = sinceDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .long // örn: June 22, 2025
        formatter.timeStyle = .none
        return formatter.string(from: sinceDate)
    }
}


#Preview {
    EmptyAnalysisResultView(
        name: "Batuhan",
        sinceDate: Date(), // örnek olarak şimdi
        dismissAction: { /* dismiss kodu */ }
    )

}
