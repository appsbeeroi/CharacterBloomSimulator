import Foundation

struct MemoryCard: Identifiable {
    let id: UUID
    let symbol: String
    var isFaceUp: Bool
    var isMatched: Bool

    init(id: UUID = UUID(), symbol: String, isFaceUp: Bool, isMatched: Bool) {
        self.id = id
        self.symbol = symbol
        self.isFaceUp = isFaceUp
        self.isMatched = isMatched
    }
}
