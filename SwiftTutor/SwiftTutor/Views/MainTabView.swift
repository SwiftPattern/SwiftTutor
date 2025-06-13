import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var analyticsViewModel: AnalyticsReportViewModel
    @EnvironmentObject var questionViewModel: QuestionViewModel
    @EnvironmentObject var settingsService: SettingsService

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            NavigationStack {
                QuestionView(viewModel: questionViewModel)
            }
            .tabItem {
                Label("Quiz", systemImage: "questionmark.circle")
            }
            .tag(AppTab.quiz)

            NavigationStack {
                AnalyticsReportView(viewModel: analyticsViewModel)
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
