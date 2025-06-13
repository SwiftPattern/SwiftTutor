import Foundation

final class QuestionService: ObservableObject {

    // MARK: - Properties

    private(set) var questions: [Question] = []

    // MARK: - Initialization

    init() {
        loadQuestionsFromJSON()
    }

    // MARK: - Private Methods

    private func loadQuestionsFromJSON() {
        guard let url = Bundle.main.url(forResource: "Questions", withExtension: "json") else {
            assertionFailure("questions.json not found in bundle.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decoded = try decoder.decode([Question].self, from: data)
            self.questions = decoded
        } catch {
            print("Failed to load or decode questions.json: \(error)")
            self.questions = []
        }
    }

    // MARK: - Public API

    var totalQuestions: Int {
        return questions.count
    }

    func question(at index: Int) -> Question? {
        guard index >= 0, index < questions.count else { return nil }
        return questions[index]
    }

    func isCorrectAnswer(questionIndex: Int, selectedIndex: Int) -> Bool {
        guard
            questionIndex >= 0,
            questionIndex < questions.count,
            selectedIndex >= 0,
            selectedIndex < questions[questionIndex].options.count
        else {
            return false
        }

        return questions[questionIndex].correctIndex == selectedIndex
    }

    func progressFraction(currentIndex: Int) -> Double {
        guard totalQuestions > 0, currentIndex >= 0 else { return 0.0 }
        return Double(currentIndex + 1) / Double(totalQuestions)
    }
}
