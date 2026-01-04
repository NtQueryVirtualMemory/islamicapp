import Foundation
import SwiftUI

@MainActor
class prayerviewmodel: ObservableObject {
    @Published var timings: prayertimings?
    @Published var hijri: String = ""
    @Published var location: String = ""
    @Published var loading: Bool = false
    
    func load() async {
        loading = true
        do {
            let data = try await prayerservice.shared.fetch()
            timings = data.timings
            hijri = "\(data.date.hijri.day) \(data.date.hijri.month.en) \(data.date.hijri.year)"
            location = data.meta.timezone
        } catch {
            print(error)
        }
        loading = false
    }
}
