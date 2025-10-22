import SwiftUI
struct FindMatchGameScreen: View {
    @EnvironmentObject var chickState: ChickState
    @Environment(\.presentationMode) var presentationMode

    @State private var cards: [MemoryGameCard] = []
    @State private var firstSelectedCard: MemoryGameCard? = nil
    @State private var secondSelectedCard: MemoryGameCard? = nil
    @State private var matchedPairs = 0
    @State private var lives = 3
    @State private var currentLevel = 1
    @State private var showGameOver = false
    @State private var showGreat = false
    @State private var isProcessing = false

    let symbols = ["chick", "egg", "flower", "sun", "nest", "feather", "grain", "star"]

    var columns: Int {
        switch currentLevel {
        case 1: return 2
        case 2: return 3
        case 3: return 3
        default: return 2
        }
    }

    var rows: Int {
        switch currentLevel {
        case 1: return 2
        case 2: return 3
        case 3: return 4
        default: return 2
        }
    }

    var totalCards: Int {
        return columns * rows
    }

    var totalPairs: Int {
        if currentLevel == 1 {
            return totalCards / 2
        } else {
            return (totalCards - 1) / 2
        }
    }

    var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 8), count: columns)
    }

    var body: some View {
        ZStack {
            Image("find_match_background")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .ignoresSafeArea()

            VStack(spacing: 0) {

                HStack(spacing: 15) {
                    HStack(spacing: 8) {
                        Image("attempts_bg")
                            .resizable()
                            .frame(width: 110, height: 60)
                            .overlay(
                                HStack(spacing: 5) {
                                    Image("heart_icon")
                                        .resizable()
                                        .frame(width: 28, height: 28)

                                    Text("\(lives)/3")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                                }
                            )
                    }

                    HStack(spacing: 8) {
                        Image("coins_bg")
                            .resizable()
                            .frame(width: 110, height: 60)
                            .overlay(
                                HStack(spacing: 5) {
                                    Text("\(chickState.coins)")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)

                                    Image("coin_icon")
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                }
                            )
                    }

                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image("exit_button")
                            .resizable()
                            .frame(width: 55, height: 55)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 60)

                Spacer()

                LazyVGrid(columns: gridColumns, spacing: 8) {
                    ForEach(cards) { card in
                        MemoryCardGameView(
                            card: card,
                            onTap: {
                                selectCard(card)
                            }
                        )
                    }
                }
                .padding(.horizontal, 30)

                Spacer()
                    .frame(height: 100)
            }

            if showGreat {
                ZStack {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()

                    Text("GREAT!")
                        .font(.system(size: 64, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .green, radius: 15)
                        .shadow(color: .black.opacity(0.8), radius: 8)
                }
                .transition(.opacity)
            }

            if showGameOver {
                FindMatchGameOverOverlay(
                    onReplay: {
                        currentLevel = 1
                        lives = 3
                        matchedPairs = 0
                        showGameOver = false
                        startNewGame()
                    },
                    onExit: {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            startNewGame()
        }
    }

    private func startNewGame() {
        var newCards: [MemoryGameCard] = []
        let pairsNeeded = totalPairs

        if currentLevel == 1 {
            let symbolsToUse = Array(symbols.prefix(pairsNeeded))

            for i in 0..<pairsNeeded {
                let symbol = symbolsToUse[i]
                newCards.append(MemoryGameCard(id: UUID(), symbol: symbol, isFaceUp: false, isMatched: false))
                newCards.append(MemoryGameCard(id: UUID(), symbol: symbol, isFaceUp: false, isMatched: false))
            }
        } else {
            let symbolsToUse = Array(symbols.prefix(pairsNeeded + 1))

            for i in 0..<pairsNeeded {
                let symbol = symbolsToUse[i]
                newCards.append(MemoryGameCard(id: UUID(), symbol: symbol, isFaceUp: false, isMatched: false))
                newCards.append(MemoryGameCard(id: UUID(), symbol: symbol, isFaceUp: false, isMatched: false))
            }

            let unpairedSymbol = symbolsToUse[pairsNeeded]
            newCards.append(MemoryGameCard(id: UUID(), symbol: unpairedSymbol, isFaceUp: false, isMatched: false, isUnpaired: true))
        }

        cards = newCards.shuffled()
        firstSelectedCard = nil
        secondSelectedCard = nil
        matchedPairs = 0
        isProcessing = false

        if currentLevel == 1 {
            lives = 3
        }
    }

    private func selectCard(_ card: MemoryGameCard) {
        guard !isProcessing else { return }
        guard !card.isFaceUp && !card.isMatched else { return }
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }

        withAnimation(.spring(response: 0.3)) {
            cards[index].isFaceUp = true
        }

        if card.isUnpaired {
            withAnimation(.easeOut(duration: 0.3)) {
                cards[index].isMatched = true
            }
            return
        }

        if firstSelectedCard == nil {
            firstSelectedCard = cards[index]
        } else if secondSelectedCard == nil && !cards[index].isUnpaired {
            secondSelectedCard = cards[index]
            isProcessing = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                checkForMatch()
            }
        }
    }

    private func checkForMatch() {
        guard let first = firstSelectedCard,
              let second = secondSelectedCard,
              let firstIndex = cards.firstIndex(where: { $0.id == first.id }),
              let secondIndex = cards.firstIndex(where: { $0.id == second.id }) else {
            isProcessing = false
            return
        }

        if first.symbol == second.symbol {
            withAnimation(.easeOut(duration: 0.3)) {
                cards[firstIndex].isMatched = true
                cards[secondIndex].isMatched = true
            }

            matchedPairs += 1

            if matchedPairs == totalPairs {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if currentLevel < 3 {
                        showGreatAndAdvance()
                    } else {
                        showGreatAndContinue()
                    }
                }
            }

            firstSelectedCard = nil
            secondSelectedCard = nil
            isProcessing = false
        } else {
            lives -= 1

            withAnimation(.spring(response: 0.3)) {
                cards[firstIndex].isFaceUp = false
                cards[secondIndex].isFaceUp = false
            }

            firstSelectedCard = nil
            secondSelectedCard = nil
            isProcessing = false

            if lives <= 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showGameOver = true
                }
            }
        }
    }

    private func showGreatAndAdvance() {
        withAnimation(.easeIn(duration: 0.3)) {
            showGreat = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut(duration: 0.3)) {
                showGreat = false
            }

            currentLevel += 1
            lives = 3
            chickState.coins += 50

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                startNewGame()
            }
        }
    }

    private func showGreatAndContinue() {
        withAnimation(.easeIn(duration: 0.3)) {
            showGreat = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut(duration: 0.3)) {
                showGreat = false
            }

            chickState.coins += 50
            matchedPairs = 0

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                startNewGame()
            }
        }
    }
}
struct MemoryGameCard: Identifiable {
    let id: UUID
    let symbol: String
    var isFaceUp: Bool
    var isMatched: Bool
    var isUnpaired: Bool = false
}
struct MemoryCardGameView: View {
    let card: MemoryGameCard
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                if card.isFaceUp || card.isMatched {
                    ZStack {
                        Image("memory_card_back")
                            .resizable()
                            .aspectRatio(1.0, contentMode: .fit)

                        Image("memory_card_\(card.symbol)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(15)

                        if card.isUnpaired && (card.isFaceUp || card.isMatched) {
                            VStack {
                                HStack {
                                    Spacer()
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.yellow)
                                        .shadow(color: .black, radius: 2)
                                }
                                Spacer()
                            }
                            .padding(8)
                        }
                    }
                } else {
                    Image("memory_card_back")
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .rotation3DEffect(
                .degrees(card.isFaceUp || card.isMatched ? 180 : 0),
                axis: (x: 0, y: 1, z: 0)
            )
            .opacity(card.isMatched ? 0.6 : 1.0)
            .scaleEffect(card.isMatched ? 0.95 : 1.0)
        }
        .disabled(card.isFaceUp || card.isMatched)
    }
}
