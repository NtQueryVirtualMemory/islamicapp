import SwiftUI

struct qiblaview: View {
    @StateObject private var service = qiblaservice.shared
    
    var body: some View {
        ZStack {
            Color.midnight.ignoresSafeArea()
            liquidbackground().ignoresSafeArea()
            
            VStack(spacing: 50) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Qibla")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(-2)
                    
                    Text("Align with the Holy Kaaba")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.4))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
                
                Spacer()
                
                ZStack {
                    // Outer rings
                    Circle()
                        .stroke(Color.gold.opacity(0.1), lineWidth: 1)
                        .frame(width: 360, height: 360)
                    
                    Circle()
                        .stroke(Color.white.opacity(0.05), lineWidth: 2)
                        .frame(width: 320, height: 320)
                    
                    // Compass markings
                    ForEach(0..<72) { i in
                        Rectangle()
                            .fill(i % 18 == 0 ? Color.gold : Color.white.opacity(0.2))
                            .frame(width: 2, height: i % 18 == 0 ? 20 : 10)
                            .offset(y: -140)
                            .rotationEffect(.degrees(Double(i) * 5))
                    }
                    
                    // Main body
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 280, height: 280)
                        .shadow(color: .black.opacity(0.4), radius: 30, x: 0, y: 20)
                    
                    // Qibla Needle
                    VStack(spacing: 0) {
                        Image(systemName: "triangle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(Color.gold)
                            .shadow(color: Color.gold.opacity(0.5), radius: 10)
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.gold, Color.gold.opacity(0.2)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 6, height: 120)
                            .cornerRadius(3)
                    }
                    .offset(y: -60)
                    .rotationEffect(.degrees(service.qiblabearing - service.heading))
                    
                    Circle()
                        .fill(Color.midnight)
                        .frame(width: 16, height: 16)
                        .overlay(Circle().stroke(Color.gold, lineWidth: 3))
                }
                .rotationEffect(.degrees(-service.heading))
                
                VStack(spacing: 15) {
                    Text("\(Int(service.qiblabearing))°")
                        .font(.system(size: 40, weight: .black, design: .monospaced))
                        .foregroundColor(.white)
                    
                    Text("Point your device towards the gold needle")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.3))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 50)
                }
                
                Spacer()
                
                Color.clear.frame(height: 100)
            }
            .padding(.vertical, 40)
        }
    }
}
