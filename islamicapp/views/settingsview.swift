import SwiftUI

struct settingsview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("settings")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    settingrow(title: "location", value: "automatic")
                    settingrow(title: "calculation", value: "mwl")
                    settingrow(title: "language", value: "english")
                    settingrow(title: "notifications", value: "on")
                }
                .padding()
            }
        }
        .background(Color(hex: "0F1419"))
    }
}

struct settingrow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.white.opacity(0.3))
        }
        .padding()
        .glass()
    }
}
