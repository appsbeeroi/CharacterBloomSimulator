import SwiftUI
struct SettingsView: View {
    @EnvironmentObject var chickState: ChickState
    @Environment(\.presentationMode) var presentationMode
    @State private var showClearConfirmation = false
    @State private var showNotifications = false

    var body: some View {
        ZStack {
            Image("settings_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image("back_button")
                            .resizable()
                            .frame(width: 55, height: 55)
                    }

                    Spacer()

                    Image("settings_title")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)

                    Spacer()

                    Color.clear
                        .frame(width: 55, height: 55)
                }
                .padding(.horizontal)
                .padding(.top, 60)

                Spacer()

                VStack(spacing: 12) {
                    SettingsButton(
                        title: "NOTIFICATIONS",
                        hasArrow: true,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showNotifications = true
                            }
                        }
                    )

                    SettingsButtonWithClear(
                        title: "CLEAR PROGRESS",
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showClearConfirmation = true
                            }
                        }
                    )

                    SettingsButton(
                        title: "PRIVACY POLICY",
                        hasArrow: true,
                        action: { openPrivacyPolicy() }
                    )

                    SettingsButton(
                        title: "LINK TO SUPPORT",
                        hasArrow: true,
                        action: { openSupport() }
                    )

                    SettingsButton(
                        title: "APPLICATION VERSION",
                        hasArrow: true,
                        action: {}
                    )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 120)

                Spacer()
            }

            if showClearConfirmation {
                ClearHistoryOverlay(
                    onCancel: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showClearConfirmation = false
                        }
                    },
                    onDelete: {
                        clearProgress()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showClearConfirmation = false
                        }
                    }
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showNotifications) {
            NotificationsView()
        }
    }

    private func openPrivacyPolicy() {
        if let url = URL(string: "https://your-privacy-policy-url.com") {
            UIApplication.shared.open(url)
        }
    }

    private func openSupport() {
        if let url = URL(string: "mailto:support@chickenbloom.com") {
            UIApplication.shared.open(url)
        }
    }

    private func clearProgress() {
        DataPersistence.shared.clearAllData()
        NotificationManager.shared.cancelAllNotifications()

        chickState.mood = 45
        chickState.satiety = 30
        chickState.purity = 40
        chickState.growthStage = 1
        chickState.coins = 40
        chickState.gameAttempts = 3
        chickState.maxGameAttempts = 3
        chickState.inventory = []
        chickState.currentAccessory = nil
        chickState.availableFood = []
    }
}
