//
//  ContentView.swift
//  ActionFlow
//
//  Created by Gideon Anyalewechi on 17/06/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var meetingSession = MeetingSession()
    @StateObject private var speechService = SpeechService()
    @State private var appState: AppState = .ready
    @State private var audioURL: URL?
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Main content based on state
                switch appState {
                case .ready, .recording:
                    RecordingView(
                        meetingSession: meetingSession,
                        appState: $appState,
                        onRecordingComplete: { url in
                            audioURL = url
                            startTranscription()
                        }
                    )
                case .processing:
                    ProcessingView()
                case .results:
                    ResultsView(
                        meetingSession: meetingSession,
                        appState: $appState
                    )
                }
            }
            .navigationTitle("ActionFlow")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func startTranscription() {
        guard let audioURL = audioURL else {
            appState = .results
            return
        }
        
        speechService.transcribeAudio(from: audioURL) { transcript in
            if let transcript = transcript {
                meetingSession.transcript = transcript
                // For now, we'll create dummy action items
                // In Hour 2, we'll replace this with AI processing
                createDummyActionItems()
            }
            appState = .results
        }
    }
    
    private func createDummyActionItems() {
        // Temporary dummy data for testing
        meetingSession.actionItems = [
            ActionItem(task: "Send client proposal", assignee: "John", deadline: "Friday"),
            ActionItem(task: "Review Q4 budget", assignee: "Sarah", deadline: "Next Tuesday"),
            ActionItem(task: "Update documentation", assignee: "unassigned", deadline: "no deadline")
        ]
    }
}

#Preview {
    ContentView()
}
