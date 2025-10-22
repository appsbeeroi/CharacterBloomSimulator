import SwiftUI

struct GameButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(icon)
                    .font(.system(size: 30))
                    .frame(width: 50)

                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)

                Spacer()

                Image(systemName: "play.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.orange)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 15)
            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
            .cornerRadius(15)
        }
    }
}
