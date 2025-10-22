import SwiftUI

struct ThreeInARowView: View {
    @EnvironmentObject var chickState: ChickState
    @Environment(\.presentationMode) var presentationMode
    @Binding var hideTabBar: Bool

    @State private var showGameScreen = false

    var body: some View {
        Group {
            if showGameScreen {
                ThreeInARowGameScreen()
                    .environmentObject(chickState)
            } else {
                ThreeInARowStartScreen(onPlay: {
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
