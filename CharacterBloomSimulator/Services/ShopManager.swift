import Foundation
import Combine

final class ShopManager: ObservableObject {
    static let shared = ShopManager()

    func purchaseItem(_ item: ShopItemData, chickState: ChickState) -> Bool {
        guard chickState.coins >= item.price else { return false }

        chickState.coins -= item.price

        if item.category == .food {
            addFoodToInventory(item: item, chickState: chickState)
        } else {
            let shopItem = ShopItem(
                name: item.name,
                price: item.price,
                category: item.category,
                isPurchased: true
            )
            chickState.inventory.append(shopItem)
        }

        DataPersistence.shared.saveChickState(chickState)

        return true
    }

    private func addFoodToInventory(item: ShopItemData, chickState: ChickState) {
        let (satietyBoost, moodBoost, quantity) = getFoodParameters(for: item.id)

        chickState.addFood(
            id: item.id,
            name: item.name,
            satietyBoost: satietyBoost,
            moodBoost: moodBoost,
            quantity: quantity,
            imageName: getFoodInteractionImage(for: item.id)
        )
    }

    private func getFoodParameters(for foodId: String) -> (satiety: Int, mood: Int, quantity: Int) {
        switch foodId {
        case "food_1":
            return (20, 5, 1)
        case "food_2":
            return (10, 8, 1)
        case "food_3":
            return (8, 12, 1)
        case "food_4":
            return (25, 15, 1)
        case "food_5":
            return (15, 10, 1)
        default:
            return (10, 5, 1)
        }
    }

    private func getFoodInteractionImage(for foodId: String) -> String {
        switch foodId {
        case "food_1":
            return "feed_interaction_basic"
        case "food_2":
            return "feed_interaction_worm"
        case "food_3":
            return "feed_interaction_strawberry"
        case "food_4":
            return "feed_interaction_cookie"
        case "food_5":
            return "feed_interaction_grapes"
        default:
            return "feed_interaction_icon"
        }
    }

    func isPurchased(itemId: String, chickState: ChickState) -> Bool {
        if chickState.availableFood.contains(where: { $0.id == itemId }) {
            return true
        }

        return chickState.inventory.contains(where: { item in
            if let shopItem = ShopItemData.allItems.first(where: {
                $0.name == item.name && $0.category == item.category
            }) {
                return shopItem.id == itemId
            }
            return false
        })
    }
}
