//
//  SpeechService.swift
//  ActionFlow
//
//  Created by Gideon Anyalewechi on 17/06/2025.
//


import Foundation
import Speech
import AVFoundation

class SpeechService: ObservableObject {
    @Published var isTranscribing = false
    @Published var transcript = ""
    @Published var error: String?
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    completion(true)
                case .denied, .restricted, .notDetermined:
                    completion(false)
                @unknown default:
                    completion(false)
                }
            }
        }
    }
    
    func transcribeAudio(from url: URL, completion: @escaping (String?) -> Void) {
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            DispatchQueue.main.async {
                self.error = "Speech recognition not available"
                completion(nil)
            }
            return
        }
        
        requestPermission { [weak self] granted in
            guard granted else {
                self?.error = "Speech recognition permission denied"
                completion(nil)
                return
            }
            
            self?.performTranscription(from: url, completion: completion)
        }
    }
    
    private func performTranscription(from url: URL, completion: @escaping (String?) -> Void) {
        let request = SFSpeechURLRecognitionRequest(url: url)
        request.shouldReportPartialResults = false
        request.taskHint = .dictation
        
        isTranscribing = true
        error = nil
        
        speechRecognizer?.recognitionTask(with: request) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isTranscribing = false
                
                if let error = error {
                    self?.error = "Transcription failed: \(error.localizedDescription)"
                    completion(nil)
                    return
                }
                
                guard let result = result else {
                    self?.error = "No transcription result"
                    completion(nil)
                    return
                }
                
                if result.isFinal {
                    let transcriptText = result.bestTranscription.formattedString
                    self?.transcript = transcriptText
                    completion(transcriptText)
                } else {
                    // Update partial results for real-time feedback
                    self?.transcript = result.bestTranscription.formattedString
                }
            }
        }
    }
}