import SwiftUI

struct prayerview: View {
    @StateObject private var vm = prayerviewmodel()
    @State private var appear = false
    
    var body: some View {
        ZStack {
            liquidbackground()
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
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
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
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
                            .monospacedDigit()
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
        .offset(y: appear ? 0 : -20)
    }
    
    private func content(_ t: prayertimings) -> some View {
        VStack(spacing: 12) {
            prayercard(name: "Fajr", time: t.Fajr, icon: "sunrise.fill", active: vm.currentprayer == "Fajr")
            prayercard(name: "Sunrise", time: t.Sunrise, icon: "sun.horizon.fill", active: false)
            prayercard(name: "Dhuhr", time: t.Dhuhr, icon: "sun.max.fill", active: vm.currentprayer == "Dhuhr")
            prayercard(name: "Asr", time: t.Asr, icon: "sun.min.fill", active: vm.currentprayer == "Asr")
            prayercard(name: "Maghrib", time: t.Maghrib, icon: "sunset.fill", active: vm.currentprayer == "Maghrib")
            prayercard(name: "Isha", time: t.Isha, icon: "moon.stars.fill", active: vm.currentprayer == "Isha")
        }
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 30)
    }
    
    private func prayercard(name: String, time: String, icon: String, active: Bool) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(active ? appcolors.accent.opacity(0.2) : appcolors.surface)
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(active ? appcolors.accent : appcolors.textsecondary)
            }
            
            Text(name)
                .font(.system(size: 18, weight: active ? .bold : .semibold, design: .rounded))
                .foregroundStyle(active ? appcolors.text : appcolors.textsecondary)
            
            Spacer()
            
            Text(time.components(separatedBy: " ").first ?? time)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(active ? appcolors.accent : appcolors.text)
                .monospacedDigit()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(active ? appcolors.accent.opacity(0.05) : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(active ? appcolors.accent.opacity(0.3) : Color.white.opacity(0.05), lineWidth: active ? 2 : 1)
                )
        )
        .shadow(color: active ? appcolors.accent.opacity(0.2) : .clear, radius: 12, x: 0, y: 4)
        .scaleEffect(active ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: active)
    }
    
    private var loading: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(appcolors.accent)
            Text("Loading prayer times...")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(appcolors.textsecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private var errorstate: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48, weight: .semibold))
                .foregroundStyle(appcolors.accent)
            
            Text("Unable to load prayer times")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(appcolors.text)
            
            Button {
                Task { await vm.load() }
            } label: {
                Text("Retry")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(appcolors.accent)
                    .frame(height: 44)
                    .frame(maxWidth: 200)
                    .glasscard(padding: 0)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}
