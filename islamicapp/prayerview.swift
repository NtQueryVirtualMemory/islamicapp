import SwiftUI

struct prayerview: View {
    @StateObject private var vm = prayerviewmodel()
    @State private var appear = false
    
    var body: some View {
        ZStack {
            liquidbackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    header
                        .padding(.bottom, 32)
                    
                    if vm.loading {
                        loading
                    } else if let t = vm.timings {
                        content(t)
                    } else {
                        errorstate
                    }
                    
                    Spacer(minLength: 120)
                }
                .padding(.top, 60)
                .padding(.horizontal, 20)
            }
        }
        .task {
            await vm.load()
            withAnimation(.easeOut(duration: 0.6)) {
                appear = true
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Prayer Times")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(appcolors.text)
            
            if !vm.hijri.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(appcolors.accent)
                    
                    Text(vm.hijri)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(appcolors.text)
                }
                .glasspill()
            }
            
            if !vm.countdown.isEmpty {
                HStack(spacing: 10) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(appcolors.accent)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Next: \(vm.nextprayer)")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundStyle(appcolors.text)
                        Text(vm.countdown)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(appcolors.accent)
                    }
                }
                .glasspill()
            }
            
            if !vm.location.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 12))
                    Text(vm.location)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                }
                .foregroundStyle(appcolors.textsecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 20)
    }
    
    private var loading: some View {
        VStack(spacing: 20) {
            ProgressView()
                .tint(appcolors.accent)
                .scaleEffect(1.2)
            
            Text("Finding your location...")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(appcolors.textsecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 80)
    }
    
    private var errorstate: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 40))
                .foregroundStyle(appcolors.texttertiary)
            
            Text("Unable to load prayer times")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(appcolors.textsecondary)
            
            Button {
                Task { await vm.load() }
            } label: {
                Text("Try Again")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(appcolors.accent)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(appcolors.accent.opacity(0.15))
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private func content(_ t: prayertimings) -> some View {
        VStack(spacing: 14) {
            prayerrow(name: "Fajr", time: t.Fajr, icon: "sun.haze.fill", index: 0, current: vm.currentprayer == "Fajr")
            prayerrow(name: "Sunrise", time: t.Sunrise, icon: "sunrise.fill", index: 1, current: false)
            prayerrow(name: "Dhuhr", time: t.Dhuhr, icon: "sun.max.fill", index: 2, current: vm.currentprayer == "Dhuhr")
            prayerrow(name: "Asr", time: t.Asr, icon: "sun.min.fill", index: 3, current: vm.currentprayer == "Asr")
            prayerrow(name: "Maghrib", time: t.Maghrib, icon: "sunset.fill", index: 4, current: vm.currentprayer == "Maghrib")
            prayerrow(name: "Isha", time: t.Isha, icon: "moon.stars.fill", index: 5, current: vm.currentprayer == "Isha")
        }
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 30)
    }
    
    private func prayerrow(name: String, time: String, icon: String, index: Int, current: Bool) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(current ? appcolors.accent.opacity(0.15) : Color.white.opacity(0.05))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(current ? appcolors.accent : appcolors.textsecondary)
            }
            
            Text(name)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(current ? appcolors.text : appcolors.textsecondary)
            
            Spacer()
            
            Text(time)
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundStyle(current ? appcolors.accent : appcolors.text)
        }
        .glasscard(padding: 16)
        .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.05), value: appear)
    }
}
