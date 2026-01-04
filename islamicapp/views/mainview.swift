import SwiftUI

struct mainview: View {
    @State private var selectedtab = 0
    
    var body: some View {
        ZStack {
            Color(hex: "0F1419").ignoresSafeArea()
            
            TabView(selection: $selectedtab) {
                prayerview()
                    .tabItem {
                        Label("prayer", systemImage: "clock.fill")
                    }
                    .tag(0)
                
                quranview()
                    .tabItem {
                        Label("quran", systemImage: "book.fill")
                    }
                    .tag(1)
                
                qiblaview()
                    .tabItem {
                        Label("qibla", systemImage: "safari.fill")
                    }
                    .tag(2)
                
                duaview()
                    .tabItem {
                        Label("dua", systemImage: "hands.sparkles.fill")
                    }
                    .tag(3)
                
                settingsview()
                    .tabItem {
                        Label("settings", systemImage: "gearshape.fill")
                    }
                    .tag(4)
            }
            .accentColor(Color(hex: "10B981"))
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
