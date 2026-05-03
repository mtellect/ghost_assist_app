# 👻 Ghost Assist

**Ghost Assist** is a production-grade, stealth-first AI companion designed for interview support and real-time coding assistance on **macOS and Windows**. Built with Flutter and powered by a multi-AI engine (Gemini, Claude, GPT-4o), it provides a high-fidelity "Cyber-HUD" overlay that is invisible to others but crystal clear to you.

---

## 💎 Premium Features

### 🕵️‍♂️ True Stealth Mode (macOS & Windows)
The assistant utilizes native platform APIs to ensure the application window is **completely invisible** to screen-sharing software (Zoom, Slack, Google Meet, Teams) and screen recorders:
- **macOS**: Native `sharingType = .none` hardening.
- **Windows**: `SetWindowDisplayAffinity` (WDA_EXCLUDEFROMCAPTURE) integration.
Even when hidden from others, it remains 100% visible and interactive on your physical monitor.

### 🧠 Skill-Based Coaching
Ghost Assist has transitioned to a **Skill-Based Architecture**. Choose your interview domain, and the assistant instantly adapts its personality and depth:
- **Expert Domains**: Flutter, iOS, Android, Spring Boot, DSA, System Design, Behavioral, and more.
- **Custom Prompts**: Every skill's system instructions can be fine-tuned in the Settings Hub.

### 🌌 Multi-AI Provider Hub
Switch engines on the fly without restarting. Ghost Assist supports the world's most powerful models:
- **Google**: Gemini 1.5 Pro & Flash.
- **Anthropic**: Claude 3.5 Sonnet.
- **OpenAI**: GPT-4o & GPT-4o Mini.

### ⌨️ Global Command Center
Control the assistant from anywhere using global system-wide hotkeys:
- **`Option + S`**: **Smart Capture** (Analyze a specific region of your screen).
- **`Option + F`**: **Full Screen** (Analyze your entire workspace).
- **`Option + L`**: **Voice Mode** (Toggle the intelligent listener).
- **`Option + H`**: **Stealth Toggle** (Show/Hide the UI instantly).

---

## 🛠️ Architecture & Tech Stack

- **Core**: Flutter (macOS & Windows)
- **AI Engine**: Multi-Provider (Gemini, Claude, OpenAI)
- **State Management**: Provider with Dependency Injection (GetIt)
- **Native Integration**: Custom C++/Swift Method Channels for platform stealth parity.
- **Storage**: `flutter_secure_storage` for API Vault and local settings.
- **Keyboard**: `hotkey_manager` for system-wide shortcuts.

---

## 🚀 Getting Started

### 1. Requirements
- macOS 12.0+ or Windows 10 (Version 2004)+
- API Keys for Gemini, OpenAI, or Anthropic.

### 2. Installation
```bash
git clone https://github.com/mtellect/ghost_assist_app.git
cd ghost_assist_app
flutter pub get
flutter run -d macos # or windows
```

---

## 🔒 Security & Privacy
Ghost Assist is designed with a **"Local First"** philosophy.
- **Vault**: API keys are stored in the platform's secure enclave (Keychain/Data Protection API).
- **Ephemeral Context**: Screen captures and audio recordings are handled as temporary files and never stored permanently.

*Built with precision for the modern developer.* 👻💻
