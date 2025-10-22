import SwiftUI

struct LockedAchievementBadge: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 85, height: 85)

            Image(systemName: "lock.fill")
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundColor(.gray.opacity(0.5))
        }
    }
}
