import Foundation
import SwiftUI

@MainActor
class surahdetailviewmodel: ObservableObject {
    @Published var ayahs: [ayahpair] = []
    @Published var loading = false
    
    func load(number: Int) async {
        loading = true
        do {
            ayahs = try await quranservice.shared.fetchayahs(surahnumber: number)
        } catch {
            print(error)
        }
        loading = false
    }
}
