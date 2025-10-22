import SwiftUI
struct NotificationsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("famineNotifications") private var famineNotifications = true
    @AppStorage("sadNotifications") private var sadNotifications = true
    @AppStorage("gameEventsNotifications") private var gameEventsNotifications = true
    @State private var showSaveButton = false

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

                    Image("notifications_title")
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
                    .frame(height: 80)

                VStack(spacing: 0) {
                    HStack {
                        Text("NOTIFICATIONS")
                            .font(.poppins(size: 16, weight: .bold))
                            .foregroundColor(.white)

                        Spacer()

                        Toggle("", isOn: $notificationsEnabled)
                            .labelsHidden()
                            .toggleStyle(SwitchToggleStyle(tint: .green))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.45, green: 0.2, blue: 0.0))
                    )
                    .onChange(of: notificationsEnabled) { newValue in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showSaveButton = true
                        }
                        if newValue {
                            NotificationManager.shared.requestAuthorization()
                        } else {
                            NotificationManager.shared.cancelAllNotifications()
                        }
                    }

                    VStack(spacing: 8) {
                        Button(action: {
                            if notificationsEnabled {
                                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                                    famineNotifications.toggle()
                                    showSaveButton = true
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: famineNotifications ? "circle.fill" : "circle")
                                    .font(.poppins(size: 20))
                                    .foregroundColor(famineNotifications ? .red : .white.opacity(0.6))

                                Text("FAMINE")
                                    .font(.poppins(size: 14, weight: .semibold))
                                    .foregroundColor(.white)

                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .opacity(notificationsEnabled ? 1.0 : 0.5)
                        }
                        .disabled(!notificationsEnabled)

                        Button(action: {
                            if notificationsEnabled {
                                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                                    sadNotifications.toggle()
                                    showSaveButton = true
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: sadNotifications ? "circle.fill" : "circle")
                                    .font(.poppins(size: 20))
                                    .foregroundColor(sadNotifications ? .red : .white.opacity(0.6))

                                Text("SAD")
                                    .font(.poppins(size: 14, weight: .semibold))
                                    .foregroundColor(.white)

                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .opacity(notificationsEnabled ? 1.0 : 0.5)
                        }
                        .disabled(!notificationsEnabled)

                        Button(action: {
                            if notificationsEnabled {
                                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                                    gameEventsNotifications.toggle()
                                    showSaveButton = true
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: gameEventsNotifications ? "circle.fill" : "circle")
                                    .font(.poppins(size: 20))
                                    .foregroundColor(gameEventsNotifications ? .red : .white.opacity(0.6))

                                Text("ABOUT GAMING EVENTS")
                                    .font(.poppins(size: 14, weight: .semibold))
                                    .foregroundColor(.white)

                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .opacity(notificationsEnabled ? 1.0 : 0.5)
                        }
                        .disabled(!notificationsEnabled)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 65)
                    .padding(.bottom, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.45, green: 0.2, blue: 0.0))
                    )
                }
                .padding(.horizontal, 40)

                Spacer()

                Button(action: saveSettings) {
                    Image(showSaveButton ? "save_button_active" : "save_button_inactive")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180)
                }
                .disabled(!showSaveButton)
                .padding(.bottom, 50)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showSaveButton)

                Spacer()
                    .frame(height: 20)
            }
        }
        .navigationBarHidden(true)
    }

    private func saveSettings() {
        NotificationManager.shared.updateNotificationPreferences(
            famine: famineNotifications,
            sad: sadNotifications,
            gameEvents: gameEventsNotifications
        )

        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            showSaveButton = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
