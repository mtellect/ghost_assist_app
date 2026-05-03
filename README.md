# 👻 Ghost Assist

**Ghost Assist** is a production-grade, stealth-first AI companion designed for interview support and real-time coding assistance on macOS. Built with Flutter and powered by Google Gemini 1.5, it provides a high-fidelity "Cyber-HUD" overlay that is invisible to others but crystal clear to you.

---

## 💎 Premium Features

### 🕵️‍♂️ True Stealth Mode
The assistant utilizes native macOS window levels and `NSWindowSharingType.none` to ensure the application window is **completely invisible** to screen-sharing software (Zoom, Slack, Google Meet) and screen recorders, even while it remains 100% visible and interactive on your physical monitor.

### 🎤 Intelligent VAD Listener
Equipped with **Voice Activity Detection (VAD)**, Ghost Assist listens for your questions and automatically triggers an AI response after 1.5 seconds of silence. It includes hardware-accelerated noise suppression, echo cancellation, and auto-gain control for crystal-clear transcription.

### ⌨️ Global Command Center
Control the assistant from anywhere in macOS using global system-wide hotkeys:
- **`Option + S`**: **Smart Capture** (Analyze a specific region of your screen).
- **`Option + F`**: **Full Screen** (Analyze your entire workspace).
- **`Option + L`**: **Voice Mode** (Toggle the intelligent listener).
- **`Option + H`**: **Stealth Toggle** (Show/Hide the UI instantly).

### 🌌 Cyber-HUD UI
A modular, glassmorphism-inspired interface featuring:
- **Mesh Gradients**: Deep space aesthetics with subtle blue-accent glows.
- **Always-on-Top Overlay**: Stays floating even over native full-screen apps and across all macOS Spaces.
- **Dual Engine Support**: Switch instantly between **Gemini 1.5 Flash** (speed) and **Gemini 1.5 Pro** (depth).

---

## 🛠️ Architecture & Tech Stack

- **Core**: Flutter (macOS)
- **AI**: Google Generative AI (Gemini 1.5 Flash/Pro)
- **State Management**: Provider with Dependency Injection (GetIt)
- **Native Integration**: `window_manager` & Custom Method Channels for `NSWindow` hardening.
- **Audio**: `record` package with VAD logic.
- **Keyboard**: `hotkey_manager` for system-wide shortcuts.

---

## 🚀 Getting Started

### 1. Requirements
- macOS 12.0 or higher.
- A Google Gemini API Key.

### 2. Environment Setup
Add your Gemini API Key as a Dart define during build:
```bash
flutter run -d macos --dart-define=GEMINI_API_KEY=YOUR_API_KEY_HERE
```

### 3. Installation
```bash
git clone https://github.com/mtellect/ghost_assist_app.git
cd ghost_assist_app
flutter pub get
flutter run -d macos
```

---

## 🔒 Security & Privacy
Ghost Assist is designed with a "Local First" philosophy. It does not store your audio recordings or screen captures permanently. Captures are handled as temporary files and sent directly to the Gemini API for analysis.

---

## 🤝 Contribution
Contributions are welcome! Please feel free to submit a Pull Request or open an issue for feature requests.

*Built with precision for the modern developer.* 👻💻
