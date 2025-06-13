import SwiftUI

struct AnswerOptionView: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                Color.clear
                HStack {
                    Text(text)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.accentColor)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.accentColor : Color(UIColor.systemGray4),
                                lineWidth: isSelected ? 2 : 1)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
