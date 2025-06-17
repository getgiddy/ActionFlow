//
//  ResultsView.swift
//  ActionFlow
//
//  Created by Gideon Anyalewechi on 17/06/2025.
//


import SwiftUI

struct ResultsView: View {
    @ObservedObject var meetingSession: MeetingSession
    @Binding var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text("Action Items")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("\(meetingSession.actionItems.count) items found")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Share") {
                    shareActionItems()
                }
                .buttonStyle(.borderedProminent)
            }
            
            // Action items list
            if meetingSession.actionItems.isEmpty {
                // Empty state
                VStack(spacing: 16) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    
                    Text("No action items found")
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    Text("Try recording a meeting with clear tasks and assignees")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(meetingSession.actionItems) { item in
                            ActionItemCard(item: item)
                        }
                    }
                    .padding(.vertical)
                }
            }
            
            // Bottom actions
            HStack {
                Button("Record New Meeting") {
                    startNewMeeting()
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
    
    private func shareActionItems() {
        // We'll implement sharing in Hour 2
        print("Sharing action items...")
    }
    
    private func startNewMeeting() {
        meetingSession.actionItems.removeAll()
        meetingSession.transcript = ""
        meetingSession.duration = 0
        appState = .ready
    }
}

struct ActionItemCard: View {
    let item: ActionItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.task)
                .font(.body)
                .fontWeight(.medium)
            
            HStack {
                Label(item.assignee, systemImage: "person.circle")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Label(item.deadline, systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    let session = MeetingSession()
    session.actionItems = [
        ActionItem(task: "Send client proposal", assignee: "John", deadline: "Friday"),
        ActionItem(task: "Review Q4 budget", assignee: "Sarah", deadline: "Next Tuesday")
    ]
    
    return ResultsView(
        meetingSession: session,
        appState: .constant(.results)
    )
}