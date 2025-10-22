import SwiftUI

struct ShopItemCard: View {
    let item: ShopItemData
    let isPurchased: Bool
    let onPrevious: () -> Void
    let onNext: () -> Void
    let onBuy: () -> Void
    let onPutOn: () -> Void
    let onTakeOff: () -> Void

    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                Image("shop_item_base")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 280)

                Image(item.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .offset(y: -10)

                HStack {
                    Button(action: onPrevious) {
                        Image("arrow_left_button")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }

                    Spacer()

                    Button(action: onNext) {
                        Image("arrow_right_button")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.horizontal, -20)
                .frame(width: 280)

                VStack {
                    Spacer()

                    HStack(spacing: 5) {
                        Text("\(item.price)")
                            .font(.poppins(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 3)

                        Image("coin_icon")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                    .padding(.bottom, 20)
                }
            }

            if !isPurchased {
                Button(action: onBuy) {
                    Image("buy_button")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                }
            } else if item.category == .accessories {
                HStack(spacing: 15) {
                    Button(action: onPutOn) {
                        Image("put_on_button")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 130)
                    }

                    Button(action: onTakeOff) {
                        Image("take_off_button")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 130)
                    }
                }
            }
        }
    }
}
