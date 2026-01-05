import Foundation

class prayerservice {
    static let shared = prayerservice()
    private init() {}
    
    func locate() async throws -> locationdata {
        guard let url = URL(string: "https://ipinfo.io/json") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(locationdata.self, from: data)
    }
    
    func fetch(city: String, country: String, method: Int = 2) async throws -> prayerdata {
        let address = "\(city), \(country)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlstring = "https://api.aladhan.com/v1/timingsByAddress?address=\(address)&method=\(method)"
        guard let url = URL(string: urlstring) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(aladhanresponse.self, from: data)
        return response.data
    }
}

struct locationdata: Codable {
    let city: String
    let country: String
    let loc: String
    
    var coordinates: (lat: Double, lon: Double) {
        let parts = loc.split(separator: ",")
        guard parts.count == 2,
              let lat = Double(parts[0]),
              let lon = Double(parts[1]) else {
            return (0, 0)
        }
        return (lat, lon)
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
