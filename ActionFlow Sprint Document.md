# ActionFlow - AI Meeting Action Tracker

**Project Type**: iOS MVP for YC Application  
**Timeline**: 2 hours development  
**YC Theme**: Vertical AI Agents  
**Started**: June 17, 2025

## Project Overview

ActionFlow is an iOS app that automatically records meetings, transcribes audio, and uses AI to extract actionable items with assignees and deadlines. This demonstrates a vertical AI agent that completely automates meeting follow-up workflows.

### Core Value Proposition
- **Problem**: Manual meeting note-taking and follow-up tracking wastes hours
- **Solution**: AI automatically extracts action items from meeting audio
- **Market**: Brings "personal assistant" capabilities to everyone (YC Personal AI Staff theme)

## Technical Architecture

### Tech Stack
- **Frontend**: SwiftUI (iOS 15+)
- **Audio**: AVAudioRecorder + Speech Framework
- **AI**: OpenAI GPT API for action item extraction
- **Networking**: URLSession for API calls
- **Storage**: UserDefaults for MVP (no persistence needed initially)

### App Structure
```
ActionFlow/
├── Views/
│   ├── RecordingView.swift      # Main recording interface
│   ├── ProcessingView.swift     # Loading/transcription state
│   └── ResultsView.swift        # Action items display
├── Models/
│   ├── ActionItem.swift         # Data model
│   └── MeetingSession.swift     # Recording session data
├── Services/
│   ├── AudioRecorder.swift      # Recording functionality
│   ├── SpeechService.swift      # Transcription
│   └── AIService.swift          # OpenAI integration
└── Utils/
    └── APIKeys.swift            # Configuration
```

## Development Timeline (120 minutes)

### Hour 1: Core Recording & UI (0-60 min)
- [ ] **0-20 min**: Project setup & basic SwiftUI structure
  - [ ] Create new iOS project
  - [ ] Set up 3 main views (Recording, Processing, Results)
  - [ ] Add microphone permissions to Info.plist
  - [ ] Basic navigation structure

- [ ] **20-45 min**: Audio recording implementation
  - [ ] AVAudioRecorder setup
  - [ ] Start/stop recording functionality
  - [ ] Basic UI with record button
  - [ ] Audio file management

- [ ] **45-60 min**: Speech-to-text integration
  - [ ] Speech framework setup
  - [ ] Permission handling
  - [ ] Audio file → text conversion
  - [ ] Basic error handling

### Hour 2: AI Processing & Results (60-120 min)
- [ ] **60-90 min**: AI integration
  - [ ] OpenAI API setup
  - [ ] Create action item extraction prompt
  - [ ] JSON response parsing
  - [ ] Error handling for API calls

- [ ] **90-110 min**: Results display
  - [ ] ActionItem model creation
  - [ ] Results list UI
  - [ ] Basic sharing functionality
  - [ ] Navigation between views

- [ ] **110-120 min**: Polish & testing
  - [ ] Loading states
  - [ ] Error messages
  - [ ] Test with sample audio
  - [ ] Demo preparation

## Key Features (MVP)

### Core Features
1. ✅ **One-tap recording** - Large, intuitive record button
2. ✅ **Automatic transcription** - iOS Speech framework
3. ✅ **AI action extraction** - OpenAI API integration
4. ✅ **Clean results display** - List of action items
5. ✅ **Basic sharing** - Share action items via iOS share sheet

### Data Models
```swift
struct ActionItem {
    let task: String
    let assignee: String  // "unassigned" if not specified
    let deadline: String  // "no deadline" if not mentioned
    let priority: String? // Optional for v2
}

struct MeetingSession {
    let id: UUID
    let date: Date
    let duration: TimeInterval
    let transcript: String
    let actionItems: [ActionItem]
}
```

## AI Prompt Design

### OpenAI System Prompt
```
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
```

## Business Potential

### YC Application Angle
- **Vertical AI Agent**: Specifically targets meeting management workflow
- **Massive Market**: Every business has meetings
- **Clear ROI**: Saves hours per week of manual follow-up
- **Scalable**: Can expand to calendar integration, task management, team collaboration

### Growth Roadmap
1. **V1 (MVP)**: Basic recording → action items
2. **V2**: Calendar integration, team sharing
3. **V3**: Meeting insights, analytics, recurring meeting optimization
4. **V4**: Enterprise features, integrations (Slack, Asana, etc.)

## Technical Notes

### iOS Permissions Required
```xml
<key>NSMicrophoneUsageDescription</key>
<string>ActionFlow needs microphone access to record meetings</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>ActionFlow uses speech recognition to transcribe meetings</string>
```

### API Integration
- **OpenAI API Key**: Store securely, rate limit considerations
- **Error Handling**: Network failures, transcription errors, AI parsing failures
- **Offline Considerations**: Can record offline, process when connected

## Demo Script

### 2-Minute Demo Flow
1. **Open app** → Clean, simple interface
2. **Tap record** → Start sample meeting discussion
3. **Discuss action items** → "John will send the proposal by Friday, Sarah needs to review the budget"
4. **Stop recording** → Show processing state
5. **Display results** → Clean list with extracted action items
6. **Share** → Demonstrate iOS share functionality

### Sample Meeting Script for Demo
"Alright team, let's wrap up. John, can you send the client proposal by Friday? Sarah, please review the Q4 budget and get back to me by next Tuesday. I'll schedule the follow-up meeting for next week. Mike, don't forget to update the documentation before our next sprint."

## Success Metrics

### MVP Success Criteria
- [ ] Records and transcribes 5+ minute meeting accurately
- [ ] Extracts at least 80% of clear action items correctly
- [ ] Identifies assignees when explicitly mentioned
- [ ] Runs smoothly on iOS 15+ devices
- [ ] Demo-ready with sample content

### Next Steps After MVP
- App Store submission preparation
- User testing with real meetings
- YC application completion
- Team formation for full development

---

**Last Updated**: June 17, 2025  
**Status**: Planning Phase  
**Next Action**: Begin Hour 1 development