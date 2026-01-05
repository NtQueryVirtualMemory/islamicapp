import Foundation
import SwiftUI

@MainActor
class prayerviewmodel: ObservableObject {
    @Published var timings: prayertimings?
    @Published var hijri: String = ""
    @Published var location: String = ""
    @Published var loading: Bool = false
    @Published var currentprayer: String = ""
    @Published var nextprayer: String = ""
    @Published var countdown: String = ""
    
    private var timer: Timer?
    
    func load() async {
        loading = true
        do {
            let loc = try await prayerservice.shared.locate()
            let data = try await prayerservice.shared.fetch(city: loc.city, country: loc.country)
            timings = data.timings
            hijri = "\(data.date.hijri.day) \(data.date.hijri.month.en) \(data.date.hijri.year)"
            location = "\(loc.city), \(loc.country)"
            updatecurrent()
            starttimer()
            
            notificationservice.shared.request()
            await notificationservice.shared.schedule(prayers: data.timings)
        } catch {
            print(error)
        }
        loading = false
    }
    
    private func starttimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updatecurrent()
            }
        }
    }
    
    private func updatecurrent() {
        guard let t = timings else { return }
        
        let now = Date()
        let calendar = Calendar.current
        
        let prayers = [
            ("Fajr", t.Fajr),
            ("Dhuhr", t.Dhuhr),
            ("Asr", t.Asr),
            ("Maghrib", t.Maghrib),
            ("Isha", t.Isha)
        ]
        
        var nextprayertime: Date?
        var nextprayername: String = ""
        var currentprayername: String = "Isha"
        
        for (index, (name, timestring)) in prayers.enumerated() {
            if let prayertime = parseprayer(timestring) {
                if prayertime > now {
                    nextprayertime = prayertime
                    nextprayername = name
                    if index > 0 {
                        currentprayername = prayers[index - 1].0
                    } else {
                        currentprayername = "Isha"
                    }
                    break
                }
            }
        }
        
        if nextprayertime == nil {
            if let fajrtime = parseprayer(t.Fajr) {
                nextprayertime = calendar.date(byAdding: .day, value: 1, to: fajrtime)
                nextprayername = "Fajr"
                currentprayername = "Isha"
            }
        }
        
        if let next = nextprayertime {
            let diff = next.timeIntervalSince(now)
            let hours = Int(diff) / 3600
            let minutes = (Int(diff) % 3600) / 60
            let seconds = Int(diff) % 60
            
            if hours > 0 {
                countdown = String(format: "%dh %02dm", hours, minutes)
            } else {
                countdown = String(format: "%02dm %02ds", minutes, seconds)
            }
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentprayer = currentprayername
            nextprayer = nextprayername
        }
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
    
    deinit {
        timer?.invalidate()
    }
}
