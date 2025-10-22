import SwiftUI

struct SettingsButton: View {
    let title: String
    let hasArrow: Bool
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

                        if hasArrow {
                            Image(systemName: "chevron.right")
                                .font(.poppins(size: 18, weight: .bold))
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal, 30)
                )
        }
    }
}
