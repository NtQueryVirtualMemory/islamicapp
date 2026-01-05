import SwiftUI
import CoreLocation

struct qiblaview: View {
    @StateObject private var compass = qiblaservice.shared
    @State private var appear = false
    
    var rotation: Double {
        compass.qiblabearing - compass.heading
    }
    
    var body: some View {
        ZStack {
            liquidbackground()
            
            VStack(spacing: 0) {
                header
                    .padding(.top, 60)
                    .padding(.bottom, 40)
                
                Spacer()
                
                compassview
                
                Spacer()
                
                footer
                    .padding(.bottom, 140)
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                appear = true
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Qibla Direction")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(appcolors.text)
            
            Text("Face the Holy Kaaba")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(appcolors.textsecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 20)
    }
    
    private var compassview: some View {
        ZStack {
            Circle()
                .stroke(appcolors.accent.opacity(0.1), lineWidth: 1)
                .frame(width: 320, height: 320)
            
            Circle()
                .stroke(Color.white.opacity(0.05), lineWidth: 2)
                .frame(width: 280, height: 280)
            
            ForEach(0..<72, id: \.self) { i in
                Rectangle()
                    .fill(i % 18 == 0 ? appcolors.accent : Color.white.opacity(0.15))
                    .frame(width: i % 18 == 0 ? 2 : 1, height: i % 18 == 0 ? 16 : 8)
                    .offset(y: -130)
                    .rotationEffect(.degrees(Double(i) * 5))
            }
            
            ForEach(0..<4, id: \.self) { i in
                Text(["N", "E", "S", "W"][i])
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(i == 0 ? appcolors.accent : appcolors.texttertiary)
                    .offset(y: -105)
                    .rotationEffect(.degrees(Double(i) * 90))
            }
            .rotationEffect(.degrees(-compass.heading))
            
            Circle()
                .fill(appcolors.cardbackground)
                .frame(width: 220, height: 220)
                .overlay(
                    Circle()
                        .stroke(appcolors.cardborder, lineWidth: 1)
                )
            
            VStack(spacing: 0) {
                Image(systemName: "location.north.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(appcolors.accent)
                    .shadow(color: appcolors.accent.opacity(0.5), radius: 8)
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [appcolors.accent, appcolors.accent.opacity(0.2)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 4, height: 70)
                    .clipShape(Capsule())
            }
            .offset(y: -35)
            .rotationEffect(.degrees(rotation))
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: rotation)
            
            Circle()
                .fill(appcolors.background)
                .frame(width: 16, height: 16)
                .overlay(
                    Circle()
                        .stroke(appcolors.accent, lineWidth: 3)
                )
            
            Image("kaaba")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .opacity(0.8)
                .offset(y: -35)
                .rotationEffect(.degrees(rotation))
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: rotation)
        }
        .opacity(appear ? 1 : 0)
        .scaleEffect(appear ? 1 : 0.9)
    }
    
    private var footer: some View {
        VStack(spacing: 16) {
            Text("\(Int(compass.qiblabearing))°")
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .foregroundStyle(appcolors.text)
            
            Text("Align the arrow with the Kaaba")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(appcolors.texttertiary)
                .multilineTextAlignment(.center)
        }
        .opacity(appear ? 1 : 0)
    }
}
