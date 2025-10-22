import Foundation
import SwiftUI
import Combine

final class ChickTimerManager: ObservableObject {
    static let shared = ChickTimerManager()

    private var timer: Timer?
    private let updateInterval: TimeInterval = 3600

    private init() {}

    func startTimer(chickState: ChickState) {
        stopTimer()

        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.updateChickState(chickState: chickState)
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func updateChickState(chickState: ChickState) {
        let oldSatiety = chickState.satiety
        let oldMood = chickState.mood
        let oldPurity = chickState.purity

        chickState.satiety = max(0, chickState.satiety - 5)
        chickState.mood = max(0, chickState.mood - 3)
        chickState.purity = max(0, chickState.purity - 2)

        NotificationManager.shared.checkChickStateAndNotify(chickState: chickState)

        DataPersistence.shared.saveChickState(chickState)

        print("Stats updated: Satiety \(oldSatiety)→\(chickState.satiety), Mood \(oldMood)→\(chickState.mood), Purity \(oldPurity)→\(chickState.purity)")
    }
}
