import WidgetKit
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct provider: TimelineProvider {
    func placeholder(in context: Context) -> prayerentry {
        prayerentry(date: Date(), nextprayer: "Maghrib", countdown: "2h 34m", time: "18:45")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (prayerentry) -> ()) {
        let entry = prayerentry(date: Date(), nextprayer: "Maghrib", countdown: "2h 34m", time: "18:45")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<prayerentry>) -> ()) {
        Task {
            let entry = await fetchnextprayer()
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60)))
            completion(timeline)
        }
    }
    
    private func fetchnextprayer() async -> prayerentry {
        guard let lat = UserDefaults(suiteName: "group.dev.cyendd.mizan")?.double(forKey: "latitude"),
              let lon = UserDefaults(suiteName: "group.dev.cyendd.mizan")?.double(forKey: "longitude"),
              lat != 0, lon != 0 else {
            return prayerentry(date: Date(), nextprayer: "Loading", countdown: "--", time: "--:--")
        }
        
        do {
            let method = UserDefaults(suiteName: "group.dev.cyendd.mizan")?.integer(forKey: "calculationmethod") ?? 2
            let url = URL(string: "https://api.aladhan.com/v1/timings?latitude=\(lat)&longitude=\(lon)&method=\(method)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(prayerresponse.self, from: data)
            
            let now = Date()
            let calendar = Calendar.current
            let prayers = [
                ("Fajr", response.data.timings.Fajr),
                ("Dhuhr", response.data.timings.Dhuhr),
                ("Asr", response.data.timings.Asr),
                ("Maghrib", response.data.timings.Maghrib),
                ("Isha", response.data.timings.Isha)
            ]
            
            for (name, timestring) in prayers {
                if let prayertime = parseprayer(timestring) {
                    if prayertime > now {
                        let diff = prayertime.timeIntervalSince(now)
                        let hours = Int(diff) / 3600
                        let minutes = (Int(diff) % 3600) / 60
                        let countdown = hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
                        let time = timestring.components(separatedBy: " ").first ?? timestring
                        return prayerentry(date: Date(), nextprayer: name, countdown: countdown, time: time)
                    }
                }
            }
            
            if let fajrtime = parseprayer(response.data.timings.Fajr) {
                let nextfajr = calendar.date(byAdding: .day, value: 1, to: fajrtime)!
                let diff = nextfajr.timeIntervalSince(now)
                let hours = Int(diff) / 3600
                let minutes = (Int(diff) % 3600) / 60
                let countdown = "\(hours)h \(minutes)m"
                let time = response.data.timings.Fajr.components(separatedBy: " ").first ?? response.data.timings.Fajr
                return prayerentry(date: Date(), nextprayer: "Fajr", countdown: countdown, time: time)
            }
        } catch {
            print(error)
        }
        
        return prayerentry(date: Date(), nextprayer: "Error", countdown: "--", time: "--:--")
    }
    
    private func parseprayer(_ timestring: String) -> Date? {
        let components = timestring.components(separatedBy: " ")
        guard let timepart = components.first else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        
        if let time = formatter.date(from: timepart) {
            let calendar = Calendar.current
            let now = Date()
            var datecomponents = calendar.dateComponents([.year, .month, .day], from: now)
            let timecomponents = calendar.dateComponents([.hour, .minute], from: time)
            datecomponents.hour = timecomponents.hour
            datecomponents.minute = timecomponents.minute
            return calendar.date(from: datecomponents)
        }
        
        return nil
    }
}

struct prayerentry: TimelineEntry {
    let date: Date
    let nextprayer: String
    let countdown: String
    let time: String
}

struct prayerresponse: Codable {
    let data: prayerdata
}

struct prayerdata: Codable {
    let timings: widgettimings
}

struct widgettimings: Codable {
    let Fajr: String
    let Dhuhr: String
    let Asr: String
    let Maghrib: String
    let Isha: String
}

struct mizanwidgetview: View {
    var entry: provider.Entry
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "065F46"), Color(hex: "0D1117")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color(hex: "C9A227"))
                    
                    Text("Mizan")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Next Prayer")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.6))
                    
                    Text(entry.nextprayer)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("In")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.5))
                        
                        Text(entry.countdown)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "C9A227"))
                            .monospacedDigit()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("At")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.5))
                        
                        Text(entry.time)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .monospacedDigit()
                    }
                }
            }
            .padding(16)
        }
    }
}

@main
struct mizanwidget: Widget {
    let kind: String = "mizanwidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: provider()) { entry in
            if #available(iOS 17.0, *) {
                mizanwidgetview(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                mizanwidgetview(entry: entry)
            }
        }
        .configurationDisplayName("Prayer Times")
        .description("Shows the next prayer time and countdown.")
        .supportedFamilies([.systemMedium])
    }
}
