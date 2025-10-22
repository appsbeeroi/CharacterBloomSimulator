import SwiftUI
struct FindMatchStartScreen: View {
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

                    Image("find_match_title")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)

                    Spacer()

                    Color.clear
                        .frame(width: 55, height: 55)
                }
                .padding(.horizontal)
                .padding(.top, 30)

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
                    Image("memory_card_back")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .shadow(radius: 10)
                        .rotationEffect(.degrees(-5))

                    ZStack {
                        Image("memory_card_back")
                            .resizable()
                            .frame(width: 140, height: 140)

                        Image("memory_card_chick")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }
                    .rotationEffect(.degrees(15))
                    .offset(x: -100, y: -60)
                    .shadow(radius: 8)

                    ZStack {
                        Image("memory_card_back")
                            .resizable()
                            .frame(width: 120, height: 120)

                        Image("memory_card_egg")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 85, height: 85)
                    }
                    .rotationEffect(.degrees(-15))
                    .offset(x: 110, y: 70)
                    .shadow(radius: 8)
                }

                Spacer()

                Button(action: {
                    chickState.gameAttempts -= 1
                    onPlay()
                }) {
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
