# SMRITI: Developer & AI Team Setup Guide

This guide explains how both the **UI/Mobile team** and the **AI/Backend team** can set up and run the SMRITI Dementia Care platform from scratch.

---

## Architecture Overview

```
SIH_Dimentia/
├── mobile/                   # Flutter application (Android / iOS / Web)
│   ├── lib/
│   │   ├── core/            # Design tokens, colors, typography, routes, audio
│   │   ├── models/          # Data schemas (PatientProfile, ActivityItem, Feedback)
│   │   ├── screens/         # UI screens (Activities, Onboarding, Journey, Dashboard)
│   │   ├── services/        # Business logic & API bridges (api_service, profile_service)
│   │   └── widgets/         # Elder-friendly reusable UI components
│   └── android/             # Native Android configuration (API 34-37 optimized)
└── backend/                 # Python AI & REST service
    ├── app.py               # Flask REST API endpoints
    └── requirements.txt     # Python dependencies
```

---

## 1. Prerequisites

Make sure the following tools are installed on your machine:
- **Git**
- **Flutter SDK** (v3.13+ or latest stable) — [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Android Studio** with Android SDK and an Android Emulator (API 34 or higher recommended)
- **Python** (3.10 or higher) — for the AI/Backend team
- **VS Code** with *Flutter* and *Python* extensions (recommended)

---

## 2. Clone & Checkout Branch

```bash
git clone https://github.com/ManjiriKench/SIH-Dementia-Platform.git
cd SIH-Dementia-Platform
git checkout ui/v2.0
```

---

## 3. Mobile Setup (UI & Frontend Team)

### Step 3.1: Install Flutter Packages
```bash
cd mobile
flutter pub get
```

### Step 3.2: Verify Setup
Run Flutter doctor to confirm all components are ready:
```bash
flutter doctor
```

### Step 3.3: Start Android Emulator
- Open **Android Studio** $\rightarrow$ **Device Manager** $\rightarrow$ Start your Virtual Device (e.g. Pixel 8 / API 34+).
- Or list devices via terminal:
  ```bash
  flutter devices
  ```

### Step 3.4: Launch the App
To run on your connected Android emulator:
```bash
flutter run
```
*(If multiple devices are connected, use `flutter run -d emulator-5554`)*

> [!TIP]
> **Super-fast UI Iterations**: If you are only working on UI layouts, animations, or styling and don't need Android native hardware features, run directly in Chrome for instant reloads:
> ```bash
> flutter run -d chrome
> ```

---

## 4. AI Team & Backend Setup

The backend hosts AI recommendation models, transcription services, and cognitive analysis endpoints.

### Step 4.1: Create Virtual Environment
```bash
cd backend
python -m venv venv
```

Activate the environment:
- **Windows (PowerShell)**:
  ```powershell
  .\venv\Scripts\Activate.ps1
  ```
- **Windows (Command Prompt)**:
  ```cmd
  .\venv\Scripts\activate.bat
  ```
- **macOS / Linux**:
  ```bash
  source venv/bin/activate
  ```

### Step 4.2: Install Dependencies
```bash
pip install -r requirements.txt
```

### Step 4.3: Start the Backend Server
```bash
python app.py
```
The server runs at: `http://127.0.0.1:5000` (listening on all interfaces `0.0.0.0:5000`).

---

## 5. Connecting Flutter Mobile to the AI Backend

The mobile app includes an automated environment-aware URL resolver in `lib/services/api_service.dart`:

| Environment | Base URL | Why |
| :--- | :--- | :--- |
| **Android Emulator** | `http://10.0.2.2:5000` | Android emulators map the host's localhost to `10.0.2.2`. Handled automatically! |
| **Flutter Web / Desktop** | `http://127.0.0.1:5000` | Standard localhost. |
| **Physical Android Device** | `http://localhost:5000` | Run `adb reverse tcp:5000 tcp:5000` via USB. |

### Testing Backend Connectivity from Mobile
You can test the connection in the app by navigating to `/backend_test`:
- In `lib/main.dart`, change `initialRoute: '/backend_test'` temporarily, or trigger `Navigator.pushNamed(context, '/backend_test')`.
- It will ping `GET /` on `app.py` and display the status message.

---

## 6. Where the AI Team Should Hook In

Here is where the AI and ML models connect with the Flutter app:

### 1. Dynamic Cognitive Recommendations
- **Mobile Hook**: `mobile/lib/services/recommendation_service.dart`
- **Recommended Backend Endpoint**: `POST /api/recommendations`
- **Input Payload**: `PatientProfile` JSON (interests, safe activities, preferred domain support, time of day).
- **Output**: Ranked list of activities tailored to the patient's current comfort level.

### 2. Caregiver Voice Note Transcription & Sentiment
- **Mobile Hook**: `mobile/lib/services/feedback_service.dart` & `mobile/lib/widgets/common/voice_input_field.dart`
- **Recommended Backend Endpoint**: `POST /api/feedback/transcribe`
- **Input Payload**: Audio file or recorded speech text.
- **Output**: Extracted sentiment tags (e.g., `['calm', 'engaged']`), identified triggers, and suggestions.

### 3. Patient Activity AI Simulation
- **Mobile Hook**: `mobile/lib/screens/ai_processing/ai_processing_screen.dart`
- Shows live animation while AI organises caregiver onboarding inputs into 6 cognitive domains (*Memory, Attention, Language, Executive Function, Orientation, Visuospatial*).

---

## 7. Key Files for the UI Team

- **Colors & Warm Theme**: `lib/core/constants/app_colors.dart` (Calm Forest Green, Sage, Warm White palette).
- **Typography**: `lib/core/constants/app_typography.dart` (High-contrast, accessible font sizing).
- **Text & Translations**: `lib/core/constants/app_strings.dart` (English, Hindi, and Assamese localized strings).
- **8 Core Dementia Activities**: Located in `lib/screens/activities/`:
  1. `look_and_talk_activity_screen.dart`
  2. `music_and_memory_activity_screen.dart`
  3. `story_from_photo_activity_screen.dart`
  4. `family_match_activity_screen.dart`
  5. `build_the_day_activity_screen.dart`
  6. `familiar_object_match_activity_screen.dart`
  7. `remember_recall_activity_screen.dart`
  8. `colour_word_focus_activity_screen.dart`

---

## 8. Code Verification Commands

Always run these before committing any new code:
```bash
cd mobile
flutter analyze      # Must report: "No issues found!"
flutter test         # Runs automated unit/widget tests
```
