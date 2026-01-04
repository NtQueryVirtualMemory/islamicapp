import SwiftUI

struct quranview: View {
    @StateObject private var vm = quranviewmodel()
    
    var body: some View {
        ZStack {
            Color.midnight.ignoresSafeArea()
            liquidbackground().ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 35) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Holy Quran")
                            .font(.system(size: 48, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .tracking(-2)
                        
                        Text("Divine guidance for humanity")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 30)
                    
                    if vm.loading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(Color.gold)
                            .padding(100)
                    } else {
                        VStack(spacing: 18) {
                            ForEach(vm.surahs) { s in
                                surahcard(s: s)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Color.clear.frame(height: 100)
                }
                .padding(.vertical, 40)
            }
        }
        .task {
            await vm.load()
        }
    }
}

struct surahcard: View {
    let s: surah
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 48, height: 48)
                
                Text("\(s.number)")
                    .font(.system(size: 16, weight: .black, design: .monospaced))
                    .foregroundColor(Color.gold)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(s.englishName)
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Text("\(s.revelationType) • \(s.numberOfAyahs) Verses")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.4))
            }
            
            Spacer()
            
            Text(s.name)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white.opacity(0.9))
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .black))
                .foregroundColor(.white.opacity(0.1))
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 24)
        .glass()
    }
}
