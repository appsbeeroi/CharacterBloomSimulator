import SwiftUI

struct CustomTabButton: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90, height: 90)
                .opacity(isSelected ? 1.0 : 0.6)
                .frame(maxWidth: .infinity)
        }
    }
}
