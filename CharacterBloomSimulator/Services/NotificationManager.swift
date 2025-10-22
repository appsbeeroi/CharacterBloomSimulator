import Foundation
import UserNotifications
import SwiftUI
import Combine

final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    private let notificationCenter = UNUserNotificationCenter.current()

    enum NotificationType: String {
        case goodMorning = "good_morning"
        case famine = "famine"
        case sad = "sad"
        case gameEvent = "game_event"
        case dailyBonus = "daily_bonus"
        case levelUp = "level_up"
    }

    private init() {}

    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
                self.scheduleDefaultNotifications()
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }

    func checkAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            completion(settings.authorizationStatus == .authorized)
        }
    }

    func scheduleDefaultNotifications() {
        scheduleMorningNotification()

        scheduleDailyBonusNotification()

        let famineEnabled = getNotificationPreference(forKey: "famineNotifications")
        let sadEnabled = getNotificationPreference(forKey: "sadNotifications")

        if famineEnabled {
            scheduleFamineNotification()
        }

        if sadEnabled {
            scheduleSadNotification()
        }
    }

    func scheduleMorningNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Chicken Bloom"
        content.body = "🐣 Good morning! Your chick has already woken up and is waiting for breakfast. Don't forget about the daily bonus - +20 coins for logging in!"
        content.sound = .default
        content.badge = 1

        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: NotificationType.goodMorning.rawValue,
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling morning notification: \(error)")
            }
        }
    }

    func scheduleDailyBonusNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Chicken Bloom"
        content.body = "🪙 Don't forget to claim your daily bonus! +20 coins are waiting for you!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: NotificationType.dailyBonus.rawValue,
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling daily bonus notification: \(error)")
            }
        }
    }

    func scheduleFamineNotification(after hours: Int = 4) {
        let content = UNMutableNotificationContent()
        content.title = "Chicken Bloom"
        content.body = "🍽️ Your chick is hungry! Feed it to keep the mood high!"
        content.sound = .default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(hours * 3600), repeats: false)
        let request = UNNotificationRequest(
            identifier: NotificationType.famine.rawValue,
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling famine notification: \(error)")
            }
        }
    }

    func scheduleSadNotification(after hours: Int = 6) {
        let content = UNMutableNotificationContent()
        content.title = "Chicken Bloom"
        content.body = "🐥 Attention! Your chick is sad without attention. Pet it to get +1 to the mood!"
        content.sound = .default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(hours * 3600), repeats: false)
        let request = UNNotificationRequest(
            identifier: NotificationType.sad.rawValue,
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling sad notification: \(error)")
            }
        }
    }

    func scheduleLevelUpNotification(level: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Chicken Bloom"
        content.body = "🏆 Congratulations! You have reached a new level. Exclusive decorations for the house are now available!"
        content.sound = .default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "\(NotificationType.levelUp.rawValue)_\(level)",
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling level up notification: \(error)")
            }
        }
    }

    func scheduleGameEventNotification(message: String) {
        let content = UNMutableNotificationContent()
        content.title = "Chicken Bloom"
        content.body = message
        content.sound = .default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "\(NotificationType.gameEvent.rawValue)_\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling game event notification: \(error)")
            }
        }
    }

    func updateNotificationPreferences(famine: Bool, sad: Bool, gameEvents: Bool) {
        cancelNotification(type: .famine)
        cancelNotification(type: .sad)

        if famine {
            scheduleFamineNotification()
        }

        if sad {
            scheduleSadNotification()
        }

        UserDefaults.standard.set(famine, forKey: "famineNotifications")
        UserDefaults.standard.set(sad, forKey: "sadNotifications")
        UserDefaults.standard.set(gameEvents, forKey: "gameEventsNotifications")
    }

    func cancelNotification(type: NotificationType) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [type.rawValue])
    }

    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func updateBadge(count: Int) {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }

    func clearBadge() {
        updateBadge(count: 0)
    }

    func checkChickStateAndNotify(chickState: ChickState) {
        let notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")

        guard notificationsEnabled else { return }

        let famineEnabled = getNotificationPreference(forKey: "famineNotifications")
        let sadEnabled = getNotificationPreference(forKey: "sadNotifications")

        if famineEnabled && chickState.satiety < 30 {
            scheduleFamineNotification(after: 1)
        }

        if sadEnabled && chickState.mood < 40 {
            scheduleSadNotification(after: 2)
        }
    }

    private func getNotificationPreference(forKey key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
}
