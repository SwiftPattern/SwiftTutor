import SwiftUI

struct MainTabView: View {
    @ObservedObject var settingsService: SettingsService
    @ObservedObject var statisticsService: StatisticsService
    @ObservedObject var appState: AppState
    @ObservedObject var questionService: QuestionService

    init(
        settingsService: SettingsService,
        statisticsService: StatisticsService,
        appState: AppState,
        questionService: QuestionService
    ) {
        self.settingsService = settingsService
        self.statisticsService = statisticsService
        self.appState = appState
        self.questionService = questionService
    }

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            NavigationStack {
                QuestionView(
                    questionService: questionService, settingService: settingsService,
                    statsService: statisticsService, appState: appState
                )
            }
            .tabItem {
                Label("Quiz", systemImage: "questionmark.circle")
            }
            .tag(AppTab.quiz)

            NavigationStack {
                AnalyticsReportView(statisticsService: statisticsService)
            }
            .tabItem {
                Label("Analytics", systemImage: "chart.bar")
            }
            .tag(AppTab.analytics)

            NavigationStack {
                SettingsView(settingsService: settingsService)
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(AppTab.settings)
        }
    }
}
