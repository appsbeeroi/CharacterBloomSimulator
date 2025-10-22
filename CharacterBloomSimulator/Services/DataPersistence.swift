import Foundation
import SwiftUI
import Combine

final class DataPersistence: ObservableObject {
    static let shared = DataPersistence()

    private let chickStateKey = "chickState"
    private let gameStateKey = "gameState"
    private let lastUpdateKey = "lastUpdateTime"
    private let availableFoodKey = "availableFood"
    private let currentAccessoryKey = "currentAccessory"

    private init() {}

    func saveChickState(_ state: ChickState) {
        let data: [String: Any] = [
            "mood": state.mood,
            "satiety": state.satiety,
            "purity": state.purity,
            "growthStage": state.growthStage,
            "coins": state.coins,
            "gameAttempts": state.gameAttempts,
            "maxGameAttempts": state.maxGameAttempts
        ]
        UserDefaults.standard.set(data, forKey: chickStateKey)
        UserDefaults.standard.set(Date(), forKey: lastUpdateKey)

        if let encodedFood = try? JSONEncoder().encode(state.availableFood) {
            UserDefaults.standard.set(encodedFood, forKey: availableFoodKey)
        }

        UserDefaults.standard.set(state.currentAccessory, forKey: currentAccessoryKey)
    }

    func loadChickState() -> ChickState {
        let state = ChickState()

        if let data = UserDefaults.standard.dictionary(forKey: chickStateKey) {
            state.mood = data["mood"] as? Int ?? 75
            state.satiety = data["satiety"] as? Int ?? 50
            state.purity = data["purity"] as? Int ?? 60
            state.growthStage = data["growthStage"] as? Int ?? 1
            state.coins = data["coins"] as? Int ?? 200
            state.gameAttempts = data["gameAttempts"] as? Int ?? 3
            state.maxGameAttempts = data["maxGameAttempts"] as? Int ?? 3

            if let foodData = UserDefaults.standard.data(forKey: availableFoodKey),
               let decodedFood = try? JSONDecoder().decode([ChickState.FoodItem].self, from: foodData) {
                state.availableFood = decodedFood
            }

            state.currentAccessory = UserDefaults.standard.string(forKey: currentAccessoryKey)

            if let lastUpdate = UserDefaults.standard.object(forKey: lastUpdateKey) as? Date {
                updateChickStateForTimePassed(state: state, lastUpdate: lastUpdate)
            }
        }

        return state
    }

    private func updateChickStateForTimePassed(state: ChickState, lastUpdate: Date) {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.hour], from: lastUpdate, to: now)

        if let hoursPassed = components.hour, hoursPassed > 0 {
            let satietyDecrease = min(hoursPassed * 5, state.satiety)
            let moodDecrease = min(hoursPassed * 3, state.mood)
            let purityDecrease = min(hoursPassed * 2, state.purity)

            state.satiety = max(0, state.satiety - satietyDecrease)
            state.mood = max(0, state.mood - moodDecrease)
            state.purity = max(0, state.purity - purityDecrease)

            if hoursPassed >= 24 {
                state.gameAttempts = state.maxGameAttempts
            }

            checkGrowthProgress(state: state)
        }
    }

    func checkGrowthProgress(state: ChickState) {
        guard state.growthStage < 4 else { return }

        let averageStats = (state.mood + state.satiety + state.purity) / 3

        let minimumHoursPerLevel: [Int: Int] = [
            1: 0,
            2: 24,
            3: 48,
            4: 72
        ]

        let lastLevelUpKey = "lastLevelUpTime_\(state.growthStage)"
        let lastLevelUp = UserDefaults.standard.object(forKey: lastLevelUpKey) as? Date ?? Date.distantPast

        let hoursSinceLastLevel = Int(Date().timeIntervalSince(lastLevelUp) / 3600)

        let requiredHours = minimumHoursPerLevel[state.growthStage] ?? 24

        print("📊 Growth check: avgStats=\(averageStats), level=\(state.growthStage), hours=\(hoursSinceLastLevel)/\(requiredHours)")

        if averageStats >= 80 && hoursSinceLastLevel >= requiredHours {
            let oldLevel = state.growthStage
            state.growthStage += 1

            UserDefaults.standard.set(Date(), forKey: "lastLevelUpTime_\(state.growthStage)")

            let reward = state.growthStage * 50
            state.coins += reward

            NotificationManager.shared.scheduleLevelUpNotification(level: state.growthStage)

            NotificationManager.shared.scheduleGameEventNotification(
                message: "🎉 Congratulations! Your chick grew to level \(state.growthStage)! You earned \(reward) coins!"
            )

            print("🐣 LEVEL UP! \(oldLevel) → \(state.growthStage) | Reward: +\(reward) coins")

            saveChickState(state)
        } else if averageStats < 80 {
            print("⚠️ Not ready to grow: stats too low (\(averageStats)/80)")
        } else if hoursSinceLastLevel < requiredHours {
            print("⏰ Not ready to grow: need to wait \(requiredHours - hoursSinceLastLevel) more hours")
        }
    }

    func getGrowthInfo(state: ChickState) -> (canGrow: Bool, progress: Int, timeLeft: String) {
        guard state.growthStage < 4 else {
            return (false, 100, "Max level reached!")
        }

        let averageStats = (state.mood + state.satiety + state.purity) / 3

        let minimumHoursPerLevel: [Int: Int] = [
            1: 1, 2: 36, 3: 72, 4: 106
        ]

        let lastLevelUpKey = "lastLevelUpTime_\(state.growthStage)"
        let lastLevelUp = UserDefaults.standard.object(forKey: lastLevelUpKey) as? Date ?? Date.distantPast
        let hoursSinceLastLevel = Int(Date().timeIntervalSince(lastLevelUp) / 3600)
        let requiredHours = minimumHoursPerLevel[state.growthStage] ?? 24

        let timeProgress = min(100, (hoursSinceLastLevel * 100) / requiredHours)
        let statsProgress = min(100, (averageStats * 100) / 80)
        let overallProgress = (timeProgress + statsProgress) / 2

        let hoursLeft = max(0, requiredHours - hoursSinceLastLevel)
        let timeLeftString: String
        if hoursLeft == 0 && averageStats >= 80 {
            timeLeftString = "Ready to grow!"
        } else if hoursLeft > 0 {
            timeLeftString = "\(hoursLeft)h left"
        } else {
            timeLeftString = "Need higher stats"
        }

        let canGrow = averageStats >= 80 && hoursSinceLastLevel >= requiredHours

        return (canGrow, overallProgress, timeLeftString)
    }

    func clearAllData() {
        UserDefaults.standard.removeObject(forKey: chickStateKey)
        UserDefaults.standard.removeObject(forKey: gameStateKey)
        UserDefaults.standard.removeObject(forKey: lastUpdateKey)
        UserDefaults.standard.removeObject(forKey: availableFoodKey)
        UserDefaults.standard.removeObject(forKey: currentAccessoryKey)
        UserDefaults.standard.removeObject(forKey: "lastLoginDate")
        UserDefaults.standard.removeObject(forKey: "loginStreak")
        UserDefaults.standard.removeObject(forKey: "bonusClaimedToday")
        UserDefaults.standard.removeObject(forKey: "famineNotifications")
        UserDefaults.standard.removeObject(forKey: "sadNotifications")
        UserDefaults.standard.removeObject(forKey: "gameEventsNotifications")

        for level in 1...4 {
            UserDefaults.standard.removeObject(forKey: "lastLevelUpTime_\(level)")
        }
    }
}
