# SIH 2026 Dementia Support Platform — UI/UX Master Implementation Plan

A comprehensive, accessible, AI-assisted, gamified cognitive-support platform built for people living with dementia, their caregivers, and communities with varied language and connectivity needs (including North Eastern India).

> [!IMPORTANT]
> **Non-Diagnostic & Ethical Boundary**: This application strictly does not diagnose, treat, or stage dementia, nor replace clinical professionals. All patient-facing copy is gentle, affirmative, and free of grading, failure indicators, or competitive ranking. Caregiver interfaces present non-clinical engagement and activity trends accompanied by plain-language disclaimers.

---

## User Review Required

> [!IMPORTANT]
> **State Management & Dependencies**: To maintain clean modularity and ensure zero-breakage across team branches, we will use Flutter's built-in `ChangeNotifier` and reactive service architecture (using typed state classes). If you have a specific team preference for state management (e.g. `flutter_bloc` or `provider`), please let us know; otherwise, the built-in reactive service pattern guarantees maximum portability, speed, and immediate testability without external package conflicts.

> [!NOTE]
> **Language & Regional Context**: The initial demo will support English, Hindi, and Assamese (representing North Eastern regional linguistic diversity), with extensible localization keys for Bengali, Bodo, and other languages.

---

## Complete Navigation Map & Screen Inventory

### Navigation Architecture

```mermaid
flowchart TD
    Splash[1.0 Splash & App Boot] --> Lang[1.1 Language Selector]
    Lang --> RoleGate[1.2 Role Selection Gateway]
    
    RoleGate -->|Caregiver Path| CG_Auth[2.0 Caregiver Intro & Consent]
    CG_Auth --> CG_Onboarding[2.1 Progressive Profile Onboarding (Steps 1-5)]
    CG_Onboarding --> AI_Processing[3.0 AI Profile Processing & Personalization]
    AI_Processing --> DomainOverview[3.1 Six-Domain Support Overview]
    DomainOverview --> CG_Dashboard[8.0 Caregiver Dashboard Hub]
    
    RoleGate -->|Patient Path (Profile Active)| JourneyHub[4.0 Today's Journey Hub]
    
    CG_Dashboard --> JourneyHub
    CG_Dashboard --> MemoryVault[9.0 Memory & Media Vault]
    CG_Dashboard --> TrendDetails[8.1 Activity & Engagement Trends]
    CG_Dashboard --> FeedbackInbox[7.1 Pending Feedback Tasks]
    
    JourneyHub --> SessionTriage{Caregiver Present?}
    SessionTriage -->|Solo| IndepActivity[5.0 Independent Activity: Nature & Memory Match]
    SessionTriage -->|Together: Cognitive| CogTogether[6.0 Cognitive Together: Family & Milestones]
    SessionTriage -->|Together: Connection| ConnTogether[6.5 Connection Together: Listen & Remember]
    
    IndepActivity --> SessionComplete[5.9 Gentle Session Completion]
    CogTogether --> SessionComplete
    ConnTogether --> SessionComplete
    
    SessionComplete --> CaregiverPresentCheck{Caregiver Available Now?}
    CaregiverPresentCheck -->|Yes| SessionFeedback[7.0 End-of-Session Caregiver Feedback]
    CaregiverPresentCheck -->|No / Later| SavePendingFeedback[7.2 Queued Feedback Reminder]
    
    SessionFeedback --> CG_Dashboard
    SavePendingFeedback --> JourneyHub
    MemoryVault --> AddMemory[9.1 Add Memory Item Flow]
```

---

### Low-Fidelity Screen Inventory

