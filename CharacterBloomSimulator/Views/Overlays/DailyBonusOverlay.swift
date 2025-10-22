import SwiftUI
struct DailyBonusOverlay: View {
    let bonusAmount: Int
    let streak: Int
    let onClaim: () -> Void

    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            ZStack {
                Image("daily_bonus_panel")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350)

                VStack(spacing: 20) {
                    Image("daily_reward_title")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 60)
                        .padding(.top, 10)

                    Text("Thanks for coming back!\nHere's your reward for Day \(streak)")
                        .font(.poppins(size: 15, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)

                    Image("bonus_20_coins")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                        .padding(.top, 5)
                }
                .padding(.vertical, 30)

                VStack {
                    HStack {
                        Spacer()

                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                onClaim()
                            }
                        }) {
                            Image("close_button_x")
                                                                .resizable()
                                                                .frame(width: 70, height: 70)
                                                        }
                        .offset(x: -30, y: 260)
                    }

                    Spacer()
                }
            }
            .scaleEffect(scale)
            .opacity(opacity)
            .rotationEffect(.degrees(scale < 1 ? 5 : 0))
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}
struct DailyBonusOverlay_Previews: PreviewProvider {
    static var previews: some View {
        DailyBonusOverlay(bonusAmount: 20, streak: 3, onClaim: {})
    }
}
