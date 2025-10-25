import Foundation
import Combine

/// Manages saving & loading of quiz session history for analytics.
final class StatisticsService: ObservableObject {

    // MARK: - Published

    @Published private(set) var sessions: [SessionRecord] = []

    // MARK: - Private

    private let key = "SessionHistory"

    // MARK: - Init

    init() {
        load()
    }

    // MARK: - Public API

    /// Add a new session and persist.
    func addSession(_ session: SessionRecord) {
        sessions.insert(session, at: 0)
        save()
    }

    /// Sessions from the most recent quiz only
    var lastSession: SessionRecord? {
        sessions.first
    }

    /// Sessions whose startDate is within the last `days` days
    func sessions(inLast days: Int) -> [SessionRecord] {
        let cutoff = Calendar.current.date(
            byAdding: .day,
            value: -days,
            to: Date()
        )!
        return sessions.filter { $0.startDate >= cutoff }
    }

    /// Aggregate accuracy over the last `days` days
    func accuracy(inLast days: Int) -> Double {
        let recent = sessions(inLast: days)
        guard !recent.isEmpty else { return 0 }
        return recent.map(\.accuracy).reduce(0, +) / Double(recent.count)
    }

    /// Total questions answered in last `days`
    func totalAnswered(inLast days: Int) -> Int {
        sessions(inLast: days).map(\.totalCount).reduce(0, +)
    }

    // MARK: - Persistence

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let decoded = try? JSONDecoder().decode([SessionRecord].self, from: data)
        else {
            sessions = []
            return
        }
        sessions = decoded
    }

    private func save() {
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

