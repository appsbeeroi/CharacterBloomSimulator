import SwiftUI
struct ShopCategoryScreen: View {
    @EnvironmentObject var chickState: ChickState
    let category: ShopCategory
    let onBack: () -> Void

    @State private var currentIndex = 0
    @State private var purchasedItems: Set<String> = []
    @State private var showPurchased = false
    @State private var showPurchaseSuccess = false

    var categoryItems: [ShopItemData] {
        ShopItemData.allItems.filter { $0.category == category }
    }

    var filteredItems: [ShopItemData] {
        categoryItems.filter { item in
            let isPurchased = ShopManager.shared.isPurchased(itemId: item.id, chickState: chickState)
            return showPurchased ? isPurchased : !isPurchased
        }
    }

    var body: some View {
        ZStack {
            Image("shop_background")
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

                    Image(getCategoryTitleImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 60)

                    Spacer()

                    Color.clear
                        .frame(width: 55, height: 55)
                }
                .padding(.horizontal)
                .padding(.top, 40)

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
                .padding(.top, 10)

                HStack(spacing: 15) {
                    FilterButton(title: "NOT PURCHASED", isActive: !showPurchased) {
                        showPurchased = false
                        currentIndex = 0
                    }
                    FilterButton(title: "PURCHASED", isActive: showPurchased) {
                        showPurchased = true
                        currentIndex = 0
                    }
                }
                .padding(.top, 20)

                Spacer()

                if !filteredItems.isEmpty && currentIndex < filteredItems.count {
                    let item = filteredItems[currentIndex]
                    let isPurchased = ShopManager.shared.isPurchased(itemId: item.id, chickState: chickState)

                    ShopItemCard(
                        item: item,
                        isPurchased: isPurchased,
                        onPrevious: {
                            if currentIndex > 0 {
                                withAnimation {
                                    currentIndex -= 1
                                }
                            }
                        },
                        onNext: {
                            if currentIndex < filteredItems.count - 1 {
                                withAnimation {
                                    currentIndex += 1
                                }
                            }
                        },
                        onBuy: {
                            if ShopManager.shared.purchaseItem(item, chickState: chickState) {
                                withAnimation {
                                    showPurchaseSuccess = true
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    withAnimation {
                                        showPurchaseSuccess = false
                                    }
                                }
                            }
                        },
                        onPutOn: {
                            chickState.currentAccessory = item.id
                            DataPersistence.shared.saveChickState(chickState)
                        },
                        onTakeOff: {
                            chickState.currentAccessory = nil
                            DataPersistence.shared.saveChickState(chickState)
                        }
                    )
                    .padding(.bottom, 80)
                } else {
                    Text(showPurchased ? "No purchased items" : "No items to purchase")
                        .font(.poppins(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 200)
                }

                Spacer()
                    .frame(height: 120)
            }

            if showPurchaseSuccess {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()

                    VStack(spacing: 15) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)

                        Text("PURCHASED!")
                            .font(.poppins(size: 28, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(40)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.45, green: 0.25, blue: 0.1))
                    )
                    .shadow(radius: 10)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
    }

    private func getCategoryTitleImage() -> String {
        switch category {
        case .food:
            return "food_treats_title"
        case .accessories:
            return "accessories_title"
        case .decor:
            return "house_decor_title"
        case .rare:
            return "rare_item_title"
        }
    }
}
