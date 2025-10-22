import SwiftUI

struct AchievementRow: View {
    let achievement: Achievement

    var statusColor: Color {
        switch achievement.status {
        case .locked: return .gray
        case .inProgress: return .orange
        case .unlocked: return .green
        }
    }

    var statusIcon: String {
        switch achievement.status {
        case .locked: return "lock.fill"
        case .inProgress: return "clock.fill"
        case .unlocked: return "checkmark.circle.fill"
        }
    }

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: statusIcon)
                .font(.title2)
                .foregroundColor(statusColor)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.poppins(size: 14, weight: .semibold))

                Text(achievement.description)
                    .font(.poppins(size: 12, weight: .regular))
                    .foregroundColor(.gray)
                    .lineLimit(2)

                Text("Reward: \(achievement.reward)")
                    .font(.poppins(size: 11, weight: .medium))
                    .foregroundColor(.orange)
            }

            Spacer()

            Text(achievement.status == .inProgress ? "+20" : "")
                .font(.poppins(size: 12, weight: .bold))
                .foregroundColor(.green)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 1)
        .opacity(achievement.status == .locked ? 0.6 : 1.0)
    }
}
