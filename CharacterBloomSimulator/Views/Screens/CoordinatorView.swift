import SwiftUI

struct CoordinatorView: View {
    @State private var selectedTab = 0
    @StateObject private var chickState = DataPersistence.shared.loadChickState()
    @StateObject private var gameState = GameState()
    @State private var hideTabBar = false

    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case 0:
                    HomeView()
                case 1:
                    GamesView(hideTabBar: $hideTabBar)
                case 2:
                    ShopView()
                case 3:
                    ProgressView()
                default:
                    HomeView()
                }
            }
            .environmentObject(chickState)
            .environmentObject(gameState)

            if !hideTabBar {
                VStack {
                    Spacer()

                    HStack(spacing: 0) {
                        CustomTabButton(
                            icon: "home_tab",
                            isSelected: selectedTab == 0,
                            action: { selectedTab = 0 }
                        )

                        CustomTabButton(
                            icon: "games_tab",
                            isSelected: selectedTab == 1,
                            action: { selectedTab = 1 }
                        )

                        CustomTabButton(
                            icon: "shop_tab",
                            isSelected: selectedTab == 2,
                            action: { selectedTab = 2 }
                        )

                        CustomTabButton(
                            icon: "progress_tab",
                            isSelected: selectedTab == 3,
                            action: { selectedTab = 3 }
                        )
                    }
                    .padding(.horizontal, 10)
                    .frame(height: 70)
                    .padding(.bottom, 60)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}
