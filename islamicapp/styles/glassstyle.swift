import SwiftUI

struct glassstyle: ViewModifier {
    var radius: CGFloat = 32
    
    func body(content: Content) -> some View {
        content
            .background(.liquidGlass)
            .cornerRadius(radius)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.5), .clear, .white.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
            .shadow(color: .black.opacity(0.25), radius: 25, x: 0, y: 15)
    }
}

extension View {
    func glass() -> some View {
        self.modifier(glassstyle())
    }
}

extension Color {
    static let emerald = Color(hex: "065F46")
    static let gold = Color(hex: "D4AF37")
    static let midnight = Color(hex: "0F1419")
}
