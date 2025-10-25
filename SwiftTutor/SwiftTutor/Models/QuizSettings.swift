// Models/QuizSettings.swift

import Foundation

/// Represents all user‐configurable quiz settings.
struct QuizSettings: Codable {
    /// Max minutes allowed per question
    var limitInMins: Int

    /// If true, each question is time‐limited to `limitInMins`
    var isTimeLimited: Bool

    /// If true, show the help prompt automatically after a wrong answer
    var showHintAfterError: Bool

    /// If true, questions appear in a random order
    var randomOrder: Bool
}

