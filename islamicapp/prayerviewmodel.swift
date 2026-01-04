import Foundation
import SwiftUI

@MainActor
class prayerviewmodel: ObservableObject {
    @Published var timings: prayertimings?
    @Published var hijri: String = ""
    @Published var location: String = ""
    @Published var loading: Bool = false
    @Published var currentprayer: String = ""
    
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
        } catch {
            print(error)
        }
        loading = false
    }
    
    private func starttimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updatecurrent()
            }
        }
    }
    
    private func updatecurrent() {
        guard let t = timings else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let now = formatter.string(from: Date())
        
        let prayers = [
            ("Fajr", t.Fajr),
            ("Dhuhr", t.Dhuhr),
            ("Asr", t.Asr),
            ("Maghrib", t.Maghrib),
            ("Isha", t.Isha)
        ]
        
        var current = "Isha"
        for (name, time) in prayers {
            let cleantime = String(time.prefix(5))
            if now >= cleantime {
                current = name
            }
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentprayer = current
        }
    }
}
