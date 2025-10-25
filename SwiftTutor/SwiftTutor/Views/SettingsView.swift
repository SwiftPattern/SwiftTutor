import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsService: SettingsService
    @Environment(\.dismiss) var dismiss

  var body: some View {
    NavigationStack {
      Form {
        Section("Timer") {
          Toggle("Enable time limit", isOn: $settingsService.settings.isTimeLimited)
          if settingsService.settings.isTimeLimited {
            Stepper(
              "Limit (mins): \(settingsService.settings.limitInMins)",
              value: $settingsService.settings.limitInMins,
              in: 1...60
            )
          }
        }

        Section("Behavior") {
          Toggle(
            "Show hint after wrong answer",
            isOn: $settingsService.settings.showHintAfterError
          )
          Toggle(
            "Randomize question order",
            isOn: $settingsService.settings.randomOrder
          )
        }
      }
      .navigationTitle("Settings")
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("Done") { dismiss() }
        }
      }
    }
  }
}

