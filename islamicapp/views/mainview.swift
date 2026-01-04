import SwiftUI

struct mainview: View {
    @State private var selectedtab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedtab) {
                prayerview()
                    .tag(0)
                
                quranview()
                    .tag(1)
                
                qiblaview()
                    .tag(2)
                
                duaview()
                    .tag(3)
                
                settingsview()
                    .tag(4)
            }
            
            // Custom Floating Liquid Glass Tab Bar
            HStack {
                tabitem(index: 0, icon: "clock.fill", label: "Prayer")
                Spacer()
                tabitem(index: 1, icon: "book.fill", label: "Quran")
                Spacer()
                tabitem(index: 2, icon: "safari.fill", label: "Qibla")
                Spacer()
                tabitem(index: 3, icon: "hands.sparkles.fill", label: "Duas")
                Spacer()
                tabitem(index: 4, icon: "gearshape.fill", label: "Settings")
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .background(.ultraThinMaterial)
            .cornerRadius(40)
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private func tabitem(index: Int, icon: String, label: String) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedtab = index
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                Text(label)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
            }
                .foregroundColor(selectedtab == index ? Color.gold : .white.opacity(0.4))
            .scaleEffect(selectedtab == index ? 1.1 : 1.0)
        }
    }
}
