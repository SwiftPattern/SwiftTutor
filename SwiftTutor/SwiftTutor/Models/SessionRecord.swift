import Foundation

/// Represents one quiz session (all answered questions).
struct SessionRecord: Codable, Identifiable {
    let id: UUID
    let startDate: Date
    let endDate: Date
    let answers: [AnswerRecord]

    var correctCount: Int { answers.filter { $0.wasCorrect }.count }
    var totalCount: Int   { answers.count }
    var accuracy: Double {
        guard totalCount > 0 else { return 0 }
        return Double(correctCount) / Double(totalCount)
    }
}

