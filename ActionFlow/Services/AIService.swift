//
//  AIService.swift
//  ActionFlow
//
//  Created by Gideon Anyalewechi on 17/06/2025.
//

import Foundation

class AIService: ObservableObject {
    @Published var isProcessing = false
    @Published var error: String?
    
    private let apiKey = APIKeys.openAIKey
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    struct OpenAIRequest: Codable {
        let model: String
        let messages: [Message]
        let temperature: Double
        let maxTokens: Int?
        
        enum CodingKeys: String, CodingKey {
            case model, messages, temperature
            case maxTokens = "max_tokens"
        }
    }
    
    struct Message: Codable {
        let role: String
        let content: String
    }
    
    struct OpenAIResponse: Codable {
        let choices: [Choice]
    }
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct ActionItemsResponse: Codable {
        let actionItems: [ActionItem]
        
        enum CodingKeys: String, CodingKey {
            case actionItems = "action_items"
        }
    }
    
    func extractActionItems(from transcript: String, completion: @escaping ([ActionItem]) -> Void) {
        guard APIKeys.hasValidOpenAIKey else {
            // Fallback to enhanced dummy data for demo
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                completion(self.generateSmartDummyData(from: transcript))
            }
            return
        }
        
        isProcessing = true
        error = nil
        
        let systemPrompt = """
        You are an expert meeting assistant. Analyze meeting transcripts and extract actionable items.
        
        Return ONLY valid JSON in this exact format:
        {
          "action_items": [
            {
              "task": "Clear, specific description of what needs to be done",
              "assignee": "Person's name or 'unassigned'",
              "deadline": "Specific date mentioned or 'no deadline'"
            }
          ]
        }
        
        Rules:
        - Only extract items that are actual commitments or tasks
        - Use exact names mentioned in the transcript
        - Include context in task descriptions
        - If no clear assignee, use "unassigned"
        - If no deadline mentioned, use "no deadline"
        - Be very precise and only extract clear action items
        """
        
        let request = OpenAIRequest(
            model: "gpt-4.1-nano",
            messages: [
                Message(role: "system", content: systemPrompt),
                Message(role: "user", content: "Meeting transcript:\n\n\(transcript)")
            ],
            temperature: 0.3,
            maxTokens: 1000
        )
        
        performAPIRequest(request: request, completion: completion)
    }
    
    private func performAPIRequest(request: OpenAIRequest, completion: @escaping ([ActionItem]) -> Void) {
        guard let url = URL(string: baseURL) else {
            DispatchQueue.main.async {
                self.error = "Invalid API URL"
                self.isProcessing = false
                completion([])
            }
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            DispatchQueue.main.async {
                self.error = "Failed to encode request: \(error.localizedDescription)"
                self.isProcessing = false
                completion([])
            }
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isProcessing = false
                
                if let error = error {
                    self?.error = "Network error: \(error.localizedDescription)"
                    completion([])
                    return
                }
                
                guard let data = data else {
                    self?.error = "No data received"
                    completion([])
                    return
                }
                
                // Debug: Print raw response
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("OpenAI Response: \(jsonString)")
                }
                
                do {
                    let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                    let content = openAIResponse.choices.first?.message.content ?? ""
                    let actionItems = self?.parseActionItems(from: content) ?? []
                    completion(actionItems)
                } catch {
                    self?.error = "Failed to parse response: \(error.localizedDescription)"
                    completion([])
                }
            }
        }.resume()
    }
    
    private func parseActionItems(from content: String) -> [ActionItem] {
        // Clean the content - remove code block markers if present
        let cleanContent = content
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let data = cleanContent.data(using: .utf8) else {
            print("Failed to convert content to data")
            return []
        }
        
        do {
            let response = try JSONDecoder().decode(ActionItemsResponse.self, from: data)
            return response.actionItems
        } catch {
            print("JSON parsing error: \(error)")
            print("Content being parsed: \(cleanContent)")
            
            // Fallback: try to extract items manually if JSON parsing fails
            return extractActionItemsManually(from: cleanContent)
        }
    }
    
    private func extractActionItemsManually(from content: String) -> [ActionItem] {
        // Simple fallback extraction for demo purposes
        let lines = content.components(separatedBy: .newlines)
        var items: [ActionItem] = []
        
        for line in lines {
            if line.lowercased().contains("task") && line.contains(":") {
                let task = line.components(separatedBy: ":").dropFirst().joined(separator: ":").trimmingCharacters(in: .whitespacesAndNewlines)
                if !task.isEmpty {
                    items.append(ActionItem(task: task, assignee: "unassigned", deadline: "no deadline"))
                }
            }
        }
        
        return items.isEmpty ? generateSmartDummyData(from: content) : items
    }
    
    private func generateSmartDummyData(from transcript: String) -> [ActionItem] {
        // Enhanced dummy data that analyzes the transcript for demo purposes
        let lowercaseTranscript = transcript.lowercased()
        var items: [ActionItem] = []
        
        // Look for common action patterns
        if lowercaseTranscript.contains("send") || lowercaseTranscript.contains("email") {
            items.append(ActionItem(task: "Send follow-up email", assignee: "unassigned", deadline: "no deadline"))
        }
        
        if lowercaseTranscript.contains("review") || lowercaseTranscript.contains("check") {
            items.append(ActionItem(task: "Review meeting notes", assignee: "unassigned", deadline: "no deadline"))
        }
        
        if lowercaseTranscript.contains("schedule") || lowercaseTranscript.contains("meeting") {
            items.append(ActionItem(task: "Schedule follow-up meeting", assignee: "unassigned", deadline: "next week"))
        }
        
        if lowercaseTranscript.contains("document") || lowercaseTranscript.contains("report") {
            items.append(ActionItem(task: "Update project documentation", assignee: "unassigned", deadline: "no deadline"))
        }
        
        // If no patterns found, provide a generic item
        if items.isEmpty {
            items.append(ActionItem(task: "Follow up on meeting discussion", assignee: "unassigned", deadline: "no deadline"))
        }
        
        return items
    }
}
