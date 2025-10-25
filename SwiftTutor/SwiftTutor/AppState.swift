import SwiftUI

/// Represents the three tabs in the app
enum AppTab: Hashable {
    case quiz, analytics, settings
}

/// Shared app‐wide state (current tab)
final class AppState: ObservableObject {
    @Published var selectedTab: AppTab = .quiz
}

