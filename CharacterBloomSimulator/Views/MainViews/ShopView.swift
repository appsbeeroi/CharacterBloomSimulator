import SwiftUI
struct ShopView: View {
    @EnvironmentObject var chickState: ChickState
    @State private var selectedCategory: ShopCategory = .food
    @State private var showCategoryScreen = false

    var body: some View {
        ZStack {
            if showCategoryScreen {
                ShopCategoryScreen(
                    category: selectedCategory,
                    onBack: { showCategoryScreen = false }
                )
                .environmentObject(chickState)
            } else {
                ShopMainScreen(onSelectCategory: { category in
                    selectedCategory = category
                    showCategoryScreen = true
                })
                .environmentObject(chickState)
            }
        }
        .navigationBarHidden(true)
    }
}
