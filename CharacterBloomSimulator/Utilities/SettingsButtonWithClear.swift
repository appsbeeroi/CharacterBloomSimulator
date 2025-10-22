import SwiftUI

struct SettingsButtonWithClear: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image("settings_button_bg")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(
                    HStack {
                        Text(title)
                            .font(.poppins(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2)

                        Spacer()

                        Text("CLEAR")
                            .font(.poppins(size: 18, weight: .bold))
                            .foregroundColor(.red)
                    }
                    .padding(.horizontal, 30)
                )
        }
    }
}
