import Foundation
import SwiftUI

@MainActor
class quranviewmodel: ObservableObject {
    @Published var surahs: [surah] = []
    @Published var loading = false
    
    func load() async {
        guard surahs.isEmpty else { return }
        loading = true
        do {
            surahs = try await quranservice.shared.fetchsurahs()
        } catch {
            print(error)
        }
        loading = false
    }
}
