import Foundation
import Combine

final class GameManager: ObservableObject {
    static let shared = GameManager()

    func checkForAchievements(chickState: ChickState, gameState: GameState) -> [Achievement] {
        var achievements: [Achievement] = []

        let victoryProgress = gameState.totalGamesPlayed
        let victoryStatus: AchievementStatus = victoryProgress >= 10 ? .unlocked : (victoryProgress > 0 ? .inProgress : .locked)
        achievements.append(Achievement(
            id: "victory_medal",
            title: "Victory Medal",
            description: "Win 10 mini-games",
            reward: "50 coins",
            status: victoryStatus,
            progress: victoryProgress,
            target: 10
        ))

        let careProgress = getDaysOfHappiness(chickState: chickState)
        let careStatus: AchievementStatus = careProgress >= 3 ? .unlocked : (careProgress > 0 ? .inProgress : .locked)
        achievements.append(Achievement(
            id: "care_medal",
            title: "Care Medal",
            description: "Keep your chick happy for 3 days",
            reward: "1 treat + 1 accessory",
            status: careStatus,
            progress: careProgress,
            target: 3
        ))

        let shoppingProgress = chickState.inventory.count
        let shoppingStatus: AchievementStatus = shoppingProgress >= 5 ? .unlocked : (shoppingProgress > 0 ? .inProgress : .locked)
        achievements.append(Achievement(
            id: "shopping_medal",
            title: "Shopping Medal",
            description: "Purchase 5 items from the shop",
            reward: "100 coins",
            status: shoppingStatus,
            progress: shoppingProgress,
            target: 5
        ))

        let collectionProgress = countUniqueFoodTypes(chickState: chickState)
        let collectionStatus: AchievementStatus = collectionProgress >= 5 ? .unlocked : (collectionProgress > 0 ? .inProgress : .locked)
        achievements.append(Achievement(
            id: "collection_medal",
            title: "Collection Medal",
            description: "Collect all 5 food types",
            reward: "150 coins",
            status: collectionStatus,
            progress: collectionProgress,
            target: 5
        ))

        let dailyBonusManager = DailyBonusManager.shared
        let loginProgress = dailyBonusManager.daysStreak
        let loginStatus: AchievementStatus = loginProgress >= 7 ? .unlocked : (loginProgress > 0 ? .inProgress : .locked)
        achievements.append(Achievement(
            id: "daily_login_medal",
            title: "Daily Login Medal",
            description: "Login for 7 days in a row",
            reward: "200 coins",
            status: loginStatus,
            progress: loginProgress,
            target: 7
        ))

        return achievements
    }

    private func getDaysOfHappiness(chickState: ChickState) -> Int {
        return UserDefaults.standard.integer(forKey: "happyDaysStreak")
    }

    private func countUniqueFoodTypes(chickState: ChickState) -> Int {
        let uniqueFoodIds = Set(chickState.availableFood.map { $0.id })
        return uniqueFoodIds.count
    }

    func resetGameAttempts() {
    }
}
