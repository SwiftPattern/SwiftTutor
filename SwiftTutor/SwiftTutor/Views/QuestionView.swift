import SwiftUI

struct QuestionView: View {
    @ObservedObject var viewModel: QuestionViewModel
    @State private var helpSheetText: String?

    var body: some View {
        VStack(spacing: 16) {

            // 1. Title Bar: “Question X/Y” + Help Button
            HStack {
                Text("Question \(viewModel.currentIndex + 1)/\(viewModel.totalQuestions)")
                    .font(.headline)

                Spacer()

                Button {
                    viewModel.toggleHelp()
                } label: {
                    Image(systemName: "questionmark.circle")
                        .imageScale(.large)
                }
            }
            .padding(.horizontal)

            // 2. Progress Bar
            ProgressBarView(progress: viewModel.progressFraction)
                .frame(height: 8)
                .padding(.horizontal)

            // 3. Scrollable Content: Info Block, Question Text, Answer Options
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // 3b. Question Text
                    if let questionText = viewModel.currentQuestion?.questionText {
                        Text(questionText)
                            .font(.body)
                            .padding(.horizontal)
                    }

                    // 3a. Information Block (Markdown)
                    if let info = viewModel.currentQuestion?.infoMarkdown,
                       !info.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    {
                        InfoBlockView(markdownText: info)
                            .padding(.horizontal)
                    }

                    // 3c. Answer Options
                    if let options = viewModel.currentQuestion?.options {
                        VStack(spacing: 12) {
                            ForEach(options.indices, id: \.self) { idx in
                                AnswerOptionView(
                                    text: options[idx],
                                    isSelected: viewModel.selectedOptionIndex == idx
                                ) {
                                    viewModel.selectAnswer(at: idx)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 12)
            }

            // 4. Submit Button
            SubmitButtonView(
                title: "Submit",
                isEnabled: viewModel.isSubmitEnabled
            ) {
                viewModel.submitAnswer(withTimer: false)
            }
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
        .navigationTitle("")            // Hiding default nav bar title
        .navigationBarHidden(true)
        // MARK: - Help Sheet
        .onChange(of: viewModel.showHelp) { oldValue, newValue in
            if newValue {
                helpSheetText = viewModel.currentQuestion?.helpPromptMarkdown
                ?? "No help available."
            }
        }
        .sheet(isPresented: $viewModel.showHelp, onDismiss: {
                helpSheetText = nil   // clear for next time
            }) {
                HelpView(markdownText: helpSheetText ?? "No help available.") {
                    viewModel.toggleHelp()
                }
            }
        // MARK: - Answer Feedback Overlay
        .overlay {
            if viewModel.showAnswerFeedback {
                AnswerFeedbackView(isCorrect: viewModel.isAnswerCorrect)
                    .transition(.opacity)
            }
        }
        .onAppear {
            viewModel.onQuizAppear()
        }
    }
}

