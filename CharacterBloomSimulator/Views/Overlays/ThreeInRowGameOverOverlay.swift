import SwiftUI
struct ThreeInRowGameOverOverlay: View {
    let score: Int
    let onReplay: () -> Void
    let onExit: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Image("game_over_panel")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350)
                    .overlay(
                        VStack(spacing: 20) {
                            Text("GAME OVER")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .red.opacity(0.5), radius: 5)
                                .shadow(color: .black.opacity(0.5), radius: 3, x: 2, y: 2)

                            VStack(spacing: 5) {
                                Text("YOUR SCORE")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))

                                HStack(spacing: 10) {
                                    Text("\(score)")
                                        .font(.system(size: 48, weight: .bold))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)

                                    Image("coin_icon")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                }
                            }

                            HStack(spacing: 15) {
                                Button(action: onReplay) {
                                    Image("replay_button")
                                        .resizable()
                                        .frame(width: 140, height: 55)
                                }

                                Button(action: onExit) {
                                    Image("exit_game_button")
                                        .resizable()
                                        .frame(width: 140, height: 55)
                                }
                            }
                            .padding(.top, 10)
                        }
                        .padding(.top, 40)
                    )
            }
        }
    }
}
