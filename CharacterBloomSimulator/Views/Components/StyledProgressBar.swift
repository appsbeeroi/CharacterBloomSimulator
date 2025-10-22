import SwiftUI

struct StyledProgressBar: View {
    let icon: String
    let title: String
    let value: Int
    let backgroundColor: Color
    let progressColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 3) {
                Image(icon)
                    .resizable()
                    .frame(width: 14, height: 14)

                Text(title)
                    .font(.poppins(size: 9, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 7)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                backgroundColor.opacity(0.3),
                                backgroundColor.opacity(0.5)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.white.opacity(0.6), lineWidth: 1)
                    )

                RoundedRectangle(cornerRadius: 5)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                progressColor,
                                progressColor.opacity(0.7)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(6, CGFloat(value) / 100.0 * 75), height: 8)
                    .shadow(color: progressColor.opacity(0.5), radius: 1, x: 0, y: 1)
                    .animation(.spring(response: 0.5), value: value)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 6)
        .padding(.vertical, 6)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    backgroundColor,
                    backgroundColor.opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.8), lineWidth: 1.5)
        )
        .shadow(color: backgroundColor.opacity(0.4), radius: 3, x: 0, y: 1)
    }
}
