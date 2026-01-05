import SwiftUI

struct mainview: View {
    @State private var selected = 0
    @Namespace private var animation
    @StateObject private var audio = audioservice.shared
    
    var body: some View {
        ZStack(alignment: .bottom) {
            tabcontent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            audioplayerview(audio: audio)
            
            tabbar
        }
        .ignoresSafeArea(.keyboard)
    }
    
    @ViewBuilder
    private var tabcontent: some View {
        switch selected {
        case 0:
            prayerview()
                .id(0)
        case 1:
            quranview()
                .id(1)
        case 2:
            qiblaview()
                .id(2)
        case 3:
            duaview()
                .id(3)
        case 4:
            settingsview()
                .id(4)
        default:
            prayerview()
                .id(0)
        }
    }
    
    private var tabbar: some View {
        HStack(spacing: 0) {
            tabbutton(index: 0, icon: "clock.fill", label: "Prayer")
            tabbutton(index: 1, icon: "book.fill", label: "Quran")
            tabbutton(index: 2, icon: "location.north.fill", label: "Qibla")
            tabbutton(index: 3, icon: "hands.sparkles.fill", label: "Duas")
            tabbutton(index: 4, icon: "gearshape.fill", label: "Settings")
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background {
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.2), .white.opacity(0.05)],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 0.5
                        )
                )
                .shadow(color: .black.opacity(0.5), radius: 30, x: 0, y: 15)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
    }
    
    private func tabbutton(index: Int, icon: String, label: String) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selected = index
            }
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    if selected == index {
                        Circle()
                            .fill(appcolors.accent.opacity(0.2))
                            .frame(width: 44, height: 44)
                            .matchedGeometryEffect(id: "indicator", in: animation)
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(selected == index ? appcolors.accent : appcolors.texttertiary)
                }
                .frame(width: 44, height: 44)
                
                Text(label)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundStyle(selected == index ? appcolors.accent : appcolors.texttertiary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}
