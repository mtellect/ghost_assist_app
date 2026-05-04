# 👻 Ghost Assist

**Ghost Assist** is a production-grade, stealth-first AI companion designed for interview support and real-time coding assistance on **macOS and Windows**. Built with Flutter and powered by a multi-AI engine (Gemini, Claude, GPT-4o), it provides a high-fidelity "Cyber-HUD" overlay that is invisible to others but crystal clear to you.

---

## 💎 Premium Features

### 🕵️‍♂️ True Stealth Mode (macOS & Windows)
The assistant utilizes native platform APIs to ensure the application window is **completely invisible** to screen-sharing software (Zoom, Slack, Google Meet, Teams) and screen recorders:
- **macOS**: Native `sharingType = .none` hardening.
- **Windows**: `SetWindowDisplayAffinity` (WDA_EXCLUDEFROMCAPTURE) integration.
Even when hidden from others, it remains 100% visible and interactive on your physical monitor.

### 🎙️ Interview Mode (Infinite Standby)
Our advanced **Conversation Mode** allows for a truly hands-free experience:
- **Infinite Standby**: The app stays active throughout your session, automatically restarting the listener after every turn.
- **Hysteresis VAD**: Sophisticated Voice Activity Detection with amplitude smoothing ensures it never cuts you off during a thinking pause.
- **Context-Aware**: One-click "Expert Actions" automatically capture your screen and audio for the most accurate AI coaching.

### 🧠 Skill-Based Architecture
Choose your interview domain, and the assistant instantly adapts its personality and depth:
- **Expert Domains**: Flutter, iOS, Android, Spring Boot, DSA, System Design, Behavioral, and more.
- **Custom Prompts**: Every skill's system instructions can be fine-tuned in the Settings Hub.

---

## 🛡️ Stealth Capabilities (Detectability Audit)

| Vector | Status | Technical Implementation |
| :--- | :--- | :--- |
| **Screen Sharing** | ✅ **Invisible** | Native Window Affinity (Windows) & SharingType (macOS) prevents capture by Zoom, Teams, and Meet. |
| **Audio Leakage** | ✅ **Private** | Direct microphone capture with no system loopback. Interviewers cannot "hear" the app. |
| **Mouse/KB Activity** | ✅ **Minimal** | "Interview Mode" is 100% hands-free. No suspicious mouse movements during the session. |
| **Proctoring Software** | ⚠️ **Medium** | Invisible to screen capture, but may be detected by aggressive background process scanners. |

---

## 🚀 How to Run (Release)

### **Windows**
1. **Download**: Get `ghost-assist-windows.zip` from GitHub.
2. **Extract All**: Right-click the ZIP and select **"Extract All"**. 
3. **Launch**: Open the extracted folder and run **`Ghost Assist.exe`**.

### **macOS**
1. **Download**: Get `ghost-assist-macos.zip`.
2. **Extract**: Double-click to extract the `Ghost Assist.app`.
3. **First Run**: Right-click the app and select **"Open"** to bypass security warnings.

---

## 🛠️ Tech Stack
- **SDK**: Flutter (Managed by FVM)
- **AI Engine**: Multi-Provider (Gemini, Claude, OpenAI)
- **State Management**: Provider
- **Native**: Custom C++/Swift Bridge for Stealth Parity.

*Built with precision for the modern developer.* 👻💻
