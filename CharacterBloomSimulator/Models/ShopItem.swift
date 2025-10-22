import Foundation

struct ShopItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Int
    let category: ShopCategory
    var isPurchased: Bool
}

enum ShopCategory: String, CaseIterable {
    case food = "FOOD AND TREATS"
    case accessories = "ACCESSORIES"
    case decor = "HOUSE DECOR"
    case rare = "RARE ITEM"
}
