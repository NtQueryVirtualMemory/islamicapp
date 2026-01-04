import SwiftUI

struct settingsview: View {
    var body: some View {
        ZStack {
            Color(hex: "0F1419").ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Settings")
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Customize your experience")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    
                    VStack(spacing: 12) {
                        settinggroup(title: "General") {
                            settingrow(title: "Location", value: "Automatic", icon: "location.fill")
                            settingrow(title: "Language", value: "English", icon: "globe")
                        }
                        
                        settinggroup(title: "Calculations") {
                            settingrow(title: "Method", value: "MWL", icon: "function")
                            settingrow(title: "Asr School", value: "Standard", icon: "book.closed.fill")
                        }
                        
                        settinggroup(title: "Notifications") {
                            settingrow(title: "Prayer Alerts", value: "Enabled", icon: "bell.fill")
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.vertical, 20)
            }
        }
    }
}

struct settinggroup<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.3))
                .padding(.leading, 8)
            
            VStack(spacing: 1) {
                content
            }
            .glass()
        }
        .padding(.bottom, 10)
    }
}

struct settingrow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(Color(hex: "10B981"))
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.4))
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white.opacity(0.1))
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
    }
}
