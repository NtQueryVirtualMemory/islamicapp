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
        dua(
            title: "Morning Remembrance",
            arabic: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَـهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ",
            translation: "We have reached the morning and at this very time all sovereignty belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah, alone, without any partner.",
            category: "Morning & Evening",
            icon: "sun.and.horizon.fill",
            color: "FFB347"
        ),
        dua(
            title: "Evening Remembrance",
            arabic: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ للهِ، وَالْحَمْدُ للهِ، لَا إِلَهَ إِلاَّ اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ",
            translation: "We have reached the evening and at this very time all sovereignty belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah, alone, without any partner.",
            category: "Morning & Evening",
            icon: "moon.stars.fill",
            color: "9B59B6"
        ),
        dua(
            title: "Protection from Evil",
            arabic: "أَعُوذُ بِكَلِمَاتِ اللهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
            translation: "I seek refuge in the perfect words of Allah from the evil of what He has created.",
            category: "Protection",
            icon: "shield.fill",
            color: "4A90E2"
        ),
        dua(
            title: "Seeking Forgiveness",
            arabic: "أَسْتَغْفِرُ اللهَ الْعَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ",
            translation: "I seek forgiveness from Allah, the Magnificent, whom there is none worthy of worship except Him, the Living, the Sustainer, and I repent to Him.",
            category: "Forgiveness",
            icon: "heart.fill",
            color: "FF6B6B"
        ),
        dua(
            title: "Before Sleeping",
            arabic: "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا",
            translation: "In Your name, O Allah, I die and I live.",
            category: "Daily",
            icon: "bed.double.fill",
            color: "6C5CE7"
        ),
        dua(
            title: "Upon Waking",
            arabic: "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ",
            translation: "All praise is for Allah who gave us life after having taken it from us and unto Him is the resurrection.",
            category: "Daily",
            icon: "sunrise.fill",
            color: "F39C12"
        ),
        dua(
            title: "Before Eating",
            arabic: "بِسْمِ اللهِ",
            translation: "In the name of Allah.",
            category: "Daily",
            icon: "fork.knife",
            color: "27AE60"
        ),
        dua(
            title: "After Eating",
            arabic: "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ",
            translation: "All praise is for Allah who fed me this and provided it for me without any might or power from myself.",
            category: "Daily",
            icon: "hand.thumbsup.fill",
            color: "2ECC71"
        ),
        dua(
            title: "Entering Mosque",
            arabic: "اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ",
            translation: "O Allah, open the gates of Your mercy for me.",
            category: "Mosque",
            icon: "building.columns.fill",
            color: "1ABC9C"
        ),
        dua(
            title: "For Guidance",
            arabic: "اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي",
            translation: "O Allah, guide me and make me steadfast.",
            category: "Guidance",
            icon: "star.fill",
            color: "10B981"
        ),
        dua(
            title: "For Health",
            arabic: "اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي",
            translation: "O Allah, grant my body health. O Allah, grant my hearing health. O Allah, grant my sight health.",
            category: "Health",
            icon: "cross.fill",
            color: "E74C3C"
        ),
        dua(
            title: "For Travel",
            arabic: "سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ",
            translation: "Glory to Him who has subjected this to us, and we could never have it by our efforts. And to our Lord we shall return.",
            category: "Travel",
            icon: "airplane",
            color: "9B59B6"
        )
    ]
}
