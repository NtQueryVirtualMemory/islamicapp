import SwiftUI

struct qiblaview: View {
    var body: some View {
        ZStack {
            Color(hex: "0F1419").ignoresSafeArea()
            
            VStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Qibla")
                        .font(.system(size: 40, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Find the direction of the Kaaba")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                
                Spacer()
                
                ZStack {
                    // Outer decorative rings
                    Circle()
                        .stroke(Color(hex: "10B981").opacity(0.1), lineWidth: 1)
                        .frame(width: 340, height: 340)
                    
                    Circle()
                        .stroke(Color.white.opacity(0.05), lineWidth: 2)
                        .frame(width: 300, height: 300)
                    
                    // Main compass body
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 280, height: 280)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [.white.opacity(0.2), .clear, .white.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 15)
                    
                    // Compass markings
                    ForEach(0..<72) { i in
                        Rectangle()
                            .fill(i % 18 == 0 ? Color(hex: "10B981") : Color.white.opacity(0.2))
                            .frame(width: 2, height: i % 18 == 0 ? 15 : 8)
                            .offset(y: -125)
                            .rotationEffect(.degrees(Double(i) * 5))
                    }
                    
                    // Direction needle
                    VStack(spacing: 0) {
                        Image(systemName: "triangle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Color(hex: "10B981"))
                        
                        Rectangle()
                            .fill(Color(hex: "10B981"))
                            .frame(width: 4, height: 100)
                            .cornerRadius(2)
                    }
                    .offset(y: -50)
                    .rotationEffect(.degrees(45))
                    
                    Circle()
                        .fill(Color(hex: "0F1419"))
                        .frame(width: 12, height: 12)
                        .overlay(Circle().stroke(Color.white.opacity(0.5), lineWidth: 2))
                }
                
                VStack(spacing: 12) {
                    Text("45° North East")
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    
                    Text("Align your device with the green needle")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.white.opacity(0.4))
                }
                
                Spacer()
            }
            .padding(.vertical, 20)
        }
    }
}
