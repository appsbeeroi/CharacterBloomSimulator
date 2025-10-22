import SwiftUI

struct AchievementBadge: View {
    let achievement: Achievement
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                Image(getAchievementBadgeImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 85, height: 85)
                    .shadow(color: .black.opacity(0.2), radius: 3)

                if achievement.status == .unlocked {
                    Image("badge_shine")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 95, height: 95)
                }

                if achievement.status == .locked && achievement.progress > 0 {
                    VStack {
                        Spacer()

                        Text("\(achievement.progress)/\(achievement.target)")
                            .font(.poppins(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(Color.black.opacity(0.7))
                            )
                            .offset(y: 8)
                    }
                }
            }
        }
    }

    private func getAchievementBadgeImage() -> String {
        let suffix = achievement.status == .unlocked ? "_unlocked" : "_locked"

        switch achievement.id {
        case "victory_medal":
            return "badge_victory" + suffix
        case "care_medal":
            return "badge_care" + suffix
        case "shopping_medal":
            return "badge_shopping" + suffix
        case "collection_medal":
            return "badge_collection" + suffix
        case "daily_login_medal":
            return "badge_daily_login" + suffix
        default:
            return "badge_victory" + suffix
        }
    }
}
