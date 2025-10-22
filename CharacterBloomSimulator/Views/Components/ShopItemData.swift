import SwiftUI

struct ShopItemData: Identifiable {
    let id: String
    let name: String
    let price: Int
    let category: ShopCategory
    let imageName: String

    static let allItems: [ShopItemData] = [
        ShopItemData(id: "food_1", name: "Basic Feed", price: 40, category: .food, imageName: "shop_item_basic_feed"),
        ShopItemData(id: "food_2", name: "Worm", price: 20, category: .food, imageName: "shop_item_worm"),
        ShopItemData(id: "food_3", name: "Strawberry", price: 15, category: .food, imageName: "shop_item_strawberry"),
        ShopItemData(id: "food_4", name: "Cookie", price: 50, category: .food, imageName: "shop_item_cookie"),
        ShopItemData(id: "food_5", name: "Grapes", price: 45, category: .food, imageName: "shop_item_grapes"),

        ShopItemData(id: "acc_1", name: "Bow", price: 40, category: .accessories, imageName: "shop_item_bow"),
        ShopItemData(id: "acc_2", name: "Hat", price: 300, category: .accessories, imageName: "shop_item_hat"),
        ShopItemData(id: "acc_3", name: "Glasses", price: 80, category: .accessories, imageName: "shop_item_glasses"),

        ShopItemData(id: "decor_1", name: "Lantern", price: 90, category: .decor, imageName: "shop_item_lantern"),
        ShopItemData(id: "decor_2", name: "Pillow", price: 70, category: .decor, imageName: "shop_item_pillow"),
        ShopItemData(id: "decor_3", name: "Lights", price: 60, category: .decor, imageName: "shop_item_lights"),

        ShopItemData(id: "rare_1", name: "Rare Egg", price: 220, category: .rare, imageName: "shop_item_rare_egg"),
        ShopItemData(id: "rare_2", name: "Gift Box", price: 300, category: .rare, imageName: "shop_item_gift"),
        ShopItemData(id: "rare_3", name: "Golden Feeder", price: 250, category: .rare, imageName: "shop_item_golden_feeder"),
    ]
}
