import Foundation

struct prayerresponse: Codable {
    let data: prayerdata
}

struct prayerdata: Codable {
    let timings: prayertimings
    let date: prayerdate
    let meta: prayermeta
}

struct prayertimings: Codable {
    let Fajr: String
    let Dhuhr: String
    let Asr: String
    let Maghrib: String
    let Isha: String
    let Sunrise: String
    let Sunset: String
}

struct prayerdate: Codable {
    let readable: String
    let hijri: hijridate
}

struct hijridate: Codable {
    let date: String
    let day: String
    let month: hijrimonth
    let year: String
}

struct hijrimonth: Codable {
    let en: String
    let ar: String
}

struct prayermeta: Codable {
    let timezone: String
    let method: prayermethod
}

struct prayermethod: Codable {
    let name: String
}
