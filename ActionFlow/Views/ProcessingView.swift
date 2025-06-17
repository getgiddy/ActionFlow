//
//  ProcessingView.swift
//  ActionFlow
//
//  Created by Gideon Anyalewechi on 17/06/2025.
//


import SwiftUI

struct ProcessingView: View {
    @State private var isAnimating = false
    @State private var currentStep = 0
    
    let steps = [
        "Transcribing audio...",
        "Extracting action items...",
        "Identifying assignees..."
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Animated loading indicator
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.3), lineWidth: 8)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: isAnimating)
            }
            
            Text("Processing Meeting...")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            VStack(spacing: 8) {
                ForEach(0..<steps.count, id: \.self) { index in
                    HStack {
                        Image(systemName: index <= currentStep ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(index <= currentStep ? .green : .secondary)
                        
                        Text(steps[index])
                            .foregroundColor(index <= currentStep ? .primary : .secondary)
                        
                        Spacer()
                    }
                }
            }
            .font(.body)
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear {
            isAnimating = true
            simulateProgress()
        }
        .padding()
    }
    
    private func simulateProgress() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if currentStep < steps.count - 1 {
                currentStep += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

#Preview {
    ProcessingView()
}
