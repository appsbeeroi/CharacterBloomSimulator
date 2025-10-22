import SwiftUI
struct WinOverlay: View {
    let moves: Int
    let time: Int
    let onReplay: () -> Void
    let onExit: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: 25) {
                Text("🎉 You Win! 🎉")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)

                VStack(spacing: 10) {
                    Text("Moves: \(moves)")
                    Text("Time: \(time)s")
                }
                .font(.title2)
                .foregroundColor(.white)

                Text("+100 coins!")
                    .font(.headline)
                    .foregroundColor(.yellow)

                VStack(spacing: 15) {
                    Button("PLAY AGAIN", action: onReplay)
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
