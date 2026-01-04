import SwiftUI

struct quranview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("holy quran")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    ForEach(1...10, id: \.self) { index in
                        surahcard(number: index, name: "surah \(index)")
                    }
                }
                .padding()
            }
        }
        .background(Color(hex: "0F1419"))
    }
}

struct surahcard: View {
    let number: Int
    let name: String
    
    var body: some View {
        HStack {
            Text("\(number)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 30)
            
            Text(name)
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
