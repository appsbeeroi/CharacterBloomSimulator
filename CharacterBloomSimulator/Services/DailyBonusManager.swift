import Foundation
import SwiftUI
import Combine

final class DailyBonusManager: ObservableObject {
    static let shared = DailyBonusManager()

    @Published var canClaimBonus = false
    @Published var daysStreak = 1

    private let lastLoginKey = "lastLoginDate"
    private let streakKey = "loginStreak"
    private let bonusClaimedKey = "bonusClaimedToday"

    private init() {
        checkDailyBonus()
    }

    func checkDailyBonus() {
        let calendar = Calendar.current
        let now = Date()

        if let lastLogin = UserDefaults.standard.object(forKey: lastLoginKey) as? Date {
            if calendar.isDateInToday(lastLogin) {
                canClaimBonus = !UserDefaults.standard.bool(forKey: bonusClaimedKey)
            } else if calendar.isDateInYesterday(lastLogin) {
                canClaimBonus = true
                daysStreak = UserDefaults.standard.integer(forKey: streakKey)
            } else {
                canClaimBonus = true
                daysStreak = 1
                UserDefaults.standard.set(1, forKey: streakKey)
            }
        } else {
            canClaimBonus = true
            daysStreak = 1
        }

        UserDefaults.standard.set(now, forKey: lastLoginKey)
    }

    func claimDailyBonus(chickState: ChickState) -> Int {
        guard canClaimBonus else { return 0 }

        var bonusAmount = 20

        if daysStreak >= 7 {
            bonusAmount += 10
        } else if daysStreak >= 3 {
            bonusAmount += 5
        }

        chickState.coins += bonusAmount

        UserDefaults.standard.set(daysStreak, forKey: streakKey)
        UserDefaults.standard.set(true, forKey: bonusClaimedKey)
        canClaimBonus = false

        NotificationManager.shared.scheduleGameEventNotification(
            message: "🎉 Daily bonus claimed! You received \(bonusAmount) coins! Streak: \(daysStreak) days"
        )

        DataPersistence.shared.saveChickState(chickState)

        daysStreak += 1

        return bonusAmount
    }

    func resetDaily() {
        let calendar = Calendar.current
        let now = Date()

        if let lastLogin = UserDefaults.standard.object(forKey: lastLoginKey) as? Date {
            if !calendar.isDateInToday(lastLogin) {
                UserDefaults.standard.set(false, forKey: bonusClaimedKey)
                canClaimBonus = true
            }
        }
    }

    func getStreakInfo() -> String {
        if daysStreak == 1 {
            return "1 day streak! 🔥"
        } else if daysStreak < 7 {
            return "\(daysStreak) days streak! 🔥"
        } else {
            return "\(daysStreak) days streak! You're amazing! 🔥🔥🔥"
        }
    }
}
