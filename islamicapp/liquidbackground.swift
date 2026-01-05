import SwiftUI

struct liquidbackground: View {
    var body: some View {
        ZStack {
            appcolors.background.ignoresSafeArea()
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [appcolors.accent.opacity(0.08), .clear],
                        center: .topLeading,
                        startRadius: 50,
                        endRadius: 400
                    )
                )
                .blur(radius: 80)
                .offset(x: -50, y: -100)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "1E3A5F").opacity(0.12), .clear],
                        center: .center,
                        startRadius: 50,
                        endRadius: 400
                    )
                )
                .blur(radius: 80)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [appcolors.accent.opacity(0.06), .clear],
                        center: .bottomTrailing,
                        startRadius: 50,
                        endRadius: 400
                    )
                )
                .blur(radius: 80)
                .offset(x: 50, y: 100)
        }
        .ignoresSafeArea()
    }
}
