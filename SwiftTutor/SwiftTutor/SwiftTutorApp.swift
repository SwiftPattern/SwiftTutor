import SwiftUI

@main
struct SwiftTutorApp: App {
    @StateObject private var statsService = StatisticsService()
    @StateObject private var questionService = QuestionService()
    @StateObject private var appState = AppState()
    @StateObject private var settingsService = SettingsService()

    var body: some Scene {
        WindowGroup {
            MainTabView(
                settingsService: settingsService, statisticsService: statsService,
                appState: appState, questionService: questionService
            )
        }
    }
}
