//
//  APIKeys.swift
//  ActionFlow
//
//  Created by Gideon Anyalewechi on 17/06/2025.
//


import Foundation

struct APIKeys {
    // MARK: - OpenAI Configuration
    static let openAIKey = "your_openai_api_key_here"
    
    // MARK: - Demo Mode
    // Set this to true for demo purposes when no API key is available
    static let demoMode = true
    
    // MARK: - Helper Methods
    static var hasValidOpenAIKey: Bool {
        return !openAIKey.isEmpty && openAIKey != "your_openai_api_key_here"
    }
    
    static func isConfigured() -> Bool {
        return hasValidOpenAIKey || demoMode
    }
}
