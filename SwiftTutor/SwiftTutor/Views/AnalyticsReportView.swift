import SwiftUI

struct AnalyticsReportView: View {
    
    @ObservedObject private var viewModel: AnalyticsReportViewModel

    init(viewModel: AnalyticsReportViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 16) {
            // 1) Scope selector
            Picker("", selection: $viewModel.scope) {
                ForEach(AnalyticsScope.allCases) { scope in
                    Text(scope.title).tag(scope)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            // 2) Summary cards
            HStack(spacing: 12) {
                SummaryCard(title: "Accuracy", value: String(format: "%.0f%%", viewModel.accuracy * 100))
                SummaryCard(title: "Answered", value: "\(viewModel.totalAnswered)")
            }
            .padding(.horizontal)

            // 3) Chart
            ChartView(sessions: viewModel.sessions)
                .frame(height: 200)
                .padding(.horizontal)

            // 4) Session list
            List(viewModel.sessions) { session in
                HStack {
                    Text(session.startDate, style: .date)
                    Spacer()
                    Text(String(format: "%.0f%%", session.accuracy * 100))
                }
            }
        }
        .navigationTitle("Analytics")
    }
}

private struct SummaryCard: View {
    let title: String
    let value: String
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title2.bold())
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
    }
}

/// Simple line‐or‐bar chart plotting `accuracy` over sessions
private struct ChartView: View {
    let sessions: [SessionRecord]

    var body: some View {
        GeometryReader { geo in
            if sessions.isEmpty {
                Text("No data")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Path { path in
                    let w = geo.size.width
                    let h = geo.size.height
                    let maxCount = sessions.count
                    for (i, session) in sessions.enumerated() {
                        let x = w * (CGFloat(i) / CGFloat(maxCount - 1))
                        let y = h * (1 - CGFloat(session.accuracy))
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.accentColor, lineWidth: 2)
            }
        }
    }
}

