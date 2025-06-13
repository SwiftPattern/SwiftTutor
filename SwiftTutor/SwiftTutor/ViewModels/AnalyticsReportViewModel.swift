import SwiftUI
import Combine

enum AnalyticsScope: Int, CaseIterable, Identifiable {
    case lastSession, lastWeek, lastMonth

    var id: Int { rawValue }
    var title: String {
        switch self {
        case .lastSession: return "Last Session"
        case .lastWeek:    return "Last Week"
        case .lastMonth:   return "Last Month"
        }
    }

    /// days window for weekly/monthly scopes
    var days: Int? {
        switch self {
        case .lastSession: return nil
        case .lastWeek:    return 7
        case .lastMonth:   return 30
        }
    }
}

final class AnalyticsReportViewModel: ObservableObject {

    @Published var scope: AnalyticsScope = .lastSession

    @Published private(set) var sessions: [SessionRecord] = []
    @Published private(set) var accuracy: Double = 0
    @Published private(set) var totalAnswered: Int = 0

    private let stats: StatisticsService
    private var cancellables = Set<AnyCancellable>()

    init(statisticsService: StatisticsService) {
        self.stats = statisticsService

        // whenever sessions or scope change, recompute
        Publishers.CombineLatest(
            statisticsService.$sessions,
            $scope
        )
        .sink { [weak self] sessions, scope in
            self?.update(sessions: sessions, scope: scope)
        }
        .store(in: &cancellables)
    }

    private func update(sessions: [SessionRecord], scope: AnalyticsScope) {
        switch scope {
        case .lastSession:
            if let last = sessions.first {
                self.sessions = [last]
                self.accuracy = last.accuracy
                self.totalAnswered = last.totalCount
            } else {
                self.sessions = []
                self.accuracy = 0
                self.totalAnswered = 0
            }
        case .lastWeek, .lastMonth:
            let days = scope.days!
            let recent = stats.sessions(inLast: days)
            self.sessions = recent
            self.accuracy = stats.accuracy(inLast: days)
            self.totalAnswered = stats.totalAnswered(inLast: days)
        }
    }
}
