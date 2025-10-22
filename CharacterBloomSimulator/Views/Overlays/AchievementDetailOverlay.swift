import SwiftUI
struct AchievementDetailOverlay: View {
    let achievement: Achievement
    let onClose: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }

            VStack(spacing: 0) {
                ZStack {
                    Image("achievement_detail_panel")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 320)

                    VStack(spacing: 15) {
                        ZStack {
                            Image(getBadgeImageName())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 85, height: 85)

                            if achievement.status == .unlocked {
                                Image("badge_shine")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 95, height: 95)
                            }
                        }

                        Text(achievement.title.uppercased())
                            .font(.poppins(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2)

                        Text(achievement.description)
                            .font(.poppins(size: 14))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)

                        if achievement.status == .locked {
                            VStack(spacing: 5) {
                                Text("Progress")
                                    .font(.poppins(size: 12))
                                    .foregroundColor(.white.opacity(0.7))

                                HStack(spacing: 8) {
                                    Text("\(achievement.progress)/\(achievement.target)")
                                        .font(.poppins(size: 24, weight: .bold))
                                        .foregroundColor(.orange)
                                        .shadow(color: .black.opacity(0.3), radius: 2)
                                }
                            }
                        } else {
                            HStack(spacing: 8) {
                                Text("+\(extractCoinsFromReward())")
                                    .font(.poppins(size: 32, weight: .bold))
                                    .foregroundColor(.yellow)
                                    .shadow(color: .black.opacity(0.3), radius: 2)

                                Image("coin_icon")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                            }
                        }
                    }
                    .padding(.vertical, 30)

                    VStack {
                        HStack {
                            Spacer()

                            Button(action: onClose) {
                                Image("close_button_x")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                            .padding(.trailing, 15)
                            .padding(.top, 15)
                        }

                        Spacer()
                    }
                }
            }
        }
    }

    private func getBadgeImageName() -> String {
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

    private func extractCoinsFromReward() -> String {
        let components = achievement.reward.components(separatedBy: " ")
        if let firstComponent = components.first {
            return firstComponent
        }
        return achievement.reward
    }
}
