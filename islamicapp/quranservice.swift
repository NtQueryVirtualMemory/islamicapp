import Foundation

class quranservice {
    static let shared = quranservice()
    private init() {}
    
    func fetchsurahs() async throws -> [surah] {
        let url = URL(string: "https://api.alquran.cloud/v1/surah")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(surahlistresponse.self, from: data)
        return response.data
    }
    
    func fetchayahs(surahnumber: Int) async throws -> [ayah] {
        let url = URL(string: "https://api.alquran.cloud/v1/surah/\(surahnumber)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(surahdetailresponse.self, from: data)
        return response.data.ayahs
    }
}

struct surahlistresponse: Codable {
    let data: [surah]
}

struct surahdetailresponse: Codable {
    let data: surahdetail
}

struct surahdetail: Codable {
    let ayahs: [ayah]
}
