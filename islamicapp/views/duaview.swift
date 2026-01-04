import SwiftUI

struct duaview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("duas")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    duacard(title: "morning", icon: "sun.max.fill")
                    duacard(title: "evening", icon: "moon.stars.fill")
                    duacard(title: "protection", icon: "shield.fill")
                    duacard(title: "healing", icon: "heart.fill")
                }
                .padding()
            }
        }
        .background(Color(hex: "0F1419"))
    }
}

struct duacard: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "10B981"))
                .frame(width: 40)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.3))
        }
        .padding()
        .glass()
    }
}
