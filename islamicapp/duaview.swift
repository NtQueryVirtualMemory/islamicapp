import SwiftUI

struct duaview: View {
    @State private var appear = false
    @State private var selected: dua?
    
    let categories = [
        ("Morning & Evening", "sun.and.horizon.fill", "FFB347"),
        ("Protection", "shield.fill", "4A90E2"),
        ("Forgiveness", "heart.fill", "FF6B6B"),
        ("Guidance", "star.fill", "10B981"),
        ("Travel", "airplane", "9B59B6"),
        ("Health", "cross.fill", "E74C3C")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                liquidbackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        header
                            .padding(.bottom, 28)
                        
                        categorygrid
                        
                        featureduas
                            .padding(.top, 28)
                        
                        Spacer(minLength: 120)
                    }
                    .padding(.top, 60)
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                appear = true
            }
        }
        .sheet(item: $selected) { d in
            duadetailview(dua: d)
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Duas & Adhkar")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(appcolors.text)
            
            Text("Supplications for every moment")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(appcolors.textsecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 20)
    }
    
    private var categorygrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
            ForEach(Array(categories.enumerated()), id: \.offset) { index, cat in
                categorycard(title: cat.0, icon: cat.1, color: cat.2, index: index)
            }
        }
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 30)
    }
    
    private func categorycard(title: String, icon: String, color: String, index: Int) -> some View {
        Button {
        } label: {
            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color(hex: color).opacity(0.15))
                        .frame(width: 52, height: 52)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color(hex: color))
                }
                
                Text(title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(appcolors.text)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .glasscard(padding: 12)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.05), value: appear)
    }
    
    private var featureduas: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Featured Duas")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(appcolors.text)
                .padding(.leading, 4)
            
            ForEach(duadatabase.shared.items) { d in
                Button {
                    selected = d
                } label: {
                    duarow(d: d)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func duarow(d: dua) -> some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(hex: d.color).opacity(0.15))
                    .frame(width: 48, height: 48)
                
                Image(systemName: d.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color(hex: d.color))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(d.title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(appcolors.text)
                
                Text(d.category)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(appcolors.texttertiary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(appcolors.texttertiary)
        }
        .glasscard(padding: 14)
    }
}

struct duadetailview: View {
    let dua: dua
    @StateObject private var audio = audioservice.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            appcolors.background.ignoresSafeArea()
            liquidbackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(appcolors.textsecondary)
                                .frame(width: 32, height: 32)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                    }
                    
                    ZStack {
                        Circle()
                            .fill(Color(hex: dua.color).opacity(0.15))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: dua.icon)
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundStyle(Color(hex: dua.color))
                    }
                    
                    Text(dua.title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(appcolors.text)
                    
                    if let audiourl = dua.audio {
                        Button {
                            audio.toggle(url: audiourl)
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: audio.playing && audio.currenturl == audiourl ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                Text(audio.playing && audio.currenturl == audiourl ? "Pause" : "Play Audio")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                            }
                            .foregroundStyle(appcolors.accent)
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .glasscard(padding: 0)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    VStack(spacing: 20) {
                        Text("Arabic")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(appcolors.accent)
                        
                        Text(dua.arabic)
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(appcolors.text)
                            .multilineTextAlignment(.center)
                            .lineSpacing(12)
                    }
                    .glasscard(padding: 24)
                    
                    VStack(spacing: 20) {
                        Text("Transliteration")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(appcolors.accent)
                        
                        Text(dua.transliteration)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundStyle(appcolors.textsecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                            .italic()
                    }
                    .glasscard(padding: 24)
                    
                    VStack(spacing: 20) {
                        Text("Translation")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(appcolors.accent)
                        
                        Text(dua.translation)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(appcolors.textsecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                    }
                    .glasscard(padding: 24)
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}
