import SwiftUI
struct GamesView: View {
    @EnvironmentObject var chickState: ChickState
    @State private var showThreeInRow = false
    @State private var showFindMatch = false
    @State private var showSettings = false
    @Binding var hideTabBar: Bool

    var body: some View {
        NavigationView {
            ZStack {
                Image("settings_background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    VStack(spacing: 10) {
                        HStack {
                            Spacer()

                            HStack {
                                Spacer()
                                Image("games_title")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 40)
                                Spacer()
                            }

                            Button(action: { showSettings = true }) {
                                Image("settings_button")
                                    .resizable()
                                    .frame(width: 55, height: 55)
                            }
                            .padding(.trailing, 15)
                        }
                        .padding(.top, 45)

                        HStack(spacing: 15) {
                            HStack(spacing: 8) {
                                Image("attempts_bg")
                                    .resizable()
                                    .frame(width: 110, height: 60)
                                    .overlay(
                                        HStack(spacing: 5) {
                                            Image("heart_icon")
                                                .resizable()
                                                .frame(width: 28, height: 28)

                                            Text("\(chickState.gameAttempts)/\(chickState.maxGameAttempts)")
                                                .font(.poppins(size: 24, weight: .bold))
                                                .foregroundColor(.white)
                                                .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                                        }
                                    )
                            }
                            .padding(.leading, 5)

                            HStack(spacing: 8) {
                                Image("coins_bg")
                                    .resizable()
                                    .frame(width: 110, height: 60)
                                    .overlay(
                                        HStack(spacing: 5) {
                                            Text("\(chickState.coins)")
                                                .font(.poppins(size: 24, weight: .bold))
                                                .foregroundColor(.white)
                                                .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)

                                            Image("coin_icon")
                                                .resizable()
                                                .frame(width: 32, height: 32)
                                        }
                                    )
                            }
                        }
                        .padding(.top, 10)
                    }

                    Spacer()

                    ZStack {
                        Image("games_wood_base")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 380)

                        VStack(spacing: 20) {
                            Button(action: {
                                showThreeInRow = true
                            }) {
                                Image("three_in_row_button")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 320)
                            }

                            Button(action: {
                                showFindMatch = true
                            }) {
                                Image("find_match_button")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 320)
                            }
                        }
                        .padding(.top, 30)
                    }
                    .padding(.bottom, 160)

                    Spacer()
                }

                NavigationLink(destination: ThreeInARowView(hideTabBar: $hideTabBar), isActive: $showThreeInRow) { EmptyView() }
                NavigationLink(destination: FindMatchView(hideTabBar: $hideTabBar), isActive: $showFindMatch) { EmptyView() }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            hideTabBar = false
        }
    }
}
