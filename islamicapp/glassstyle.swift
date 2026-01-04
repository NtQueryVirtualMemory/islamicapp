import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

struct appcolors {
    static let background = Color(hex: "050A0E")
    static let surface = Color(hex: "0D1117")
    static let accent = Color(hex: "C9A227")
    static let accentlight = Color(hex: "E8D48B")
    static let text = Color.white
    static let textsecondary = Color.white.opacity(0.6)
    static let texttertiary = Color.white.opacity(0.35)
}

struct glasscard: ViewModifier {
    var padding: CGFloat = 20
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(.ultraThinMaterial)
                    
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.12), .white.opacity(0.02)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.25), .white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            }
            .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
    }
}

struct glasspill: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background {
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .stroke(.white.opacity(0.15), lineWidth: 0.5)
                    )
            }
    }
}

extension View {
    func glasscard(padding: CGFloat = 20) -> some View {
        modifier(glasscard(padding: padding))
    }
    
    func glasspill() -> some View {
        modifier(glasspill())
    }
}
