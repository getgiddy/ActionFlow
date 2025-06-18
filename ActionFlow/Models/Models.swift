//
//  Models.swift
//  ActionFlow
//
//  Created by Gideon Anyalewechi on 17/06/2025.
//


import Foundation

// MARK: - Action Item Model
struct ActionItem: Identifiable, Codable {
    let id = UUID()
    let task: String
    let assignee: String  // "unassigned" if not specified
    let deadline: String  // "no deadline" if not mentioned
    
    // Exclude 'id' from encoding/decoding since it's auto-generated
    enum CodingKeys: String, CodingKey {
        case task
        case assignee
        case deadline
    }
}

// MARK: - Meeting Session Model
class MeetingSession: ObservableObject, Identifiable {
    let id = UUID()
    let date = Date()
    @Published var duration: TimeInterval = 0
    @Published var transcript: String = ""
    @Published var actionItems: [ActionItem] = []
    @Published var isRecording = false
}

// MARK: - App State Enum
enum AppState {
    case ready        // Ready to record
    case recording    // Currently recording
    case processing   // Transcribing and extracting
    case results      // Showing results
}
