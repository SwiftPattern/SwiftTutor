import SwiftUI

struct AnswerFeedbackView: View {
    let isCorrect: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: isCorrect ? "checkmark.seal.fill" : "xmark.octagon.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(isCorrect ? .green : .red)

                Text(isCorrect ? "Correct!" : "Incorrect")
                    .font(.title2.bold())
                    .foregroundColor(.white)
            }
            .padding(24)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(12)
        }
        .transition(.opacity)
    }
}
