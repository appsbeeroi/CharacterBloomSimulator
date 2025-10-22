import SwiftUI

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(isSelected ? .white : .orange)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.orange : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.orange, lineWidth: 2)
                        )
                )
        }
    }
}
