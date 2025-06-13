import SwiftUI

struct InfoBlockView: View {
    let markdownText: String

    var body: some View {
        VStack(alignment: .leading) {
            if #available(iOS 15.0, *) {
                // Render Markdown as an AttributedString
                Text(try! AttributedString(markdown: markdownText))
                    .font(.system(.body, design: .monospaced))
                    .padding(12)
            } else {
                // Fallback for older iOS versions (plain text)
                Text(markdownText)
                    .font(.system(.body, design: .monospaced))
                    .padding(12)
            }
        }
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
    }
}
