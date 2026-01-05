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
        guard let url = URL(string: "https://api.alquran.cloud/v1/surah/\(surahnumber)/editions/quran-uthmani,en.transliteration,en.sahih,ar.alafasy") else {
            return []
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(multisurahresponse.self, from: data)
            
            guard response.data.count == 4 else { return [] }
            
            let arabic = response.data[0].ayahs
            let translit = response.data[1].ayahs
            let translation = response.data[2].ayahs
            let audio = response.data[3].ayahs
            
            guard arabic.count == translit.count && arabic.count == translation.count && arabic.count == audio.count else { return [] }
            
            return zip(arabic, zip(translit, zip(translation, audio))).map { arabic, rest in
                let (translit, rest2) = rest
                let (translation, audio) = rest2
                return ayahpair(
                    arabic: arabic,
                    transliteration: translit,
                    translation: translation,
                    audio: audio.audio
                )
            }
        } catch {
            print("quran fetch error: \(error)")
            return []
        }
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
