import Foundation

struct chatmessage: Identifiable, Codable {
    let id: String
    let role: String
    let content: String
    let timestamp: Date
    
    init(role: String, content: String) {
        self.id = UUID().uuidString
        self.role = role
        self.content = content
        self.timestamp = Date()
    }
}

class chatbotservice: ObservableObject {
    static let shared = chatbotservice()
    private init() {}
    
    @Published var messages: [chatmessage] = []
    @Published var loading = false
    
    private let apikey = "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"
    private let model = "nvidia/nemotron-3-nano-30b-a3b:free"
    private let systemPrompt = """
You are an Islamic knowledge assistant. You provide accurate, respectful, and helpful information about Islam, including:
- Quran verses and their meanings
- Hadith and Islamic teachings
- Prayer guidance and Islamic practices
- Islamic history and scholars
- Answers to questions about faith, worship, and daily Islamic life

Always provide responses with respect and accuracy. When citing Quran or Hadith, include references. If you're unsure about something, acknowledge it and suggest consulting a qualified scholar.
"""
    
    func loadMessages() {
        if let data = UserDefaults.standard.data(forKey: "chatmessages"),
           let saved = try? JSONDecoder().decode([chatmessage].self, from: data) {
            messages = saved
        }
    }
    
    func saveMessages() {
        if let data = try? JSONEncoder().encode(messages) {
            UserDefaults.standard.set(data, forKey: "chatmessages")
        }
    }
    
    func clearHistory() {
        messages.removeAll()
        saveMessages()
    }
    
    func sendMessage(_ content: String) async {
        let userMessage = chatmessage(role: "user", content: content)
        
        await MainActor.run {
            messages.append(userMessage)
            loading = true
            saveMessages()
        }
        
        do {
            let response = try await callAPI()
            let assistantMessage = chatmessage(role: "assistant", content: response)
            
            await MainActor.run {
                messages.append(assistantMessage)
                loading = false
                saveMessages()
            }
        } catch {
            print("Chatbot error: \(error)")
            let errorMessage = chatmessage(role: "assistant", content: "Sorry, I encountered an error: \(error.localizedDescription). Please check your internet connection and try again.")
            
            await MainActor.run {
                messages.append(errorMessage)
                loading = false
                saveMessages()
            }
        }
    }
    
    private func callAPI() async throws -> String {
        let url = URL(string: "https://openrouter.ai/api/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        
        var apiMessages: [[String: String]] = [
            ["role": "system", "content": systemPrompt]
        ]
        
        for msg in messages {
            apiMessages.append(["role": msg.role, "content": msg.content])
        }
        
        let body: [String: Any] = [
            "model": model,
            "messages": apiMessages,
            "temperature": 0.7,
            "max_tokens": 1000
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Log response for debugging
        if let httpResponse = response as? HTTPURLResponse {
            print("API Status: \(httpResponse.statusCode)")
        }
        
        if let responseString = String(data: data, encoding: .utf8) {
            print("API Response: \(responseString)")
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NSError(domain: "ChatbotError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"])
        }
        
        // Check for API error
        if let error = json["error"] as? [String: Any],
           let message = error["message"] as? String {
            throw NSError(domain: "ChatbotError", code: -1, userInfo: [NSLocalizedDescriptionKey: "API Error: \(message)"])
        }
        
        guard let choices = json["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw NSError(domain: "ChatbotError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"])
        }
        
        return content
    }
}
