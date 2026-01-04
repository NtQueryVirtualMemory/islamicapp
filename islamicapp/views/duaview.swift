import SwiftUI

struct duaview: View {
    var body: some View {
        ZStack {
            Color(hex: "0F1419").ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Duas")
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Supplications for every occasion")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        duagriditem(title: "Morning", icon: "sun.max.fill", color: "FFB347")
                        duagriditem(title: "Evening", icon: "moon.stars.fill", color: "778899")
                        duagriditem(title: "Protection", icon: "shield.fill", color: "10B981")
                        duagriditem(title: "Healing", icon: "heart.fill", color: "FF6B6B")
                        duagriditem(title: "Travel", icon: "airplane", color: "4A90E2")
                        duagriditem(title: "Success", icon: "star.fill", color: "F1C40F")
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.vertical, 20)
            }
        }
    }
}

struct duagriditem: View {
    let title: String
    let icon: String
    let color: String
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(hex: color).opacity(0.15))
                    .frame(width: 56, height: 56)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Color(hex: color))
            }
            
            Text(title)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .glass()
    }
}
