import Foundation

struct dua: Identifiable {
    let id = UUID()
    let title: String
    let arabic: String
    let translation: String
    let category: String
    let icon: String
    let color: String
}

class duadatabase {
    static let shared = duadatabase()
    
    let items: [dua] = [
        dua(title: "Morning", arabic: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ", translation: "We have reached the morning and at this very time unto Allah belongs all sovereignty.", category: "Daily", icon: "sun.max.fill", color: "FFB347"),
        dua(title: "Evening", arabic: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ", translation: "We have reached the evening and at this very time unto Allah belongs all sovereignty.", category: "Daily", icon: "moon.stars.fill", color: "778899"),
        dua(title: "Protection", arabic: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ", translation: "In the name of Allah with whose name nothing can harm.", category: "Protection", icon: "shield.fill", color: "10B981"),
        dua(title: "Healing", arabic: "أَذْهِبِ الْبَأْسَ رَبَّ النَّاسِ", translation: "Remove the suffering, O Lord of mankind.", category: "Healing", icon: "heart.fill", color: "FF6B6B")
    ]
}
