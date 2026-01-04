import SwiftUI

struct prayerview: View {
    @StateObject private var vm = prayerviewmodel()
    @State private var showcontent = false
    
    var body: some View {
        ZStack {
            Color.midnight.ignoresSafeArea()
            
            // Animated Liquid Background
            liquidbackground().ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 40) {
                    headersection
                    
                    if vm.loading {
                        loadingsection
                    } else if let t = vm.timings {
                        timingssection(t: t)
                    }
                    
                    footersection
                    
                    // Extra space for floating tab bar
                    Color.clear.frame(height: 100)
                }
                .padding(.vertical, 40)
            }
        }
        .task {
            await vm.load()
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                showcontent = true
            }
        }
    }
    
    private var headersection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Prayer Times")
                .font(.system(size: 48, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .tracking(-2)
            
            if !vm.hijri.isEmpty {
                HStack(spacing: 10) {
                    Image(systemName: "moon.stars.fill")
                        .foregroundColor(Color.gold)
                    Text(vm.hijri)
                }
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.black)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
                .cornerRadius(25)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 30)
        .opacity(showcontent ? 1 : 0)
        .offset(y: showcontent ? 0 : 20)
    }
    
    private var loadingsection: some View {
        VStack(spacing: 25) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(Color.gold)
            Text("Locating your city...")
                .font(.system(.body, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(100)
    }
    
    private func timingssection(t: prayertimings) -> some View {
        VStack(spacing: 22) {
            prayercard(name: "Fajr", time: t.Fajr, icon: "sun.haze.fill", active: true)
            prayercard(name: "Sunrise", time: t.Sunrise, icon: "sunrise.fill")
            prayercard(name: "Dhuhr", time: t.Dhuhr, icon: "sun.max.fill")
            prayercard(name: "Asr", time: t.Asr, icon: "sun.min.fill")
            prayercard(name: "Maghrib", time: t.Maghrib, icon: "sunset.fill")
            prayercard(name: "Isha", time: t.Isha, icon: "moon.stars.fill")
        }
        .padding(.horizontal, 24)
        .opacity(showcontent ? 1 : 0)
        .offset(y: showcontent ? 0 : 40)
    }
    
    private var footersection: some View {
        VStack(spacing: 12) {
            if !vm.location.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "location.circle.fill")
                        .foregroundColor(Color.gold)
                    Text(vm.location)
                }
                .font(.system(.footnote, design: .rounded))
                .fontWeight(.black)
                .foregroundColor(.white.opacity(0.3))
            }
            
            Text("LIQUID GLASS DESIGN")
                .font(.system(size: 12, weight: .black, design: .rounded))
                .foregroundColor(Color.gold.opacity(0.5))
                .kerning(4)
                .padding(.top, 30)
        }
    }
}

struct prayercard: View {
    let name: String
    let time: String
    let icon: String
    var active: Bool = false
    
    var body: some View {
        HStack(spacing: 25) {
            ZStack {
                Circle()
                    .fill(active ? Color.gold.opacity(0.2) : Color.white.opacity(0.05))
                    .frame(width: 56, height: 56)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(active ? Color.gold : .white.opacity(0.6))
            }
            
            Text(name)
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundColor(.white)
            
            Spacer()
            
            Text(time)
                .font(.system(size: 26, weight: .black, design: .monospaced))
                .foregroundColor(active ? Color.gold : .white.opacity(0.9))
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 28)
        .glass()
    }
}
