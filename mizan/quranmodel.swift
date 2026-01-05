import Foundation

struct surah: Codable, Identifiable {
    let number: Int
    let name: String
    let englishName: String
    let englishNameTranslation: String
    let numberOfAyahs: Int
    let revelationType: String
    
    var id: Int { number }
}

struct ayah: Codable, Identifiable {
    let number: Int
    let text: String
    let numberInSurah: Int
    let audio: String?
    
    var id: Int { number }
}

struct ayahpair {
    let arabic: ayah
    let transliteration: ayah
    let translation: ayah
    let audio: String?
}
