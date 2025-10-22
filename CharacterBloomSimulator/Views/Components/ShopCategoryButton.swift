import SwiftUI

struct ShopCategoryButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image("shop_category_button")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(
                    HStack(spacing: 10) {
                        Image(getCategoryIconName())
                            .resizable()
                            .frame(width: 40, height: 40)

                        Text(title)
                            .font(.poppins(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2)

                        Spacer()
                    }
                    .padding(.leading, 30)
                )
        }
    }

    private func getCategoryIconName() -> String {
        switch title {
        case "FOOD AND TREATS":
            return "category_icon_food"
        case "ACCESSORIES":
            return "category_icon_accessories"
        case "HOUSE DECOR":
            return "category_icon_decor"
        case "RARE ITEM":
            return "category_icon_rare"
        default:
            return "category_icon_food"
        }
    }
}
