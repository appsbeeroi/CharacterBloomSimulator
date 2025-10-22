import SwiftUI
import Combine

struct ThreeInARowGameScreen: View {
    @EnvironmentObject var chickState: ChickState
    @Environment(\.presentationMode) var presentationMode

    @State private var gameBoard: [[GameCell]] = []
    @State private var selectedCell: CellPosition? = nil
    @State private var score = 0
    @State private var moves = 0
    @State private var lives = 3
    @State private var currentLevel = 1
    @State private var showGameOver = false
    @State private var showWinOverlay = false
    @State private var matchedCells: [CellPosition] = []
    @State private var isProcessing = false
    @State private var showCoolAnimation = false
    @State private var gameStartTime = Date()
    @State private var gameTime = 0
    @State private var matchesCompleted = 0
    @State private var targetMatches = 1

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var columns: Int {
        switch currentLevel {
        case 1: return 3
        case 2: return 3
        case 3: return 4
        default: return 4
        }
    }

    var rows: Int {
        switch currentLevel {
        case 1: return 3
        case 2: return 5
        case 3: return 7
        default: return 7
        }
    }

    let cellSymbols = ["orange", "blue_ball", "small_ball", "yellow", "leaf", "candy", "flower"]

    var body: some View {
        ZStack {
            Image("find_match_background")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .ignoresSafeArea()

            VStack(spacing: 0) {

                HStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Image("attempts_bg")
                            .resizable()
                            .frame(width: 90, height: 50)
                            .overlay(
                                HStack(spacing: 3) {
                                    Image("heart_icon")
                                        .resizable()
                                        .frame(width: 22, height: 22)

                                    Text("\(lives)/3")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                                }
                            )
                    }

                    HStack(spacing: 8) {
                        Image("attempts_bg")
                            .resizable()
                            .frame(width: 90, height: 50)
                            .overlay(
                                HStack(spacing: 3) {
                                    Text("LVL")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)

                                    Text("\(currentLevel)")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
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

                VStack(spacing: 4) {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: 4) {
                            ForEach(0..<columns, id: \.self) { col in
                                if row < gameBoard.count && col < gameBoard[row].count {
                                    GameCellView(
                                        cell: gameBoard[row][col],
                                        isSelected: selectedCell?.row == row && selectedCell?.col == col,
                                        isMatched: matchedCells.contains(where: { $0.row == row && $0.col == col }),
                                        action: {
                                            handleCellTap(row: row, col: col)
                                        }
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 140)
                .frame(maxWidth: .infinity)
            }

            if showCoolAnimation {
                ZStack {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()

                    Text("COOL!")
                        .font(.system(size: 64, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .orange, radius: 15)
                        .shadow(color: .black.opacity(0.8), radius: 8)
                }
                .transition(.opacity)
            }

            if showGameOver {
                ThreeInRowGameOverOverlay(
                    score: score,
                    onReplay: {
                        score = 0
                        moves = 0
                        currentLevel = 1
                        lives = 3
                        matchesCompleted = 0
                        targetMatches = 1
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
        .onReceive(timer) { _ in
            if !showGameOver {
                gameTime = Int(Date().timeIntervalSince(gameStartTime))
            }
        }
    }

    private func startNewGame() {
        gameStartTime = Date()
        gameTime = 0
        moves = 0
        score = 0
        lives = 3
        currentLevel = 1
        matchesCompleted = 0
        targetMatches = getTargetMatchesForLevel()
        initializeGameBoard()
    }

    private func startNewLevel() {
        moves = 0
        lives = 3
        matchesCompleted = 0
        targetMatches = getTargetMatchesForLevel()
        gameStartTime = Date()
        gameTime = 0
        initializeGameBoard()
    }

    private func getTargetMatchesForLevel() -> Int {
        switch currentLevel {
        case 1: return 1
        case 2: return 2
        case 3: return 3
        default: return 1
        }
    }

    private func initializeGameBoard() {
        gameBoard = (0..<rows).map { row in
            (0..<columns).map { col in
                GameCell(symbol: cellSymbols.randomElement()!, position: CellPosition(row: row, col: col))
            }
        }

        ensureNoInitialMatchesButHasMoves()

        selectedCell = nil
        isProcessing = false
    }

    private func ensureNoInitialMatchesButHasMoves() {
        var attempts = 0
        let maxAttempts = 100

        removeInitialMatches()

        while !hasAnyValidMoves() && attempts < maxAttempts {
            attempts += 1
            reshuffleBoard()
            removeInitialMatches()
        }

        // If still no valid moves after all attempts, force create one
        if !hasAnyValidMoves() {
            forceCreateValidMove()
        }
    }

    private func forceCreateValidMove() {
        // Create a guaranteed valid move by placing matching symbols strategically
        // Pattern: Place two matching symbols next to each other, and a third nearby

        if rows >= 1 && columns >= 3 {
            // Pick a random symbol
            let symbol = cellSymbols.randomElement()!

            // Place pattern in first row: [symbol] [symbol] [different] -> swap creates match
            let row = 0
            gameBoard[row][0].symbol = symbol
            gameBoard[row][1].symbol = symbol

            // Place the third matching symbol adjacent (below or to the right)
            if rows >= 2 {
                // Place below position 1 or 2
                gameBoard[row + 1][1].symbol = symbol
            } else if columns >= 4 {
                // Place to the right
                gameBoard[row][3].symbol = symbol
            }
        }
    }

    private func reshuffleBoard() {
        var allSymbols: [String] = []

        for row in 0..<rows {
            for col in 0..<columns {
                allSymbols.append(gameBoard[row][col].symbol)
            }
        }

        allSymbols.shuffle()

        var index = 0
        for row in 0..<rows {
            for col in 0..<columns {
                gameBoard[row][col].symbol = allSymbols[index]
                index += 1
            }
        }
    }

    private func removeInitialMatches() {
        var hasMatches = true
        var attempts = 0
        let maxAttempts = 100

        while hasMatches && attempts < maxAttempts {
            hasMatches = false
            attempts += 1

            for row in 0..<rows {
                for col in 0..<columns {
                    if checkMatchAtPosition(row: row, col: col) {
                        gameBoard[row][col].symbol = cellSymbols.randomElement()!
                        hasMatches = true
                    }
                }
            }
        }
    }

    private func handleCellTap(row: Int, col: Int) {
        guard !isProcessing else { return }
        guard lives > 0 else {
            endGame(isWin: false)
            return
        }
        guard row >= 0 && row < rows && col >= 0 && col < columns else { return }

        if let selected = selectedCell {
            if isAdjacent(pos1: selected, pos2: CellPosition(row: row, col: col)) {
                isProcessing = true
                moves += 1

                swapCells(pos1: selected, pos2: CellPosition(row: row, col: col))
                selectedCell = nil

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let hasMatches = !findAllMatches().isEmpty

                    if hasMatches {
                        checkAndProcessMatches()
                    } else {
                        lives -= 1
                        isProcessing = false

                        if lives <= 0 {
                            endGame(isWin: false)
                        }
                    }
                }
            } else {
                selectedCell = CellPosition(row: row, col: col)
            }
        } else {
            selectedCell = CellPosition(row: row, col: col)
        }
    }

    private func isAdjacent(pos1: CellPosition, pos2: CellPosition) -> Bool {
        let rowDiff = abs(pos1.row - pos2.row)
        let colDiff = abs(pos1.col - pos2.col)
        return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1)
    }

    private func swapCells(pos1: CellPosition, pos2: CellPosition) {
        withAnimation(.easeInOut(duration: 0.3)) {
            let temp = gameBoard[pos1.row][pos1.col].symbol
            gameBoard[pos1.row][pos1.col].symbol = gameBoard[pos2.row][pos2.col].symbol
            gameBoard[pos2.row][pos2.col].symbol = temp
        }
    }

    private func checkAndProcessMatches() {
        let matches = findAllMatches()

        if matches.isEmpty {
            isProcessing = false
        } else {
            withAnimation(.easeIn(duration: 0.3)) {
                showCoolAnimation = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(.easeOut(duration: 0.3)) {
                    showCoolAnimation = false
                }

                matchedCells = matches
                score += matches.count * 10

                matchesCompleted += 1

                withAnimation(.easeOut(duration: 0.3)) {
                    for match in matches {
                        gameBoard[match.row][match.col].symbol = ""
                    }
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    dropCells()
                    fillEmptyCells()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        matchedCells = []

                        if matchesCompleted >= targetMatches {
                            // Reward coins for completing the level
                            let levelBonus = currentLevel * 10
                            chickState.coins += levelBonus
                            DataPersistence.shared.saveChickState(chickState)

                            if currentLevel < 3 {
                                currentLevel += 1
                                startNewLevel()
                            } else {
                                // Completed all levels - give extra bonus
                                chickState.coins += 30
                                DataPersistence.shared.saveChickState(chickState)
                                matchesCompleted = 0
                                isProcessing = false
                            }
                        } else {
                            let newMatches = findAllMatches()
                            if !newMatches.isEmpty {
                                checkAndProcessMatches()
                            } else {
                                isProcessing = false
                            }
                        }
                    }
                }
            }
        }
    }

    private func findAllMatches() -> [CellPosition] {
        var matches = Set<CellPosition>()

        for row in 0..<rows {
            for col in 0..<(columns - 2) {
                let symbol = gameBoard[row][col].symbol
                if !symbol.isEmpty &&
                   symbol == gameBoard[row][col + 1].symbol &&
                   symbol == gameBoard[row][col + 2].symbol {
                    matches.insert(CellPosition(row: row, col: col))
                    matches.insert(CellPosition(row: row, col: col + 1))
                    matches.insert(CellPosition(row: row, col: col + 2))
                }
            }
        }

        for col in 0..<columns {
            for row in 0..<(rows - 2) {
                let symbol = gameBoard[row][col].symbol
                if !symbol.isEmpty &&
                   symbol == gameBoard[row + 1][col].symbol &&
                   symbol == gameBoard[row + 2][col].symbol {
                    matches.insert(CellPosition(row: row, col: col))
                    matches.insert(CellPosition(row: row + 1, col: col))
                    matches.insert(CellPosition(row: row + 2, col: col))
                }
            }
        }

        return Array(matches)
    }

    private func checkMatchAtPosition(row: Int, col: Int) -> Bool {
        let symbol = gameBoard[row][col].symbol

        if col >= 2 &&
           symbol == gameBoard[row][col - 1].symbol &&
           symbol == gameBoard[row][col - 2].symbol {
            return true
        }

        if col <= columns - 3 &&
           symbol == gameBoard[row][col + 1].symbol &&
           symbol == gameBoard[row][col + 2].symbol {
            return true
        }

        if row >= 2 &&
           symbol == gameBoard[row - 1][col].symbol &&
           symbol == gameBoard[row - 2][col].symbol {
            return true
        }

        if row <= rows - 3 &&
           symbol == gameBoard[row + 1][col].symbol &&
           symbol == gameBoard[row + 2][col].symbol {
            return true
        }

        return false
    }

    private func dropCells() {
        for col in 0..<columns {
            var emptyRow = rows - 1

            for row in stride(from: rows - 1, through: 0, by: -1) {
                if !gameBoard[row][col].symbol.isEmpty {
                    if row != emptyRow {
                        withAnimation(.easeOut(duration: 0.3)) {
                            gameBoard[emptyRow][col].symbol = gameBoard[row][col].symbol
                            gameBoard[row][col].symbol = ""
                        }
                    }
                    emptyRow -= 1
                }
            }
        }
    }

    private func fillEmptyCells() {
        for row in 0..<rows {
            for col in 0..<columns {
                if gameBoard[row][col].symbol.isEmpty {
                    withAnimation(.easeOut(duration: 0.3)) {
                        gameBoard[row][col].symbol = cellSymbols.randomElement()!
                    }
                }
            }
        }
    }

    private func hasAnyValidMoves() -> Bool {
        for row in 0..<rows {
            for col in 0..<columns {
                if col < columns - 1 {
                    let pos1 = CellPosition(row: row, col: col)
                    let pos2 = CellPosition(row: row, col: col + 1)

                    let temp = gameBoard[pos1.row][pos1.col].symbol
                    gameBoard[pos1.row][pos1.col].symbol = gameBoard[pos2.row][pos2.col].symbol
                    gameBoard[pos2.row][pos2.col].symbol = temp

                    let hasMatches = !findAllMatches().isEmpty

                    let temp2 = gameBoard[pos1.row][pos1.col].symbol
                    gameBoard[pos1.row][pos1.col].symbol = gameBoard[pos2.row][pos2.col].symbol
                    gameBoard[pos2.row][pos2.col].symbol = temp2

                    if hasMatches {
                        return true
                    }
                }

                if row < rows - 1 {
                    let pos1 = CellPosition(row: row, col: col)
                    let pos2 = CellPosition(row: row + 1, col: col)

                    let temp = gameBoard[pos1.row][pos1.col].symbol
                    gameBoard[pos1.row][pos1.col].symbol = gameBoard[pos2.row][pos2.col].symbol
                    gameBoard[pos2.row][pos2.col].symbol = temp

                    let hasMatches = !findAllMatches().isEmpty

                    let temp2 = gameBoard[pos1.row][pos1.col].symbol
                    gameBoard[pos1.row][pos1.col].symbol = gameBoard[pos2.row][pos2.col].symbol
                    gameBoard[pos2.row][pos2.col].symbol = temp2

                    if hasMatches {
                        return true
                    }
                }
            }
        }

        return false
    }

    private func endGame(isWin: Bool) {
        if isWin {
            chickState.coins += 100

            if currentLevel < 3 {
                currentLevel += 1
                startNewLevel()
            } else {
                matchesCompleted = 0
                isProcessing = false
                chickState.coins += 50
            }
        } else {
            chickState.coins += score
            showGameOver = true
        }
    }
}
struct GameCell {
    var symbol: String
    let position: CellPosition
}
struct CellPosition: Hashable {
    let row: Int
    let col: Int
}
struct GameCellView: View {
    let cell: GameCell
    let isSelected: Bool
    let isMatched: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if cell.symbol.isEmpty {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 90, height: 90)
                } else {
                    Image("game_cell_bg")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .overlay(
                            Image("game_cell_\(cell.symbol)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70)
                        )
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .scaleEffect(isMatched ? 0.8 : 1.0)
                        .opacity(isMatched ? 0.5 : 1.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange, lineWidth: isSelected ? 4 : 0)
                        )
                }
            }
        }
        .animation(.spring(response: 0.3), value: isSelected)
        .animation(.easeOut(duration: 0.3), value: isMatched)
    }
}
