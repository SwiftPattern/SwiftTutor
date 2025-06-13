import SwiftUI

struct SubmitButtonView: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(isEnabled ? Color.accentColor : Color(UIColor.systemGray3))
                .cornerRadius(8)
        }
        .disabled(!isEnabled)
    }
}
