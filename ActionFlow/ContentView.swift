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
    @StateObject private var aiService = AIService()
    @State private var appState: AppState = .ready
    @State private var audioURL: URL?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
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
            .alert("Error", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
        .onAppear {
            checkAPIConfiguration()
        }
    }
    
    private func checkAPIConfiguration() {
        if !APIKeys.isConfigured() {
            alertMessage = "API not configured. Using demo mode."
            showingAlert = true
        }
    }
    
    private func startTranscription() {
        guard let audioURL = audioURL else {
            showError("No audio file found")
            return
        }
        
        speechService.transcribeAudio(from: audioURL) { transcript in
            if let transcript = transcript {
                meetingSession.transcript = transcript
                print("Transcript: \(transcript)")
                
                // Now extract action items using AI
                extractActionItems(from: transcript)
            } else {
                showError("Failed to transcribe audio")
            }
        }
    }
    
    private func extractActionItems(from transcript: String) {
        aiService.extractActionItems(from: transcript) { actionItems in
            DispatchQueue.main.async {
                meetingSession.actionItems = actionItems
                appState = .results
                
                if let error = aiService.error {
                    showError("AI processing error: \(error)")
                }
            }
        }
    }
    
    private func showError(_ message: String) {
        DispatchQueue.main.async {
            alertMessage = message
            showingAlert = true
            appState = .results // Show results even with errors
        }
    }
}

#Preview {
    ContentView()
}
