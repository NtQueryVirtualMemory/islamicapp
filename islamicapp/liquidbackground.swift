import SwiftUI

struct liquidbackground: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                appcolors.background.ignoresSafeArea()
                
                Canvas { context, size in
                    let w = size.width
                    let h = size.height
                    
                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: w * 0.6 + sin(phase) * 50,
                            y: h * 0.15 + cos(phase * 0.7) * 30,
                            width: w * 0.5,
                            height: w * 0.5
                        )),
                        with: .color(appcolors.accent.opacity(0.08))
                    )
                    
                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: w * -0.1 + cos(phase * 0.8) * 40,
                            y: h * 0.5 + sin(phase * 0.6) * 50,
                            width: w * 0.6,
                            height: w * 0.6
                        )),
                        with: .color(Color(hex: "1E3A5F").opacity(0.12))
                    )
                    
                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: w * 0.4 + sin(phase * 0.5) * 60,
                            y: h * 0.75 + cos(phase * 0.9) * 40,
                            width: w * 0.4,
                            height: w * 0.4
                        )),
                        with: .color(appcolors.accent.opacity(0.05))
                    )
                }
                .blur(radius: 80)
                .ignoresSafeArea()
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}
