import SwiftUI
struct StatBoostOverlay: View {
    let icon: String
    let text: String
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(icon)
                    .resizable()
                    .frame(width: 80, height: 80)

                Text(text)
                    .font(.poppins(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .orange, radius: 10)
            }
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5)) {
                scale = 1.0
                opacity = 1.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    opacity = 0
                }
            }
        }
    }
}
