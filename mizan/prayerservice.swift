import Foundation

class prayerservice {
    static let shared = prayerservice()
    private init() {}
    
    func fetch(latitude: Double, longitude: Double, method: Int = 2) async throws -> prayerdata {
        let urlstring = "https://api.aladhan.com/v1/timings?latitude=\(latitude)&longitude=\(longitude)&method=\(method)"
        guard let url = URL(string: urlstring) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(aladhanresponse.self, from: data)
        return response.data
    }
}

struct aladhanresponse: Codable {
    let data: prayerdata
}

struct prayerdata: Codable {
    let timings: prayertimings
    let date: prayerdate
}

struct prayertimings: Codable {
    let Fajr: String
    let Sunrise: String
    let Dhuhr: String
    let Asr: String
    let Maghrib: String
    let Isha: String
}

struct prayerdate: Codable {
    let hijri: hijridate
}

struct hijridate: Codable {
    let day: String
    let month: hijrimonth
    let year: String
}

struct hijrimonth: Codable {
    let en: String
}
