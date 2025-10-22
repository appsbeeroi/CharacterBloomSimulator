import Foundation
import Combine

final class GameState: ObservableObject {
    @Published var threeInRowHighScore = 0
    @Published var findMatchBestTime = 0
    @Published var totalGamesPlayed = 0
    @Published var totalCoinsEarned = 0
}
