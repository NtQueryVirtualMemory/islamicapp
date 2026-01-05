import Foundation
import UserNotifications

class notificationservice {
    static let shared = notificationservice()
    private init() {}
    
    func requestauth() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print(error)
            return false
        }
    }
    
    func schedule(prayers: prayertimings) async {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let prayerlist: [(String, String)] = [
            ("Fajr", prayers.Fajr),
            ("Dhuhr", prayers.Dhuhr),
            ("Asr", prayers.Asr),
            ("Maghrib", prayers.Maghrib),
            ("Isha", prayers.Isha)
        ]
        
        for (name, timestring) in prayerlist {
            if let prayertime = parseprayer(timestring) {
                let content = UNMutableNotificationContent()
                content.title = "Time for \(name)"
                content.body = "It's time to pray \(name)"
                content.sound = .default
                content.badge = 1
                
                let components = Calendar.current.dateComponents([.hour, .minute], from: prayertime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                
                let request = UNNotificationRequest(identifier: name, content: content, trigger: trigger)
                
                do {
                    try await UNUserNotificationCenter.current().add(request)
                } catch {
                    print(error)
                }
            }
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
}
