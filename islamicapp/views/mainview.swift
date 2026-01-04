import SwiftUI

struct mainview: View {
    @State private var selectedtab = 0
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(Color(hex: "0F1419").opacity(0.8))
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedtab) {
            prayerview()
                .tabItem {
                    Label("Prayer", systemImage: "clock.fill")
                }
                .tag(0)
            
            quranview()
                .tabItem {
                    Label("Quran", systemImage: "book.fill")
                }
                .tag(1)
            
            qiblaview()
                .tabItem {
                    Label("Qibla", systemImage: "safari.fill")
                }
                .tag(2)
            
            duaview()
                .tabItem {
                    Label("Duas", systemImage: "hands.sparkles.fill")
                }
                .tag(3)
            
            settingsview()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .accentColor(Color(hex: "10B981"))
    }
}
