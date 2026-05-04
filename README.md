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

---

## 🚀 How to Run (Release)

### **Windows**
1. **Download**: Get `ghost-assist-windows.zip` from GitHub.
2. **Extract All**: Right-click the ZIP and select **"Extract All"**. 
   - ⚠️ **Important**: Do not run the `.exe` from inside the ZIP. You must extract the entire folder, as the `.exe` depends on the `.dll` files next to it.
3. **Launch**: Open the extracted folder and run **`Ghost Assist.exe`**.

### **macOS**
1. **Download**: Get `ghost-assist-macos.zip`.
2. **Extract**: Double-click to extract the `Ghost Assist.app`.
3. **Move**: Drag the app to your `/Applications` folder.
4. **First Run**: Right-click the app and select **"Open"** to bypass security warnings.

---

## 💻 Developer Setup

This project uses **[FVM](https://fvm.app/)** to ensure SDK consistency across platforms.

### 1. Requirements
- macOS 12.0+ or Windows 10 (Version 2004)+
- **Dart SDK** installed on your host machine.

### 2. Initial Setup (FVM)
First, install FVM and pull the project's pinned Flutter SDK:
```bash
# Install FVM globally
dart pub global activate fvm

# Install the pinned Flutter version (from .fvmrc)
fvm install
```

### 3. Installation & Build
Always prepend `fvm` to your flutter commands to use the project-specific SDK:

```bash
# Clone the repository
git clone https://github.com/mtellect/ghost_assist_app.git
cd ghost_assist_app

# Install dependencies
fvm flutter pub get

# Run the app
fvm flutter run -d macos  # or windows
```

### 4. Build for Release
To generate a production-ready binary:
```bash
# macOS
fvm flutter build macos --release

# Windows
fvm flutter build windows --release
```

---

## 🛠️ Tech Stack
- **SDK**: Flutter (Managed by FVM)
- **AI Engine**: Multi-Provider (Gemini, Claude, OpenAI)
- **State Management**: Provider & GetIt
- **Native**: Custom C++/Swift Bridge for Stealth Parity.

---

## 🔒 Security & Privacy
Ghost Assist is designed with a **"Local First"** philosophy.
- **Vault**: API keys are stored in the platform's secure enclave (Keychain/Data Protection API).
- **Ephemeral Context**: Screen captures and audio recordings are handled as temporary files and never stored permanently.

*Built with precision for the modern developer.* 👻💻
