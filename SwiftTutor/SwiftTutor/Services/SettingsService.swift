// Services/SettingsService.swift

import Foundation
import Combine

/// Manages loading & saving of QuizSettings via UserDefaults.
final class SettingsService: ObservableObject {

    // MARK: - Published Properties

    @Published var settings: QuizSettings

    // MARK: - Private

    private let userDefaultsKey = "QuizSettings"
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init() {
        // 1) Attempt to decode from UserDefaults
        if
          let data = UserDefaults.standard.data(forKey: userDefaultsKey),
          let decoded = try? JSONDecoder().decode(QuizSettings.self, from: data)
        {
            settings = decoded
        } else {
            // 2) Fallback defaults
            settings = QuizSettings(
              limitInMins: 2,
              isTimeLimited: false,
              showHintAfterError: false,
              randomOrder: false
            )
        }

        // 3) Save on any change
        $settings
          .dropFirst()
          .sink { [weak self] new in
            guard let self = self else { return }
            if let data = try? JSONEncoder().encode(new) {
                UserDefaults.standard.set(data, forKey: self.userDefaultsKey)
            }
          }
          .store(in: &cancellables)
    }
}

