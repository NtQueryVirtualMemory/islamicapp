import SwiftUI

struct prayerview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("prayer times")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                VStack(spacing: 15) {
                    prayertimecard(name: "fajr", time: "05:30")
                    prayertimecard(name: "dhuhr", time: "12:15")
                    prayertimecard(name: "asr", time: "15:45")
                    prayertimecard(name: "maghrib", time: "18:20")
                    prayertimecard(name: "isha", time: "19:45")
                }
                .padding()
            }
        }
        .background(Color(hex: "0F1419"))
    }
}

struct prayertimecard: View {
    let name: String
    let time: String
    
    var body: some View {
        HStack {
            Text(name)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            Text(time)
                .font(.title3)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .glass()
    }
}
