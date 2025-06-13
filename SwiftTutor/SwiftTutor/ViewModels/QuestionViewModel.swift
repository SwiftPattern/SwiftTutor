// ViewModels/QuestionViewModel.swift

import SwiftUI
import Combine

/// UI‐loading states for question data
enum LoadingState: Equatable {
    case loading
    case loaded
    case failed(message: String)
}

final class QuestionViewModel: ObservableObject {

    // MARK: - Published (UI) Properties

    @Published private(set) var loadingState: LoadingState = .loading
    @Published private(set) var questions: [Question] = []

    @Published var currentIndex: Int = 0
    @Published var selectedOptionIndex: Int? = nil

    // Tracks how many answers were correct
    @Published private(set) var correctCount: Int = 0

    // When true we navigate to the finish screen
    @Published var isQuizFinished: Bool = false

    // Used to show the Help sheet
    @Published var showHelp: Bool = false

    // Briefly overlay right/wrong feedback
    @Published var showAnswerFeedback: Bool = false
    @Published var isAnswerCorrect: Bool = false


    // MARK: - Computed Properties

    var totalQuestions: Int { questions.count }

    var currentQuestion: Question? {
        guard (0..<questions.count).contains(currentIndex) else { return nil }
        return questions[currentIndex]
    }

    /// 0.0…1.0 for the progress bar
    var progressFraction: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(currentIndex + 1) / Double(totalQuestions)
    }

    /// Submit enabled only when an option is selected and data is loaded
    var isSubmitEnabled: Bool {
        selectedOptionIndex != nil && loadingState == .loaded
    }


    // MARK: - Dependencies

    private let questionService: QuestionService
    private let settingsService: SettingsService
    private let statsService: StatisticsService
    private let appState: AppState


    // MARK: - Internal State for Analytics

    private var quizStartDate = Date()
    private var answerRecords: [AnswerRecord] = []
    private var questionStartTime = Date()
    private var timerCancellable: AnyCancellable?


    // MARK: - Combine

    private var cancellables = Set<AnyCancellable>()


    // MARK: - Initialization

    init(
        questionService: QuestionService,
        settingsService: SettingsService,
        statsService: StatisticsService,
        appState: AppState
    ) {
        self.questionService = questionService
        self.settingsService = settingsService
        self.statsService = statsService
        self.appState = appState

        // Reload whenever randomOrder toggles
        settingsService.$settings
            .map(\.randomOrder)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.loadQuestions()
            }
            .store(in: &cancellables)

        loadQuestions()
    }


    // MARK: - Loading Questions

    private func loadQuestions() {
        loadingState = .loading

        let loaded = questionService.questions
        guard !loaded.isEmpty else {
            loadingState = .failed(message: "No questions available.")
            return
        }

        questions     = settingsService.settings.randomOrder ? loaded.shuffled() : loaded
        loadingState  = .loaded
        resetQuiz()
    }


    // MARK: - Reset

    private func resetQuiz() {
        currentIndex      = 0
        correctCount      = 0
        isQuizFinished    = false
        showAnswerFeedback = false
        showHelp          = false

        answerRecords.removeAll()
        quizStartDate = Date()

        scheduleTimerForCurrentQuestion()
    }


    // MARK: - Answer Selection

    func selectAnswer(at index: Int) {
        if selectedOptionIndex == index {
            selectedOptionIndex = nil
        } else {
            selectedOptionIndex = index
        }
    }


    // MARK: - Submit Answer

    func submitAnswer(withTimer: Bool) {
        guard let currentQ = currentQuestion else { return }
        var correct = false
        let now = Date()
        if let selected = selectedOptionIndex {
            correct = questionService.isCorrectAnswer(
                questionIndex: currentIndex,
                selectedIndex: selected
            )

        }

        isAnswerCorrect = correct
        if correct { correctCount += 1 }

        // Record analytics
        let timeTaken: TimeInterval? = settingsService.settings.isTimeLimited
            ? now.timeIntervalSince(questionStartTime)
            : nil

        answerRecords.append(
            AnswerRecord(
                questionID: currentQ.id,
                wasCorrect: correct,
                timestamp: now,
                timeTaken: timeTaken
            )
        )


        showAnswerFeedback = true
        timerCancellable?.cancel()

        if !correct && settingsService.settings.showHintAfterError {
            showHelp = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.advanceOrFinish()
        }
    }


    // MARK: - Time Limit Handling

    private func scheduleTimerForCurrentQuestion() {
        timerCancellable?.cancel()
        questionStartTime = Date()

        guard settingsService.settings.isTimeLimited else { return }

        let seconds = Double(settingsService.settings.limitInMins) * 60
        timerCancellable = Just(())
            .delay(for: .seconds(seconds), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.submitAnswer(withTimer: true)
            }
    }


    // MARK: - Advance / Finish

    private func advanceOrFinish() {
        showAnswerFeedback = false
        selectedOptionIndex = nil

        if currentIndex + 1 < totalQuestions {
            currentIndex += 1
            scheduleTimerForCurrentQuestion()
        } else {
            // Build and save session
            let session = SessionRecord(
                id: UUID(),
                startDate: quizStartDate,
                endDate: Date(),
                answers: answerRecords
            )
            statsService.addSession(session)

            // Prepare a fresh quiz for the next run
            if settingsService.settings.randomOrder {
                // reshuffle for a brand-new session
                questions.shuffle()
            }
            resetQuiz(startTimer: false)   // reset to Q1, but don't start timer off-screen

            // Navigate to Analytics tab
            appState.selectedTab = .analytics
        }
    }

    func onQuizAppear() {
        // Only (re)start the timer when the quiz view is visible
        if settingsService.settings.isTimeLimited {
            scheduleTimerForCurrentQuestion()
        }
    }


    // MARK: - Help Toggle

    func toggleHelp() {
        showHelp.toggle()
    }

    // MARK: - Reset

    private func resetQuiz(startTimer: Bool = true) {
        timerCancellable?.cancel()
        currentIndex       = 0
        correctCount       = 0
        isQuizFinished     = false
        showAnswerFeedback = false
        showHelp           = false

        answerRecords.removeAll()
        quizStartDate = Date()

        if startTimer {
            scheduleTimerForCurrentQuestion()
        }
    }
}
