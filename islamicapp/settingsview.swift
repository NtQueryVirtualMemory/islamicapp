import SwiftUI

struct settingsview: View {
    @AppStorage("notifications") private var notifications = true
    @AppStorage("calcmethod") private var calcmethod = "MWL"
    @AppStorage("asrmethod") private var asrmethod = "Standard"
    @State private var appear = false
    
    private func updatenotifications() {
        if notifications {
            notificationservice.shared.request()
        } else {
            notificationservice.shared.cancel()
        }
    }
    
    var body: some View {
        ZStack {
            liquidbackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    header
                        .padding(.bottom, 28)
                    
                    settingslist
                    
                    Spacer(minLength: 120)
                }
                .padding(.top, 60)
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                appear = true
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Settings")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(appcolors.text)
            
            Text("Customize your experience")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(appcolors.textsecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 20)
    }
    
    private var settingslist: some View {
        VStack(spacing: 24) {
            settingsgroup(title: "Notifications") {
                settingstoggle(
                    title: "Prayer Alerts",
                    subtitle: "Get notified for each prayer",
                    icon: "bell.fill",
                    isOn: $notifications
                )
                .onChange(of: notifications) {
                    updatenotifications()
                }
            }
            
            settingsgroup(title: "Calculation") {
                settingspicker(
                    title: "Method",
                    subtitle: "Prayer time calculation",
                    icon: "function",
                    selection: $calcmethod,
                    options: ["MWL", "ISNA", "Egypt", "Makkah", "Karachi"]
                )
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                settingspicker(
                    title: "Asr Juristic",
                    subtitle: "School of thought",
                    icon: "book.closed.fill",
                    selection: $asrmethod,
                    options: ["Standard", "Hanafi"]
                )
            }
            
            settingsgroup(title: "About") {
                settingsinfo(title: "Version", value: "1.0.0", icon: "info.circle.fill")
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                settingslink(title: "Privacy Policy", icon: "hand.raised.fill")
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                settingslink(title: "Rate App", icon: "star.fill")
            }
        }
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 30)
    }
    
    private func settingsgroup<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(appcolors.texttertiary)
                .padding(.leading, 4)
            
            VStack(spacing: 0) {
                content()
            }
            .glasscard(padding: 0)
        }
    }
    
    private func settingstoggle(title: String, subtitle: String, icon: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(appcolors.accent)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(appcolors.text)
                
                Text(subtitle)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(appcolors.texttertiary)
            }
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .tint(appcolors.accent)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
    
    private func settingspicker(title: String, subtitle: String, icon: String, selection: Binding<String>, options: [String]) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(appcolors.accent)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(appcolors.text)
                
                Text(subtitle)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(appcolors.texttertiary)
            }
            
            Spacer()
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button {
                        selection.wrappedValue = option
                    } label: {
                        HStack {
                            Text(option)
                            if selection.wrappedValue == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(selection.wrappedValue)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(appcolors.textsecondary)
                    
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(appcolors.texttertiary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
    
    private func settingsinfo(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(appcolors.accent)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(appcolors.text)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(appcolors.texttertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
    
    private func settingslink(title: String, icon: String) -> some View {
        Button {
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(appcolors.accent)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(appcolors.text)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(appcolors.texttertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
}
