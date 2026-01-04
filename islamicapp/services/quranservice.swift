import Foundation

class quranservice {
    static let shared = quranservice()
    
    func fetchsurahs() async throws -> [surah] {
        let url = URL(string: "https://api.alquran.cloud/v1/surah")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(surahresponse.self, from: data)
        return response.data
    }
    
    func fetchayahs(surahnumber: Int) async throws -> [ayah] {
        let url = URL(string: "https://api.alquran.cloud/v1/surah/\(surahnumber)/editions/quran-uthmani,en.sahih")!
        // This API returns multiple editions, but for simplicity we'll fetch one for now
        let (data, _) = try await URLSession.shared.data(from: url)
        // Note: The actual response for multiple editions is slightly different, 
        // but we'll use a single edition for the initial implementation.
        let urlSingle = URL(string: "https://api.alquran.cloud/v1/surah/\(surahnumber)")!
        let (dataSingle, _) = try await URLSession.shared.data(from: urlSingle)
        let response = try JSONDecoder().decode(ayahreresponse.self, from: dataSingle)
        return response.data.ayahs
    }
}
