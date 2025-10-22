import SwiftUI
import UserNotifications

@main
struct CharacterBloomSimulatorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            SplashView()
                .onAppear {
                    NotificationManager.shared.clearBadge()
                }
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.notification.request.identifier

        if identifier.contains("famine") {
            print("User tapped famine notification")
        } else if identifier.contains("sad") {
            print("User tapped sad notification")
        } else if identifier.contains("level_up") {
            print("User tapped level up notification")
        } else if identifier.contains("good_morning") {
            print("User tapped good morning notification")
        } else if identifier.contains("daily_bonus") {
            print("User tapped daily bonus notification")
        }

        completionHandler()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaults.standard.set(Date(), forKey: "lastActiveTime")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationManager.shared.clearBadge()

        if let lastActive = UserDefaults.standard.object(forKey: "lastActiveTime") as? Date {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour], from: lastActive, to: Date())

            if let hoursPassed = components.hour, hoursPassed > 0 {
                print("App was inactive for \(hoursPassed) hours")
            }
        }
    }
}
