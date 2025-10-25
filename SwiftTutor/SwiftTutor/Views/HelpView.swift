import SwiftUI

struct HelpView: View {
    let markdownText: String
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                if #available(iOS 15.0, *) {
                    Text(try! AttributedString(markdown: markdownText))
                        .padding()
                } else {
                    Text(markdownText)
                        .padding()
                }
            }
            .navigationTitle("Help")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onDismiss()
                    }
                }
            }
        }
    }
}
