import SwiftUI

struct qiblaview: View {
    var body: some View {
        VStack(spacing: 40) {
            Text("qibla")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(.white.opacity(0.1), lineWidth: 2)
                    .frame(width: 300, height: 300)
                
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 280, height: 280)
                    .overlay(
                        RoundedRectangle(cornerRadius: 140)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
                
                Image(systemName: "location.north.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color(hex: "10B981"))
                    .rotationEffect(.degrees(45))
            }
            
            Text("align with mecca")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
            
            Spacer()
        }
        .background(Color(hex: "0F1419"))
    }
}
