import SwiftUI

struct prayerview: View {
    @StateObject private var vm = prayerviewmodel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("prayer times")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    if !vm.hijri.isEmpty {
                        Text(vm.hijri)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                if vm.loading {
                    ProgressView()
                        .tint(.white)
                        .padding()
                } else if let t = vm.timings {
                    VStack(spacing: 15) {
                        prayertimecard(name: "fajr", time: t.Fajr, icon: "sun.haze.fill")
                        prayertimecard(name: "sunrise", time: t.Sunrise, icon: "sunrise.fill")
                        prayertimecard(name: "dhuhr", time: t.Dhuhr, icon: "sun.max.fill")
                        prayertimecard(name: "asr", time: t.Asr, icon: "sun.min.fill")
                        prayertimecard(name: "maghrib", time: t.Maghrib, icon: "sunset.fill")
                        prayertimecard(name: "isha", time: t.Isha, icon: "moon.fill")
                    }
                    .padding(.horizontal)
                }
                
                if !vm.location.isEmpty {
                    Text(vm.location)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.4))
                        .padding(.top)
                }
            }
            .padding(.vertical)
        }
        .background(Color(hex: "0F1419"))
        .task {
            await vm.load()
        }
    }
}

struct prayertimecard: View {
    let name: String
    let time: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(hex: "10B981"))
                .frame(width: 30)
            
            Text(name)
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.white)
            
            Spacer()
            
            Text(time)
                .font(.system(.title3, design: .monospaced))
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 25)
        .glass()
    }
}
