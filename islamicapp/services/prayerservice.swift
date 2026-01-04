import Foundation

class prayerservice {
    static let shared = prayerservice()
    
    func locate() async throws -> locationinfo {
        let url = URL(string: "https://ipinfo.io/json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(locationinfo.self, from: data)
    }
    
    func fetch(city: String, country: String) async throws -> prayerdata {
        let encodedcity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let encodedcountry = country.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? country
        let url = URL(string: "https://api.aladhan.com/v1/timingsByCity?city=\(encodedcity)&country=\(encodedcountry)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(prayerresponse.self, from: data)
        return response.data
    }
}
