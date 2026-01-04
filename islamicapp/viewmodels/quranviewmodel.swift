import Foundation
import SwiftUI

@MainActor
class quranviewmodel: ObservableObject {
    @Published var surahs: [surah] = []
    @Published var loading: Bool = false
    
    func load() async {
        loading = true
        do {
            surahs = try await quranservice.shared.fetchsurahs()
        } catch {
            print(error)
        }
        loading = false
    }
}
