import SwiftUI

struct duacategoryview: View {
    let category: String
    let color: String
    @State private var selected: dua?
    @Environment(\.dismiss) private var dismiss
    
    var filtered: [dua] {
        duadatabase.shared.items.filter { $0.category == category }
    }
    
    var body: some View {
        ZStack {
            liquidbackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(filtered) { d in
                        Button {
                            selected = d
                        } label: {
                            duarow(d: d)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(appcolors.text)
                        .frame(width: 40, height: 40)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
        }
        .sheet(item: $selected) { d in
            duadetailview(dua: d)
        }
    }
    
    private func duarow(d: dua) -> some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(hex: d.color).opacity(0.15))
                    .frame(width: 48, height: 48)
                
                Image(systemName: d.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color(hex: d.color))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(d.title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(appcolors.text)
                
                Text(d.category)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(appcolors.texttertiary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(appcolors.texttertiary)
        }
        .glasscard(padding: 14)
    }
}
