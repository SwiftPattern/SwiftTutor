# SwiftTutor — SwiftUI Quiz App

A teaching-oriented iOS app that demonstrates various architectural pattens

---

## Tutorials:

Pick the branch that matches your tutorial and review the starting and ending commits for every YouTube session.
Visit https://www.swiftpattern.com for more.

---

## Features

- **Swift questions** loaded from `Resources/questions.json`
- **MVVM** separation (Views / ViewModels / Services)
- **Settings** (UserDefaults): time limit (mins), enable/disable timing, show hint after wrong answer, randomize order
- **Per-question timer** (optional) — auto-marks wrong on expiry
- **Help** sheet with theory (no spoilers)
- **Analytics**: Last Session / Week / Month with accuracy trend

---

## Requirements

- Xcode 14+
- iOS 16+
- Swift 5.7+

---

## Getting Started

1. **Clone** the repo and open the project in Xcode.
2. Ensure `Resources/questions.json` is included in **Build Phases → Copy Bundle Resources**.
3. Build & run on iOS 16+.

---

## Customizing Questions

Edit `Resources/questions.json` (array of `Question` objects):

```json
{
  "id": 1,
  "questionText": "…",
  "infoMarkdown": "…",
  "options": ["A","B","C","D"],
  "correctIndex": 1,
  "helpPromptMarkdown": "…"
}
```

---

## Notes

- `StatisticsService` is **not** an `ObservableObject`; inject it explicitly where needed (e.g., into `MainTabView` and `AnalyticsReportView`), or wrap in a custom `EnvironmentKey` if preferred.
- The app programmatically switches to **Analytics** on completion and silently resets the quiz to question 1 for the next run.

---

## License

MIT
