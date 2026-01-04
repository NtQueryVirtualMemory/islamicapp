import SwiftUI

struct glassstyle: ViewModifier {
    var radius: CGFloat = 24
    var opacity: Double = 0.15
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    BlurView(style: .systemUltraThinMaterialDark)
                    Color.white.opacity(opacity)
                }
            )
            .cornerRadius(radius)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .white.opacity(0.05), .black.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

extension View {
    func glass() -> some View {
        self.modifier(glassstyle())
    }
}
