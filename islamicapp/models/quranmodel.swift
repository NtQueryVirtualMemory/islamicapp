import Foundation

struct surahresponse: Codable {
    let data: [surah]
}

struct surah: Codable, Identifiable {
    let number: Int
    let name: String
    let englishName: String
    let englishNameTranslation: String
    let numberOfAyahs: Int
    let revelationType: String
    
    var id: Int { number }
}

struct ayahreresponse: Codable {
    let data: ayahdata
}

struct ayahdata: Codable {
    let ayahs: [ayah]
    let edition: edition
}

struct ayah: Codable, Identifiable {
    let number: Int
    let text: String
    let numberInSurah: Int
    
    var id: Int { number }
}

struct edition: Codable {
    let identifier: String
    let language: String
    let name: String
    let englishName: String
    let format: String
    let type: String
}
