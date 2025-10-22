import SwiftUI
struct ShopMainScreen: View {
    @EnvironmentObject var chickState: ChickState
    let onSelectCategory: (ShopCategory) -> Void

    var body: some View {
        ZStack {
            Image("shop_background")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .ignoresSafeArea()

            VStack(spacing: 0) {

                ZStack {
                    Image("shop_title")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                        .padding(.top, 50)

                    HStack {
                        Spacer()

                        Button(action: {}) {
                            Image("settings_button")
                                .resizable()
                                .frame(width: 55, height: 55)
                        }
                        .hidden()
                        .padding(.trailing, 15)
                        .padding(.top, 20)
                    }
                }

                HStack {
                    Spacer()

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

                    Spacer()
                }
                .padding(.top, 20)

                Spacer()

                VStack(spacing: 15) {
                    ShopCategoryButton(
                        title: "FOOD AND TREATS",
                        icon: "🍽️",
                        action: { onSelectCategory(.food) }
                    )

                    ShopCategoryButton(
                        title: "ACCESSORIES",
                        icon: "🎀",
                        action: { onSelectCategory(.accessories) }
                    )

                    ShopCategoryButton(
                        title: "HOUSE DECOR",
                        icon: "💡",
                        action: { onSelectCategory(.decor) }
                    )

                    ShopCategoryButton(
                        title: "RARE ITEM",
                        icon: "🌸",
                        action: { onSelectCategory(.rare) }
                    )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 250)
            }
        }
    }
}
