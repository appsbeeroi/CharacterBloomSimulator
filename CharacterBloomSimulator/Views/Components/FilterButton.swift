import SwiftUI

struct FilterButton: View {
    let title: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.poppins(size: 12, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.45, green: 0.25, blue: 0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white, lineWidth: isActive ? 4 : 0)
                        )
                )
        }
    }
}