| Screen ID | Screen Name | Target Role | Key Responsibilities | Mandatory UI States |
| :--- | :--- | :--- | :--- | :--- |
| **SCR-01** | `SplashScreen` | All | App branding, asset preloading, offline cache initialization | Loading, Offline cached |
| **SCR-02** | `LanguageSelectionScreen` | All | Large-tap regional language picker (English, Hindi, Assamese) with audio sample | Selection active, Audio previewing |
| **SCR-03** | `RoleSelectionScreen` | All | "I am a Caregiver" (Primary), "Continue as Patient" (Secondary, enabled if profile exists), offline sync indicator | Ready, No-profile disabled state |
| **SCR-04** | `ConsentPrivacyScreen` | Caregiver | Plain-language data ownership explanation, zero-medical-claim notice, offline-first reassurance | Ready, Expanded details |
| **SCR-05** | `CaregiverOnboardingScreen` | Caregiver | 5-step wizard: Basic info, Baseline abilities (with "I am unsure"), Preferences & culture, Routines, Observations | Active step, Voice dictating, Saved draft, Success |
| **SCR-06** | `AiProcessingScreen` | Caregiver | Visual AI synthesis simulator showing exact reasoning stages without medical jargon | Preparing, Personalizing, Ready, Offline delayed, Error/Retry |
| **SCR-07** | `DomainOverviewScreen` | Caregiver | 6-domain support overview (Memory, Attention, Language, Executive, Orientation, Visuospatial) with caregiver override | Loaded, Override mode, Insufficient data fallback |
| **SCR-08** | `TodaysJourneyScreen` | Patient / Both | Daily gentle path: Caregiver presence check, 3 curated gentle activities, audio greeting | Ready, Caregiver toggle, Offline cached |
| **SCR-09** | `IndependentMatchActivityScreen` | Patient | Cultural/nature card matching: 48dp+ buttons, spoken instructions, pause/exit, no scores or timer stress | Intro audio, Playing, Paused, Gentle success |
| **SCR-10** | `CognitiveTogetherActivityScreen` | Both | Dual-view collaborative recognition: Family photos/objects, caregiver hint/prompt bar | Instructions, Interactive collaboration, Assist sheet |
| **SCR-11** | `ConnectionTogetherMusicScreen` | Both | "Listen & Remember": Large audio player, soothing waveform, nostalgic album art, caregiver conversation cards | Streaming, Local playback, Conversation tips |
| **SCR-12** | `SessionCompletionScreen` | Patient | Affirmative closing screen ("You did wonderful today", "Let's take a gentle rest") with audio outro | Normal celebration, Hand-off to caregiver |
| **SCR-13** | `CaregiverFeedbackScreen` | Caregiver | Quick mood chips, comfort rating, optional voice note (with transcription simulation), music feedback | Ready, Recording voice, Transcribing, Queued offline |
| **SCR-14** | `CaregiverDashboardScreen` | Caregiver | Activity overview, pending feedback alerts, engagement graphs, non-medical disclaimer | Data loaded, Offline synced, Pending items |
| **SCR-15** | `MemoryVaultScreen` | Caregiver | List of family photos, stories, songs, and conversation prompts with usage tags & sync status | Loaded, Empty state, Uploading, Synced |
| **SCR-16** | `AddMemoryScreen` | Caregiver | Add new photo/story/song: title, relation, cultural context, permission checkbox | Form entry, Media pick, Processing |

---

## Proposed Technical Implementation

### Directory Architecture

All code will reside modularly inside `mobile/lib/`:

```
mobile/lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         # Sand/cream, forest/teal, sage, soft peach
│   │   ├── app_typography.dart     # Elder-friendly readable text scales
│   │   └── app_strings.dart        # Multilingual strings (EN, HI, AS)
│   ├── theme/
│   │   ├── app_theme.dart          # High-contrast, 48dp+ touch target theme
│   │   └── accessibility_config.dart # Text scale & voice toggle state
│   ├── navigation/
│   │   └── app_routes.dart         # Typed route definitions & transitions
│   └── audio/
│       └── voice_assistant_service.dart # Simulated TTS & voice input handler
├── models/
│   ├── patient_profile.dart        # Baseline abilities, preferences, routines
│   ├── cognitive_domain.dart       # 6 domains with patient vs clinical labels
│   ├── activity_item.dart          # Activity metadata, modality, difficulty
│   ├── session_event.dart          # Hidden analytics payload
│   ├── caregiver_feedback.dart     # Observations, comfort, voice note
│   └── memory_item.dart            # Family photos, songs, stories
├── services/
│   ├── api_service.dart            # Live backend client (preserved & extended)
│   ├── mock_data_repository.dart   # Rich localized Indian/NER mock dataset
│   ├── profile_service.dart        # Patient onboarding & persistent state
│   ├── recommendation_service.dart # AI recommendation engine with 6 states
│   ├── session_service.dart        # Session state & hidden telemetry recorder
│   ├── feedback_service.dart       # Caregiver feedback & offline sync queue
│   └── memory_service.dart         # Caregiver memory vault repository
├── widgets/
│   ├── common/
│   │   ├── elder_button.dart       # High-contrast 56dp+ touch target button
│   │   ├── calm_card.dart          # Warm rounded card with subtle shadows
│   │   ├── voice_instruction_bar.dart # Speaker button + subtitles
│   │   ├── state_container.dart    # Unified Empty/Loading/Error/Offline wrapper
│   │   └── gentle_back_button.dart # Safe back confirmation
│   ├── patient/
│   │   ├── journey_step_node.dart  # Visual garden path progress node
│   │   └── gentle_dialog.dart      # Affirmative non-punitive popups
│   └── caregiver/
│       ├── domain_badge.dart       # Six-domain visual indicator
│       ├── voice_recorder_pill.dart# Voice note mic with waveform animation
│       └── trend_bar_chart.dart    # Accessible non-clinical trend graph
└── screens/
    ├── splash/
    ├── language/
    ├── onboarding/
    ├── ai_processing/
    ├── journey/
    ├── activities/
    │   ├── match/
    │   ├── cognitive_together/
    │   └── connection_music/
    ├── feedback/
    ├── dashboard/
    └── memory/
```

