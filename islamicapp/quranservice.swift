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
    
    func fetchayahs(surahnumber: Int) async throws -> [ayahpair] {
        let url = URL(string: "https://api.alquran.cloud/v1/surah/\(surahnumber)/editions/ar.alafasy,en.transliteration")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(multisurahresponse.self, from: data)
        
        guard response.data.count == 2 else { return [] }
        
        let arabic = response.data[0].ayahs
        let translit = response.data[1].ayahs
        
        return zip(arabic, translit).map { ayahpair(arabic: $0, transliteration: $1, audio: $0.audio) }
    }
}

struct surahlistresponse: Codable {
    let data: [surah]
}

struct multisurahresponse: Codable {
    let data: [surahdetail]
}

struct surahdetail: Codable {
    let ayahs: [ayah]
}
