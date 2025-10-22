import SwiftUI
struct ClearHistoryOverlay: View {
    let onCancel: () -> Void
    let onDelete: () -> Void

    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    onCancel()
                }

            VStack(spacing: 0) {
                Image("clear_history_panel")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350)
                    .overlay(
                        VStack(spacing: 25) {
                            Text("CLEAR\nHISTORY")
                                .font(.poppins(size: 40, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)

                            Text("ARE YOU SURE YOU WANT TO\nCLEAR YOUR HISTORY?")
                                .font(.poppins(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)

                            HStack(spacing: 15) {
                                Button(action: onCancel) {
                                    Image("cancel_button")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 130)
                                }

                                Button(action: onDelete) {
                                    Image("delete_button")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 130)
                                }
                            }
                        }
                        .padding(.top, 50)
                    )
                    .scaleEffect(scale)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}
