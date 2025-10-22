import SwiftUI
struct ShopItemView: View {
    let item: ShopItem
    let onPurchase: (ShopItem) -> Void

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .frame(height: 100)
                    .shadow(radius: 3)

                Text("🛍️")
                    .font(.system(size: 40))
            }

            Text(item.name)
                .font(.system(size: 14, weight: .semibold))
                .multilineTextAlignment(.center)

            Text("\(item.price) coins")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)

            Text(item.isPurchased ? "PURCHASED" : "NOT PURCHASED")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(item.isPurchased ? .green : .red)

            Button(action: { onPurchase(item) }) {
                Text("BUY")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(item.isPurchased ? Color.gray : Color.orange)
                    )
            }
            .disabled(item.isPurchased)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 2)
    }
}
