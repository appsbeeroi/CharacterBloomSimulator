import SwiftUI

extension Font {
    static func poppins(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .regular:
            return .custom("Poppins-Regular", size: size)
        case .medium:
            return .custom("Poppins-Medium", size: size)
        case .semibold:
            return .custom("Poppins-SemiBold", size: size)
        case .bold:
            return .custom("Poppins-Bold", size: size)
        default:
            return .custom("Poppins-Regular", size: size)
        }
    }
}
