import SwiftUI

@main
struct SwiftTutorApp: App {
    @StateObject private var statsService: StatisticsService
    @StateObject private var questionService: QuestionService
    @StateObject private var appState: AppState
    @StateObject private var settingsService: SettingsService

    @StateObject private var questionViewModel: QuestionViewModel
    @StateObject private var analyticsReportViewModel: AnalyticsReportViewModel

    init() {

        let statsService = StatisticsService()
        let questionService = QuestionService()
        let appState = AppState()
        let settingsService = SettingsService()

        let questionVM = QuestionViewModel(
            questionService: questionService,
            settingsService: settingsService,
            statsService: statsService,
            appState: appState
        )

        let analyticsReportVM = AnalyticsReportViewModel(
            statisticsService: statsService
        )

        _statsService = StateObject(wrappedValue: statsService)
        _questionService = StateObject(wrappedValue: questionService)
        _appState = StateObject(wrappedValue: appState)
        _settingsService = StateObject(wrappedValue: settingsService)

        _questionViewModel = StateObject(wrappedValue: questionVM)
        _analyticsReportViewModel = StateObject(wrappedValue: analyticsReportVM)
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(questionViewModel)
                .environmentObject(analyticsReportViewModel)
                .environmentObject(settingsService)
                .environmentObject(statsService)
                .environmentObject(appState)

        }
    }
}

