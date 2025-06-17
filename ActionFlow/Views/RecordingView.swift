//
//  RecordingView.swift
//  ActionFlow
//
//  Created by Gideon Anyalewechi on 17/06/2025.
//


import SwiftUI

struct RecordingView: View {
    @ObservedObject var meetingSession: MeetingSession
    @Binding var appState: AppState
    let onRecordingComplete: (URL) -> Void
    @StateObject private var audioRecorder = AudioRecorder()
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Status text
            Text(audioRecorder.isRecording ? "Recording..." : "Ready to Record")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            // Duration display (if recording)
            if audioRecorder.isRecording {
                Text(formatDuration(audioRecorder.recordingDuration))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .monospaced()
            }
            
            Spacer()
            
            // Main record button
            Button(action: {
                if audioRecorder.isRecording {
                    stopRecording()
                } else {
                    startRecording()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(audioRecorder.isRecording ? Color.red : Color.blue)
                        .frame(width: 120, height: 120)
                        .shadow(radius: 10)
                    
                    if audioRecorder.isRecording {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                    } else {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                }
            }
            .scaleEffect(audioRecorder.isRecording ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: audioRecorder.isRecording)
            
            Text(audioRecorder.isRecording ? "Tap to Stop" : "Tap to Record")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
    }
    
    private func startRecording() {
        audioRecorder.startRecording()
        meetingSession.isRecording = true
        print("Starting recording...")
    }
    
    private func stopRecording() {
        audioRecorder.stopRecording()
        meetingSession.isRecording = false
        meetingSession.duration = audioRecorder.recordingDuration
        appState = .processing
        
        // Provide the audio file URL to parent
        onRecordingComplete(audioRecorder.audioURL)
        print("Stopping recording...")
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    RecordingView(
        meetingSession: MeetingSession(),
        appState: .constant(.ready),
        onRecordingComplete: { _ in }
    )
}
