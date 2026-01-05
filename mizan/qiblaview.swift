import SwiftUI

struct qiblaview: View {
    @StateObject private var service = qiblaservice.shared
    
    var body: some View {
        ZStack {
            liquidbackground()
            
            VStack(spacing: 40) {
                header
                
                statuscard
                
                prayermat
                
                Spacer()
                
                footer
            }
            .padding(.top, 60)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .onAppear {
            service.request()
            service.start()
        }
        .onDisappear {
            service.stop()
        }
    }
    
    private var header: some View {
        Text("Qibla Finder")
            .font(.system(size: 36, weight: .bold, design: .rounded))
            .foregroundStyle(appcolors.text)
    }
    
    private var statuscard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(service.facing ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: service.facing ? "checkmark" : "arrow.left.arrow.right")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(service.facing ? Color.green : Color.red)
            }
            
            Text(service.turntext.isEmpty ? "Calibrating..." : service.turntext)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(service.facing ? Color.green : Color.red)
            
            Spacer()
        }
        .padding(20)
        .glasscard()
    }
    
    private var prayermat: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            service.facing ? Color.green.opacity(0.3) : appcolors.accent.opacity(0.3),
                            service.facing ? Color.green.opacity(0.1) : appcolors.accent.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(
                            service.facing ? Color.green.opacity(0.5) : appcolors.accent.opacity(0.5),
                            lineWidth: 3
                        )
                )
                .frame(width: 200, height: 280)
            
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.black.opacity(0.3))
                .frame(width: 160, height: 220)
            
            VStack(spacing: 8) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(service.facing ? Color.green : appcolors.accent)
                
                Text("Qibla")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(service.facing ? Color.green : appcolors.accent)
            }
            .offset(y: -80)
        }
        .rotationEffect(.degrees(service.qibladirection - service.heading))
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: service.heading)
    }
    
    private var footer: some View {
        VStack(spacing: 16) {
            if service.distance > 0 {
                Text("Distance to Kaaba: \(Int(service.distance)) km")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(appcolors.textsecondary)
            }
            
            if !service.location.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 14, weight: .semibold))
                    
                    Text(service.location)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                }
                .foregroundStyle(appcolors.texttertiary)
            }
            
            Text("Hold your phone horizontally to find the Qibla and turn it towards the arrow.")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(appcolors.texttertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
    }
}
