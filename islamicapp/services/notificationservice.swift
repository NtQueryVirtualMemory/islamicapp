import Foundation
import UserNotifications

class notificationservice {
    static let shared = notificationservice()
    
    func request() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Permission granted")
            }
        }
    }
    
    func schedule(name: String, time: String) {
        let content = UNMutableNotificationContent()
        content.title = "Time for \(name)"
        content.body = "It is now time for \(name) prayer."
        content.sound = .default
        
        let components = time.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else { return }
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: name, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
