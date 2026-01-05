import SwiftUI

struct prayersettingsview: View {
    @State private var settings = prayersettings.load()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            liquidbackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    prayersetting(name: "Fajr", icon: "sunrise.fill", adhan: $settings.fajradhan, adjust: $settings.fajradjust)
                    prayersetting(name: "Dhuhr", icon: "sun.max.fill", adhan: $settings.dhuhradhan, adjust: $settings.dhuhradjust)
                    prayersetting(name: "Asr", icon: "sun.min.fill", adhan: $settings.asradhan, adjust: $settings.asradjust)
                    prayersetting(name: "Maghrib", icon: "sunset.fill", adhan: $settings.maghribadhan, adjust: $settings.maghribadjust)
                    prayersetting(name: "Isha", icon: "moon.stars.fill", adhan: $settings.ishaadhan, adjust: $settings.ishaadjust)
                    
                    Spacer(minLength: 40)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Prayer Settings")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    settings.save()
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
    }
    
    private func prayersetting(name: String, icon: String, adhan: Binding<Bool>, adjust: Binding<Int>) -> some View {
        VStack(spacing: 16) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(appcolors.accent.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(appcolors.accent)
                }
                
                Text(name)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(appcolors.text)
                
                Spacer()
            }
            
            HStack(spacing: 14) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(appcolors.accent)
                    .frame(width: 24)
                
                Text("Adhan")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(appcolors.text)
                
                Spacer()
                
                Toggle("", isOn: adhan)
                    .tint(appcolors.accent)
                    .labelsHidden()
            }
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            HStack(spacing: 14) {
                Image(systemName: "clock.badge.exclamationmark.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(appcolors.accent)
                    .frame(width: 24)
                
                Text("Adjust")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(appcolors.text)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button {
                        adjust.wrappedValue = max(-15, adjust.wrappedValue - 1)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(appcolors.accent)
                    }
                    .buttonStyle(.plain)
                    
                    Text("\(adjust.wrappedValue > 0 ? "+" : "")\(adjust.wrappedValue) min")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(appcolors.text)
                        .frame(width: 70)
                        .monospacedDigit()
                    
                    Button {
                        adjust.wrappedValue = min(15, adjust.wrappedValue + 1)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(appcolors.accent)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .glasscard(padding: 20)
    }
}
