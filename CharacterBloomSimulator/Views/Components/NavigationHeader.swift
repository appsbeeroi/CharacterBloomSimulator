import SwiftUI

struct NavigationHeader: View {
    let title: String
    let coins: Int
    let attempts: Int
    let onBack: () -> Void

    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.primary)
            }

            Spacer()

            Text(title)
                .font(.title2)
                .fontWeight(.bold)

            Spacer()

            HStack(spacing: 15) {
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.yellow)
                    Text("\(coins)")
                        .fontWeight(.semibold)
                }

                HStack {
                    Image(systemName: "play.circle.fill")
                        .foregroundColor(.blue)
                    Text("\(attempts)")
                        .fontWeight(.semibold)
                }
            }
        }
        .padding(.horizontal)
    }
}
