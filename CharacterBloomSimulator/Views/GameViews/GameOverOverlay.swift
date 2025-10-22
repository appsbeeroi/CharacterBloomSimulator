import SwiftUI

struct GameOverOverlay: View {
    let score: Int
    let onReplay: () -> Void
    let onExit: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: 25) {
                Text("GAME OVER")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Your score: \(score)")
                    .font(.title2)
                    .foregroundColor(.white)

                VStack(spacing: 15) {
                    Button("REPLAY", action: onReplay)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.orange)
                        .cornerRadius(25)

                    Button("EXIT", action: onExit)
                        .font(.headline)
                        .foregroundColor(.orange)
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                }
            }
            .padding(40)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 20)
            .padding(40)
        }
    }
}
