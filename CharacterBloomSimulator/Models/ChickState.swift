import Foundation
import Combine
import SwiftUI

final class ChickState: ObservableObject {
    @Published var mood: Int = 45
    @Published var satiety: Int = 30
    @Published var purity: Int = 40
    @Published var growthStage: Int = 1
    @Published var coins: Int = 40
    @Published var gameAttempts: Int = 3
    @Published var maxGameAttempts: Int = 3
    @Published var inventory: [ShopItem] = []
    @Published var currentAccessory: String? = nil
    @Published var availableFood: [FoodItem] = []
    struct FoodItem: Identifiable, Codable {
        let id: String
        let name: String
        let satietyBoost: Int
        let moodBoost: Int
        var quantity: Int
        let imageName: String
    }
    var hasFoodAvailable: Bool {
        return !availableFood.isEmpty && availableFood.contains(where: { $0.quantity > 0 })
    }
    func useFood(foodId: String) -> FoodItem? {
        guard let index = availableFood.firstIndex(where: { $0.id == foodId && $0.quantity > 0 }) else {
            return nil
        }

        let food = availableFood[index]
        availableFood[index].quantity -= 1
        if availableFood[index].quantity == 0 {
            availableFood.remove(at: index)
        }
        satiety = min(100, satiety + food.satietyBoost)
        mood = min(100, mood + food.moodBoost)

        return food
    }
    func addFood(id: String, name: String, satietyBoost: Int, moodBoost: Int, quantity: Int, imageName: String) {
        if let index = availableFood.firstIndex(where: { $0.id == id }) {
            availableFood[index].quantity += quantity
        } else {
            availableFood.append(FoodItem(
                id: id,
                name: name,
                satietyBoost: satietyBoost,
                moodBoost: moodBoost,
                quantity: quantity,
                imageName: imageName
            ))
        }
    }
    func getCurrentMoodEmoji() -> String {
        if satiety < 20 || mood < 20 || purity < 20 {
            return "mood_emoji_1"
        } else if satiety < 40 || mood < 40 || purity < 40 {
            return "mood_emoji_2"
        } else if satiety < 60 || mood < 60 || purity < 60 {
            return "mood_emoji_4"
        } else if satiety < 80 || mood < 80 || purity < 80 {
            return "mood_emoji_5"
        } else {
            return "mood_emoji_6"
        }
    }
    func getCurrentChickAvatar() -> String {
        switch growthStage {
        case 1:
            return "chick_avatar_level1"
        case 2:
            return "chick_avatar_level2"
        case 3:
            return "chick_avatar_level3"
        case 4:
            return "chick_avatar_level4"
        default:
            return "chick_avatar_level1"
        }
    }
    func decreaseStats() {
        satiety = max(0, satiety - 5)
        mood = max(0, mood - 3)
        purity = max(0, purity - 2)
    }
}
