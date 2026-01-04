import SwiftUI

struct quranview: View {
    var body: some View {
        ZStack {
            Color(hex: "0F1419").ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Holy Quran")
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Read and listen to the divine word")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    
                    VStack(spacing: 16) {
                        ForEach(1...10, id: \.self) { index in
                            surahcard(number: index, name: "Surah \(index)", arabic: "سورة")
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.vertical, 20)
            }
        }
    }
}

struct surahcard: View {
    let number: Int
    let name: String
    let arabic: String
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 40, height: 40)
                
                Text("\(number)")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(hex: "10B981"))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Meccan • 7 Verses")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.4))
            }
            
            Spacer()
            
            Text(arabic)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white.opacity(0.8))
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white.opacity(0.2))
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .glass()
    }
}
