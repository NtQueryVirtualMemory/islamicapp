import SwiftUI

struct duaview: View {
    let duas = duadatabase.shared.items
    
    var body: some View {
        ZStack {
            Color.midnight.ignoresSafeArea()
            liquidbackground().ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 35) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Duas")
                            .font(.system(size: 48, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .tracking(-2)
                        
                        Text("Supplications for the faithful")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 30)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(duas) { d in
                            duacard(d: d)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Color.clear.frame(height: 100)
                }
                .padding(.vertical, 40)
            }
        }
    }
}

struct duacard: View {
    let d: dua
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color(hex: d.color).opacity(0.15))
                    .frame(width: 64, height: 64)
                
                Image(systemName: d.icon)
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(Color(hex: d.color))
            }
            
            VStack(spacing: 4) {
                Text(d.title)
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Text(d.category)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.3))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .glass()
    }
}
