import Foundation

struct prayersettings: Codable {
    var fajradhan: Bool = true
    var dhuhradhan: Bool = true
    var asradhan: Bool = true
    var maghribadhan: Bool = true
    var ishaadhan: Bool = true
    
    var fajradjust: Int = 0
    var dhuhradjust: Int = 0
    var asradjust: Int = 0
    var maghribadjust: Int = 0
    var ishaadjust: Int = 0
    
    static func load() -> prayersettings {
        if let data = UserDefaults.standard.data(forKey: "prayersettings"),
           let settings = try? JSONDecoder().decode(prayersettings.self, from: data) {
            return settings
        }
        return prayersettings()
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: "prayersettings")
        }
    }
}
