import SwiftUI
struct ProgressView: View {
    @EnvironmentObject var chickState: ChickState
    @EnvironmentObject var gameState: GameState
    @State private var showSettings = false
    @State private var selectedAchievement: Achievement? = nil
    @State private var showDailyReward = false
    @State private var dailyRewardDay = 3
    @State private var dailyRewardAmount = 20

    var achievements: [Achievement] {
        return GameManager.shared.checkForAchievements(chickState: chickState, gameState: gameState)
    }

    var body: some View {
        ZStack {
            Image("find_match_background")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()

                    Image("progress_title")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)

                    Spacer()

                    Button(action: { showSettings = true }) {
                        Image("settings_button")
                            .resizable()
                            .frame(width: 55, height: 55)
                    }
                    .padding(.trailing, 15)
                }
                .padding(.top, 45)

                HStack(spacing: 10) {
                    HStack(spacing: 8) {
                        Text("LVL")
                            .font(.poppins(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2)

                        Text("\(chickState.growthStage)")
                            .font(.poppins(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(red: 0.45, green: 0.25, blue: 0.1))
                    )

                    HStack(spacing: 8) {
                        Text("\(chickState.coins)")
                            .font(.poppins(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2)

                        Image("coin_icon")
                            .resizable()
                            .frame(width: 26, height: 26)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(red: 0.45, green: 0.25, blue: 0.1))
                    )
                }
                .padding(.top, 5)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        ZStack {
                            Image("progress_chick_panel")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 220)

                            VStack(spacing: 8) {
                                Text("Chick growth stage")
                                    .font(.poppins(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.3), radius: 2)

                                Image(getChickStageAvatar())
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                            }
                            .padding(.top, -5)
                        }
                        .padding(.top, -5)

                        if chickState.growthStage < 4 {
                            let growthInfo = DataPersistence.shared.getGrowthInfo(state: chickState)

                            VStack(spacing: 4) {
                                HStack {
                                    Text("Growth Progress")
                                        .font(.poppins(size: 14, weight: .semibold))
                                        .foregroundColor(.white)

                                    Spacer()

                                    Text(growthInfo.timeLeft)
                                        .font(.poppins(size: 12, weight: .medium))
                                        .foregroundColor(growthInfo.canGrow ? .green : .yellow)
                                }

                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white.opacity(0.3))
                                        .frame(height: 20)

                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            LinearGradient(
                                                colors: growthInfo.canGrow ? [.green, .yellow] : [.orange, .red],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: max(20, CGFloat(growthInfo.progress) * 2.6), height: 20)
                                        .animation(.spring(response: 0.5), value: growthInfo.progress)

                                    HStack {
                                        Spacer()
                                        Text("\(growthInfo.progress)%")
                                            .font(.poppins(size: 12, weight: .bold))
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.5), radius: 2)
                                        Spacer()
                                    }
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(red: 0.45, green: 0.25, blue: 0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white.opacity(0.8), lineWidth: 2)
                                    )
                            )
                            .padding(.horizontal, 20)
                        }

                        ZStack {
                            Image("achievements_panel")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 320)

                            VStack(spacing: 5) {
                                VStack(spacing: 8) {
                                    HStack(spacing: 12) {
                                        ForEach(0..<3) { index in
                                            if index < achievements.count {
                                                AchievementBadge(
                                                    achievement: achievements[index],
                                                    onTap: {
                                                        selectedAchievement = achievements[index]
                                                    }
                                                )
                                            } else {
                                                LockedAchievementBadge()
                                            }
                                        }
                                    }

                                    HStack(spacing: 12) {
                                        ForEach(3..<6) { index in
                                            if index < achievements.count {
                                                AchievementBadge(
                                                    achievement: achievements[index],
                                                    onTap: {
                                                        selectedAchievement = achievements[index]
                                                    }
                                                )
                                            } else {
                                                LockedAchievementBadge()
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.top, -15)
                        }
                        .padding(.top, -15)
                    }
                    .padding(.bottom, 160)
                }
            }

            if let achievement = selectedAchievement {
                AchievementDetailOverlay(
                    achievement: achievement,
                    onClose: {
                        selectedAchievement = nil
                    }
                )
            }

            if showDailyReward {
                DailyRewardOverlay(
                    day: dailyRewardDay,
                    amount: dailyRewardAmount,
                    onClose: {
                        showDailyReward = false
                    }
                )
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(chickState)
        }
        .onAppear {
            checkDailyReward()
        }
    }

    private func getChickStageAvatar() -> String {
        switch chickState.growthStage {
        case 1: return "chick_stage_1"
        case 2: return "chick_stage_2"
        case 3: return "chick_stage_3"
        case 4: return "chick_stage_4"
        default: return "chick_stage_1"
        }
    }

    private func checkDailyReward() {
    }
}
