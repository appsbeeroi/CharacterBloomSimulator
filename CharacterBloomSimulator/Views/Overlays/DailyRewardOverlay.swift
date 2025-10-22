import SwiftUI
struct DailyRewardOverlay: View {
    let day: Int
    let amount: Int
    let onClose: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }

            ZStack {
                Image("daily_reward_panel")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 320)

                VStack(spacing: 15) {
                    Text("DAILY REWARD!")
                        .font(.poppins(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .orange, radius: 5)
                        .shadow(color: .black.opacity(0.5), radius: 3)

                    VStack(spacing: 5) {
                        Text("Thanks for coming back!")
                            .font(.poppins(size: 16, weight: .semibold))
                            .foregroundColor(.white)

                        Text("Here's your reward for Day \(day)")
                            .font(.poppins(size: 14))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 10)

                    HStack(spacing: 8) {
                        Text("+\(amount)")
                            .font(.poppins(size: 36, weight: .bold))
                            .foregroundColor(.yellow)
                            .shadow(color: .black.opacity(0.3), radius: 2)

                        Image("coin_icon")
                            .resizable()
                            .frame(width: 36, height: 36)
                    }
                    .padding(.top, 15)
                }
                .padding(.vertical, 40)

                VStack {
                    HStack {
                        Spacer()

                        Button(action: onClose) {
                            Image("close_button_x")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        .padding(.trailing, 15)
                        .padding(.top, 15)
                    }

                    Spacer()
                }
            }
            .frame(width: 320)
        }
    }
}
