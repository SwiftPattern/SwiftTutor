import Foundation

/// Records a single answered question (or timeout) for analytics.
struct AnswerRecord: Codable {
    let questionID: Int
    let wasCorrect: Bool
    let timestamp: Date
    let timeTaken: TimeInterval?  // seconds spent answering, if timed
}