---

## Detailed Component Plan

### 1. Design System & Theme (`AppTheme`, `AppColors`, `AppTypography`)
- **Background**: Soft Warm Sand (`#FAF7F2`) and Cream (`#F5EFE6`).
- **Primary Action**: Deep Forest / Teal (`#1B493D` / `#163E34`).
- **Support & Progress**: Sage Green (`#5B8A72`).
- **Highlights**: Soft Peach / Coral (`#E28B6A`).
- **Elder Readability**: Minimum base font 18sp for patient mode, high contrast ratio (>7:1 on key actions), minimum button touch target height of 56dp.
- **Supportive Tone**: All patient-facing alerts replace "Wrong/Error" with "Let's take our time" or "Would you like to try together?".

### 2. Contracts & Models
- `PatientProfile`: ID, name, age bracket, preferred language, hearing/visual/mobility needs, reading comfort, baseline cognitive domains, preferences (gardening, Rabindra Sangeet, tea routines, local crafts), routines, observations.
- `CognitiveDomain`: 6 official domains (Memory, Attention, Language, Executive Function, Orientation, Visuospatial) with friendly dual titles (e.g. *Orientation* → *"Today & Places"*).
- `ActivityItem`: ID, domain, title, elder-friendly prompt, mode (`independent`, `cognitiveTogether`, `connectionTogether`), estimated duration (3-5 min), cultural tags (e.g. Assam tea garden, traditional diya, classical instruments).
- `SessionEvent`: Hidden performance payload (reaction latency, pause count, assist hints used, zero visible grading).
- `CaregiverFeedback`: Calm/engaged/tired observation tags, comfort scale (yes/somewhat/no), audio note URI, simulated transcription text, sync queue state (`synced`, `pending_offline`).

### 3. All 10 Required UI States Handled Universally
Using `StateContainer`:
1. `initial` / `empty`
2. `loading`
3. `processing` (AI simulation with steps)
4. `success`
5. `partialSuccess`
6. `noRecommendations`
7. `insufficientData` (with add-details CTA)
8. `offline` (clear offline badge, uses local cache)
9. `queuedToSync`
10. `slowConnection` / `recoverableError` (retry and edit buttons)

---

## Verification Plan

### Automated & Static Verification
- Run `flutter analyze` across `mobile/` to ensure zero compilation or lint errors.
- Verify that `mobile/lib/main.dart` boots smoothly and delegates to modular routes.
- Verify mock data integrity through unit tests on `mock_data_repository.dart` and `recommendation_service.dart`.

### Manual & Interactive Verification
- Walk through the entire flow end-to-end:
  1. Language Picker (English / Hindi / Assamese).
  2. Role Selection -> Caregiver Onboarding (5 steps with "I am unsure" options).
  3. AI Profile Processing (visualizing all 6 states).
  4. Six-Domain Support Overview.
  5. Today's Journey Hub (testing Caregiver Present vs Absent switch).
  6. Independent Activity ("Nature & Memory Match" with spoken prompts, pause, gentle celebration).
  7. Cognitive Together Activity ("Family & Milestones" with caregiver hint drawer).
  8. Connection Together Activity ("Listen & Remember" with audio player & conversation cues).
  9. End-of-Session Caregiver Feedback (testing voice recording simulation & offline queuing).
  10. Caregiver Dashboard with non-clinical visual trends.
  11. Memory Vault (adding and viewing personalized memories).
- Test offline toggle to ensure screens display offline notices and fallbacks smoothly without crashes.
