import SwiftUI
struct ThreeInARowStartScreen: View {
    @EnvironmentObject var chickState: ChickState
    let onPlay: () -> Void
    let onBack: () -> Void

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
                    Button(action: onBack) {
                        Image("back_button")
                            .resizable()
                            .frame(width: 55, height: 55)
                    }

                    Spacer()

                    Image("three_in_row_title")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)

                    Spacer()

                    Color.clear
                        .frame(width: 55, height: 55)
                }
                .padding(.horizontal)
                .padding(.top, 60)

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
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                                }
                            )
                    }

                    HStack(spacing: 8) {
                        Image("coins_bg")
                            .resizable()
                            .frame(width: 110, height: 60)
                            .overlay(
                                HStack(spacing: 5) {
                                    Text("\(chickState.coins)")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)

                                    Image("coin_icon")
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                }
                            )
                    }
                }
                .padding(.top, 30)

                Spacer()

                ZStack {
                    Image("game_cell_bg")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .overlay(
                            Image("game_cell_blue_ball")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 160, height: 160)
                        )
                        .rotationEffect(.degrees(-10))

                    Image("game_cell_bg")
                        .resizable()
                        .frame(width: 140, height: 140)
                        .overlay(
                            Image("game_cell_orange")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 110, height: 110)
                        )
                        .rotationEffect(.degrees(15))
                        .offset(x: -100, y: -50)

                    Image("game_cell_bg")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image("game_cell_candy")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75, height: 75)
                        )
                        .rotationEffect(.degrees(-20))
                        .offset(x: 100, y: 80)
                }

                Spacer()

                Button(action: onPlay) {
                    Image("play_button")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                }
                .padding(.bottom, 100)
            }
        }
    }
}
