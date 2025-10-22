import SwiftUI
struct HomeView: View {
    @EnvironmentObject var chickState: ChickState
    @State private var showSettings = false
    @State private var showDailyBonus = false
    @State private var showFoodSelection = false
    @State private var showInteractionAnimation = false
    @State private var interactionAnimationIcon: String = ""
    @State private var showStatBoost: StatBoostInfo? = nil
    @StateObject private var dailyBonusManager = DailyBonusManager.shared
    @StateObject private var timerManager: ChickTimerManager = {
        return ChickTimerManager.shared
    }()

    struct StatBoostInfo {
        let icon: String
        let text: String
    }

    var body: some View {
        ZStack {
            Image("home_background")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Color.clear
                        .frame(width: 55, height: 55)
                        .padding(.leading, 15)

                    Spacer()

                    Image("home_title")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 45)

                    Spacer()

                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showSettings = true
                        }
                    }) {
                        Image("settings_button")
                            .resizable()
                            .frame(width: 55, height: 55)
                    }
                    .padding(.trailing, 15)
                }
                .padding(.top, 50)

                HStack(spacing: 8) {
                    StyledProgressBar(
                        icon: "mood_icon",
                        title: "Mood",
                        value: chickState.mood,
                        backgroundColor: Color(red: 1.0, green: 0.6, blue: 0.4),
                        progressColor: Color(red: 1.0, green: 0.4, blue: 0.2)
                    )

                    StyledProgressBar(
                        icon: "satiety_icon",
                        title: "Satiety",
                        value: chickState.satiety,
                        backgroundColor: Color(red: 1.0, green: 0.9, blue: 0.3),
                        progressColor: Color(red: 1.0, green: 0.7, blue: 0.0)
                    )

                    StyledProgressBar(
                        icon: "purity_icon",
                        title: "Purity",
                        value: chickState.purity,
                        backgroundColor: Color(red: 0.4, green: 0.8, blue: 1.0),
                        progressColor: Color(red: 0.2, green: 0.4, blue: 1.0)
                    )
                }
                .padding(.horizontal, 15)
                .padding(.top, 35)

                Spacer()

                ZStack(alignment: .bottomTrailing) {
                    VStack {
                        Spacer()

                        ZStack {
                            Image(chickState.getCurrentChickAvatar())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 400, height: 400)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: chickState.growthStage)

                            Image(chickState.getCurrentMoodEmoji())
                                .resizable()
                                .frame(width: 80, height: 80)
                                .offset(x: -50, y: -130)
                                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: chickState.mood)

                            if showInteractionAnimation {
                                Image(interactionAnimationIcon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 120, height: 120)
                                    .transition(.scale.combined(with: .opacity))
                                    .offset(x: 10, y: 80)
                            }
                        }

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)

                    VStack(spacing: 16) {
                        Button(action: petChick) {
                            Image("pet_button")
                                .resizable()
                                .frame(width: 58, height: 75)
                        }
                        .buttonStyle(ScaleButtonStyle())

                        Button(action: cleanChick) {
                            Image("clean_button")
                                .resizable()
                                .frame(width: 58, height: 75)
                        }
                        .buttonStyle(ScaleButtonStyle())

                        Button(action: {
                            if chickState.hasFoodAvailable {
                                showFoodSelection = true
                            }
                        }) {
                            ZStack {
                                Image("feed_button")
                                    .resizable()
                                    .frame(width: 58, height: 75)
                                    .opacity(chickState.hasFoodAvailable ? 1.0 : 0.5)

                                if chickState.hasFoodAvailable {
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Text("\(getTotalFoodCount())")
                                                .font(.poppins(size: 12, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(
                                                    Circle()
                                                        .fill(Color.red)
                                                        .frame(width: 20, height: 20)
                                                )
                                                .offset(x: -5, y: -5)
                                        }
                                        Spacer()
                                    }
                                    .frame(height: 75)
                                }
                            }
                        }
                        .buttonStyle(ScaleButtonStyle())
                        .disabled(!chickState.hasFoodAvailable)
                    }
                    .frame(width: 75)
                    .padding(.vertical, 29)
                    .padding(.leading, 17)
                    .background(Color(red: 0.45, green: 0.28, blue: 0.16))
                    .clipShape(RoundedCornerShape(radius: 23, corners: [.topLeft, .bottomLeft]))
                    .overlay(
                        LeftBorderedShape(radius: 23)
                            .stroke(Color.white, lineWidth: 2.5)
                    )
                    .padding(.bottom, 150)
                    .padding(.trailing, 0)
                }
            }

            if let statBoost = showStatBoost {
                StatBoostOverlay(icon: statBoost.icon, text: statBoost.text)
            }

            if showDailyBonus {
                DailyBonusOverlay(
                    bonusAmount: 20,
                    streak: dailyBonusManager.daysStreak,
                    onClaim: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            let bonus = dailyBonusManager.claimDailyBonus(chickState: chickState)
                            showDailyBonus = false
                        }
                    }
                )
                .transition(.scale.combined(with: .opacity))
            }

            if showFoodSelection {
                FoodSelectionOverlay(
                    onFeed: { food in
                        feedChickWithFood(food)
                        showFoodSelection = false
                    },
                    onClose: {
                        showFoodSelection = false
                    }
                )
                .environmentObject(chickState)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .onAppear {
            dailyBonusManager.checkDailyBonus()
            if dailyBonusManager.canClaimBonus {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        showDailyBonus = true
                    }
                }
            }

            timerManager.startTimer(chickState: chickState)
            NotificationManager.shared.clearBadge()
        }
        .onDisappear {
            timerManager.stopTimer()
        }
    }

    private func getTotalFoodCount() -> Int {
        return chickState.availableFood.reduce(0) { $0 + $1.quantity }
    }

    private func checkForLevelUp() {
        DataPersistence.shared.checkGrowthProgress(state: chickState)
    }

    private func petChick() {
        chickState.mood = min(100, chickState.mood + 10)
        showInteractionWithAnimation(icon: "pet_interaction_icon")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showStatBoostAnimation(icon: "mood_icon", text: "+MOOD")
        }

        NotificationManager.shared.checkChickStateAndNotify(chickState: chickState)
        DataPersistence.shared.saveChickState(chickState)

        checkForLevelUp()
    }

    private func cleanChick() {
        chickState.purity = min(100, chickState.purity + 15)
        showInteractionWithAnimation(icon: "clean_interaction_icon")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showStatBoostAnimation(icon: "purity_icon", text: "+PURITY")
        }

        NotificationManager.shared.checkChickStateAndNotify(chickState: chickState)
        DataPersistence.shared.saveChickState(chickState)

        checkForLevelUp()
    }

    private func feedChickWithFood(_ food: ChickState.FoodItem) {
        if let usedFood = chickState.useFood(foodId: food.id) {
            showInteractionWithAnimation(icon: usedFood.imageName)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showStatBoostAnimation(icon: "satiety_icon", text: "+SATIETY")
            }

            NotificationManager.shared.checkChickStateAndNotify(chickState: chickState)
            DataPersistence.shared.saveChickState(chickState)

            checkForLevelUp()
        }
    }

    private func showInteractionWithAnimation(icon: String) {
        interactionAnimationIcon = icon

        withAnimation(.spring(response: 0.5)) {
            showInteractionAnimation = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeOut(duration: 0.3)) {
                showInteractionAnimation = false
            }
        }
    }

    private func showStatBoostAnimation(icon: String, text: String) {
        showStatBoost = StatBoostInfo(icon: icon, text: text)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showStatBoost = nil
            }
        }
    }
}
