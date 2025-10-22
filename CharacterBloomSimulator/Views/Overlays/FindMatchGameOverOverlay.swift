import SwiftUI
struct FindMatchGameOverOverlay: View {
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
                            Image(systemName: "heart.slash.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.red)
                                .shadow(color: .black.opacity(0.3), radius: 3)

                            Text("LIVES ARE OVER")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .red.opacity(0.5), radius: 5)
                                .shadow(color: .black.opacity(0.5), radius: 3, x: 2, y: 2)
                                .multilineTextAlignment(.center)

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
