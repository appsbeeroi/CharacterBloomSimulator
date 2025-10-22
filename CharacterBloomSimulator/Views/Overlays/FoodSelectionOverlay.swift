import SwiftUI
struct FoodSelectionOverlay: View {
    @EnvironmentObject var chickState: ChickState
    let onFeed: (ChickState.FoodItem) -> Void
    let onClose: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }

            VStack(spacing: 0) {
                ZStack {
                    Image("daily_bonus_panel")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350)

                    VStack(spacing: 5) {
                        Text("SELECT FOOD")
                            .font(.poppins(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2)

                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(chickState.availableFood.filter { $0.quantity > 0 }) { food in
                                    Button(action: {
                                        onFeed(food)
                                    }) {
                                        HStack(spacing: 15) {
                                            Image(food.imageName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50, height: 50)

                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(food.name)
                                                    .font(.poppins(size: 16, weight: .semibold))
                                                    .foregroundColor(.white)

                                                HStack(spacing: 10) {
                                                    HStack(spacing: 3) {
                                                        Image("satiety_icon")
                                                            .resizable()
                                                            .frame(width: 14, height: 14)
                                                        Text("+\(food.satietyBoost)")
                                                            .font(.poppins(size: 12))
                                                            .foregroundColor(.white.opacity(0.9))
                                                    }

                                                    HStack(spacing: 3) {
                                                        Image("mood_icon")
                                                            .resizable()
                                                            .frame(width: 14, height: 14)
                                                        Text("+\(food.moodBoost)")
                                                            .font(.poppins(size: 12))
                                                            .foregroundColor(.white.opacity(0.9))
                                                    }
                                                }
                                            }

                                            Spacer()

                                            Text("x\(food.quantity)")
                                                .font(.poppins(size: 18, weight: .bold))
                                                .foregroundColor(.yellow)
                                        }
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 12)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color(red: 0.35, green: 0.2, blue: 0.1))
                                        )
                                    }
                                    .frame(maxWidth: 280)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                        }
                        .frame(maxHeight: 180)
                        .clipped()
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 10)
                    .frame(width: 350)

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
            }
        }
    }
}
