import SwiftUI

struct prayerview: View {
    @StateObject private var vm = prayerviewmodel()
    
    var body: some View {
        ZStack {
            Color(hex: "0F1419").ignoresSafeArea()
            
            // Subtle background pattern or gradient
            LinearGradient(
                colors: [Color(hex: "0F1419"), Color(hex: "1A202C")],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    headersection
                    
                    if vm.loading {
                        loadingsection
                    } else if let t = vm.timings {
                        timingssection(t: t)
                    }
                    
                    footersection
                }
                .padding(.vertical, 20)
            }
        }
        .task {
            await vm.load()
        }
    }
    
    private var headersection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Prayer Times")
                .font(.system(size: 40, weight: .black, design: .rounded))
                .foregroundColor(.white)
            
            if !vm.hijri.isEmpty {
                HStack {
                    Image(systemName: "calendar")
                    Text(vm.hijri)
                }
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(Color(hex: "10B981"))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(hex: "10B981").opacity(0.1))
                .cornerRadius(12)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
    }
    
    private var loadingsection: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
                .tint(Color(hex: "10B981"))
                .padding(50)
            Text("Locating...")
                .font(.system(.body, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
        }
    }
    
    private func timingssection(t: prayertimings) -> some View {
        VStack(spacing: 18) {
            prayercard(name: "Fajr", time: t.Fajr, icon: "sun.haze.fill", active: true)
            prayercard(name: "Sunrise", time: t.Sunrise, icon: "sunrise.fill")
            prayercard(name: "Dhuhr", time: t.Dhuhr, icon: "sun.max.fill")
            prayercard(name: "Asr", time: t.Asr, icon: "sun.min.fill")
            prayercard(name: "Maghrib", time: t.Maghrib, icon: "sunset.fill")
            prayercard(name: "Isha", time: t.Isha, icon: "moon.stars.fill")
        }
        .padding(.horizontal, 24)
    }
    
    private var footersection: some View {
        VStack(spacing: 8) {
            if !vm.location.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                    Text(vm.location)
                }
                .font(.system(.caption, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.4))
            }
            
            Text("Powered by Aladhan & ipinfo.io")
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.2))
        }
        .padding(.top, 10)
    }
}

struct prayercard: View {
    let name: String
    let time: String
    let icon: String
    var active: Bool = false
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(active ? Color(hex: "10B981").opacity(0.2) : Color.white.opacity(0.05))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(active ? Color(hex: "10B981") : .white.opacity(0.7))
            }
            
            Text(name)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Spacer()
            
            Text(time)
                .font(.system(size: 22, weight: .bold, design: .monospaced))
                .foregroundColor(active ? Color(hex: "10B981") : .white.opacity(0.9))
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .glass()
    }
}
