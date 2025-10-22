import Foundation

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let reward: String
    let status: AchievementStatus
    let progress: Int
    let target: Int
}

enum AchievementStatus {
    case locked
    case inProgress
    case unlocked
}
