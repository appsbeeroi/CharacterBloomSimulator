import SwiftUI

struct MemoryCardView: View {
    let card: MemoryCard
    let onTap: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(card.isFaceUp ? Color.white : Color.orange)
                .frame(height: 70)
                .shadow(radius: 2)

            if card.isFaceUp || card.isMatched {
                Text(card.symbol)
                    .font(.title)
            } else {
                Text("?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .rotation3DEffect(
            .degrees(card.isFaceUp || card.isMatched ? 0 : 180),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.3), value: card.isFaceUp)
        .onTapGesture {
            if !card.isFaceUp && !card.isMatched {
                onTap()
            }
        }
        .opacity(card.isMatched ? 0.5 : 1.0)
    }
}
