import SwiftUI

struct liquidbackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color(hex: "0F1419").ignoresSafeArea()
            
            ZStack {
                Circle()
                    .fill(Color(hex: "10B981").opacity(0.15))
                    .frame(width: 400, height: 400)
                    .blur(radius: 80)
                    .offset(x: animate ? 100 : -100, y: animate ? -150 : 150)
                
                Circle()
                    .fill(Color(hex: "4A90E2").opacity(0.1))
                    .frame(width: 300, height: 300)
                    .blur(radius: 60)
                    .offset(x: animate ? -120 : 120, y: animate ? 100 : -100)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                    animate.toggle()
                }
            }
        }
    }
}
