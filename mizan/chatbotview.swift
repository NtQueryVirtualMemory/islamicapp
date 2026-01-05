import SwiftUI

struct chatbotview: View {
    @StateObject private var service = chatbotservice.shared
    @State private var inputText = ""
    @State private var appear = false
    @FocusState private var inputFocused: Bool
    
    var body: some View {
        ZStack {
            liquidbackground()
            
            VStack(spacing: 0) {
                header
                
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 16) {
                            if service.messages.isEmpty {
                                emptystate
                            } else {
                                ForEach(service.messages) { message in
                                    messagebubble(message: message)
                                        .id(message.id)
                                }
                            }
                            
                            if service.loading {
                                loadingindicator
                            }
                            
                            Spacer(minLength: 20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                    .onChange(of: service.messages.count) { _ in
                        if let lastMessage = service.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                inputbar
            }
        }
        .onAppear {
            service.loadMessages()
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                appear = true
            }
        }
    }
    
    private var header: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Islamic AI Assistant")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(appcolors.text)
                
                Text("Ask anything about Islam")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(appcolors.textsecondary)
            }
            
            Spacer()
            
            if !service.messages.isEmpty {
                Button {
                    service.clearHistory()
                } label: {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(appcolors.textsecondary)
                        .frame(width: 40, height: 40)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
        .padding(.bottom, 16)
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : -20)
    }
    
    private var emptystate: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(appcolors.accent.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "message.fill")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(appcolors.accent)
            }
            
            VStack(spacing: 8) {
                Text("Start a Conversation")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(appcolors.text)
                
                Text("Ask questions about Islam, Quran, Hadith, prayers, and more")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(appcolors.textsecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            VStack(spacing: 12) {
                suggestionbutton(text: "What are the 5 pillars of Islam?")
                suggestionbutton(text: "Explain the meaning of Surah Al-Fatiha")
                suggestionbutton(text: "How do I perform Wudu?")
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 30)
    }
    
    private func suggestionbutton(text: String) -> some View {
        Button {
            inputText = text
            sendMessage()
        } label: {
            Text(text)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(appcolors.text)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .glasscard(padding: 0)
        }
        .buttonStyle(.plain)
    }
    
    private func messagebubble(message: chatmessage) -> some View {
        HStack(alignment: .top, spacing: 12) {
            if message.role == "user" {
                Spacer()
            }
            
            if message.role == "assistant" {
                ZStack {
                    Circle()
                        .fill(appcolors.accent.opacity(0.2))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(appcolors.accent)
                }
            }
            
            VStack(alignment: message.role == "user" ? .trailing : .leading, spacing: 6) {
                Text(message.content)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(appcolors.text)
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(message.role == "user" ? appcolors.accent.opacity(0.2) : appcolors.surface)
                    )
                
                Text(formattime(message.timestamp))
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(appcolors.texttertiary)
                    .padding(.horizontal, 4)
            }
            .frame(maxWidth: 280, alignment: message.role == "user" ? .trailing : .leading)
            
            if message.role == "user" {
                ZStack {
                    Circle()
                        .fill(appcolors.accent.opacity(0.2))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(appcolors.accent)
                }
            }
            
            if message.role == "assistant" {
                Spacer()
            }
        }
    }
    
    private var loadingindicator: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(appcolors.accent.opacity(0.2))
                    .frame(width: 32, height: 32)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(appcolors.accent)
            }
            
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(appcolors.accent)
                        .frame(width: 8, height: 8)
                        .opacity(0.6)
                        .animation(
                            Animation.easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                            value: service.loading
                        )
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(appcolors.surface)
            )
            
            Spacer()
        }
    }
    
    private var inputbar: some View {
        HStack(spacing: 12) {
            TextField("Ask a question...", text: $inputText, axis: .vertical)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(appcolors.text)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .lineLimit(1...5)
                .focused($inputFocused)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
            
            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(inputText.isEmpty ? appcolors.texttertiary : appcolors.accent)
            }
            .disabled(inputText.isEmpty || service.loading)
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .padding(.bottom, 100)
        .background(.ultraThinMaterial)
    }
    
    private func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let message = inputText
        inputText = ""
        inputFocused = false
        
        Task {
            await service.sendMessage(message)
        }
    }
    
    private func formattime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
