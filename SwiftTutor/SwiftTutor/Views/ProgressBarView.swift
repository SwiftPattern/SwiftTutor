import SwiftUI

struct ProgressBarView: View {
    /// A value between 0.0 and 1.0
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(Color(UIColor.systemGray5))

                // Foreground fill
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(Color.accentColor)
                    .frame(width: max(0, CGFloat(progress) * geo.size.width))
            }
        }
        .cornerRadius(4)
    }
}
