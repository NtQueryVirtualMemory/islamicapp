import SwiftUI

struct glassstyle: ViewModifier {
    var radius: CGFloat = 20
    var opacity: Double = 0.7
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .cornerRadius(radius)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

extension View {
    func glass() -> some View {
        self.modifier(glassstyle())
    }
}
