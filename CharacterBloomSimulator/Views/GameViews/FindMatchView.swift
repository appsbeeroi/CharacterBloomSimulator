import SwiftUI
import Foundation

struct FindMatchView: View {
    @EnvironmentObject var chickState: ChickState
    @Environment(\.presentationMode) var presentationMode
    @Binding var hideTabBar: Bool

    @State private var showGameScreen = false

    var body: some View {
        Group {
            if showGameScreen {
                FindMatchGameScreen()
                    .environmentObject(chickState)
            } else {
                FindMatchStartScreen(onPlay: {
                    showGameScreen = true
                }, onBack: {
                    hideTabBar = false
                    presentationMode.wrappedValue.dismiss()
                })
                .environmentObject(chickState)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            hideTabBar = true
        }
        .onDisappear {
            hideTabBar = false
        }
    }
}
