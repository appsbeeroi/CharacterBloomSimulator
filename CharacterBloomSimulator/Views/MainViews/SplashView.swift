import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var opacity: Double = 0

    var body: some View {
        if isActive {
            CoordinatorView()
        } else {
            ZStack {
                Image("splash_background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                    .ignoresSafeArea()
            }
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 0.3)) {
                    opacity = 1.0
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        isActive = true
                    }
                }
            }
        }
    }
}

