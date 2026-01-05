import SwiftUI

struct quranview: View {
    @StateObject private var vm = quranviewmodel()
    @State private var search = ""
    @State private var appear = false
    
    var filtered: [surah] {
        if search.isEmpty { return vm.surahs }
        return vm.surahs.filter {
            $0.englishName.localizedCaseInsensitiveContains(search) ||
            $0.name.contains(search) ||
            String($0.number).contains(search)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                liquidbackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        header
                            .padding(.bottom, 24)
                        
                        searchbar
                            .padding(.bottom, 20)
                        
                        if vm.loading {
                            loading
                        } else {
                            surahlist
                        }
                        
                        Spacer(minLength: 120)
                    }
                    .padding(.top, 60)
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarHidden(true)
        }
        .task {
            await vm.load()
            withAnimation(.easeOut(duration: 0.6)) {
                appear = true
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Holy Quran")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(appcolors.text)
            
            Text("114 Surahs")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(appcolors.textsecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 20)
    }
    
    private var searchbar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(appcolors.texttertiary)
            
            TextField("Search surahs...", text: $search)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(appcolors.text)
                .tint(appcolors.accent)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.white.opacity(0.1), lineWidth: 0.5)
                )
        }
        .opacity(appear ? 1 : 0)
    }
    
    private var loading: some View {
        VStack(spacing: 20) {
            ProgressView()
                .tint(appcolors.accent)
                .scaleEffect(1.2)
            
            Text("Loading Quran...")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(appcolors.textsecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 80)
    }
    
    private var surahlist: some View {
        LazyVStack(spacing: 12) {
            ForEach(Array(filtered.enumerated()), id: \.element.id) { index, s in
                NavigationLink {
                    surahdetailview(surah: s)
                } label: {
                    surahrow(s: s, index: index)
                }
                .buttonStyle(.plain)
            }
        }
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 30)
    }
    
    private func surahrow(s: surah, index: Int) -> some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(appcolors.accent.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Text("\(s.number)")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundStyle(appcolors.accent)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(s.englishName)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(appcolors.text)
                
                Text("\(s.revelationType) • \(s.numberOfAyahs) Ayahs")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(appcolors.texttertiary)
            }
            
            Spacer()
            
            Text(s.name)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(appcolors.textsecondary)
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(appcolors.texttertiary)
        }
        .glasscard(padding: 14)
        .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.02), value: appear)
    }
}

struct surahdetailview: View {
    let surah: surah
    @StateObject private var vm = surahdetailviewmodel()
    @StateObject private var audio = audioservice.shared
    @Environment(\.dismiss) private var dismiss
    @State private var autoplay = false
    
    var body: some View {
        ZStack {
            liquidbackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    header
                    
                    if vm.loading {
                        ProgressView()
                            .tint(appcolors.accent)
                            .padding(.vertical, 60)
                    } else {
                        ayahlist
                    }
                    
                    Spacer(minLength: 140)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(appcolors.text)
                        .frame(width: 40, height: 40)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    autoplay.toggle()
                    if autoplay && !vm.ayahs.isEmpty {
                        playall()
                    }
                } label: {
                    Image(systemName: autoplay ? "play.circle.fill" : "play.circle")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(appcolors.accent)
                }
            }
        }
        .task {
            await vm.load(number: surah.number)
        }
    }
    
    private var header: some View {
        VStack(spacing: 16) {
            Text(surah.name)
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(appcolors.text)
            
            Text(surah.englishName)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(appcolors.textsecondary)
            
            Text(surah.englishNameTranslation)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(appcolors.texttertiary)
            
            HStack(spacing: 16) {
                Label("\(surah.numberOfAyahs) Ayahs", systemImage: "text.alignleft")
                Label(surah.revelationType, systemImage: "mappin.circle.fill")
            }
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundStyle(appcolors.accent)
        }
        .frame(maxWidth: .infinity)
        .glasscard(padding: 24)
    }
    
    private var ayahlist: some View {
        LazyVStack(spacing: 16) {
            ForEach(vm.ayahs, id: \.arabic.id) { pair in
                VStack(alignment: .trailing, spacing: 16) {
                    HStack {
                        Text("\(pair.arabic.numberInSurah)")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundStyle(appcolors.accent)
                            .frame(width: 28, height: 28)
                            .background(appcolors.accent.opacity(0.1))
                            .clipShape(Circle())
                        
                        Spacer()
                        
                        if let audiourl = pair.audio {
                            Button {
                                audio.toggle(url: audiourl, title: "Ayah \(pair.arabic.numberInSurah)", subtitle: surah.englishName)
                            } label: {
                                Image(systemName: audio.playing && audio.currenturl == audiourl ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundStyle(appcolors.accent)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    Text(pair.arabic.text)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(appcolors.text)
                        .multilineTextAlignment(.trailing)
                        .lineSpacing(12)
                    
                    Divider()
                        .background(appcolors.texttertiary.opacity(0.3))
                    
                    Text(pair.translation.text)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(appcolors.textsecondary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(pair.transliteration.text)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(appcolors.texttertiary)
                        .multilineTextAlignment(.leading)
                        .italic()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .glasscard(padding: 20)
            }
        }
    }
    
    private func playall() {
        let items = vm.ayahs.compactMap { pair -> audioitem? in
            guard let url = pair.audio else { return nil }
            return audioitem(url: url, title: "Ayah \(pair.arabic.numberInSurah)", subtitle: surah.englishName)
        }
        audio.playqueue(items: items)
    }
}
