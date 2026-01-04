import Foundation

class prayerservice {
    static let shared = prayerservice()
    
    func fetch() async throws -> prayerdata {
        let url = URL(string: "https://api.aladhan.com/v1/timingsByAddress?address=current")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(prayerresponse.self, from: data)
        return response.data
    }
}
