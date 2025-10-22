import SwiftUI
struct StatView: View {
    let icon: String
    let value: Int
    let title: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)

            Text(title)
                .fontWeight(.medium)

            Spacer()

            Text("\(value)%")
                .fontWeight(.semibold)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
