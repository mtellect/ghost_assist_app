# Ghost Assist Roadmap

**Project Goal**: A professional, AI-powered desktop assistant for interviews that remains completely invisible to screen sharing and recording software.

---

## 🎯 Core Objectives
- [x] **Completely Stealth**: Invisible to Zoom, Teams, Meet, and all screen sharing tools.
- [x] **Real-time AI Assistance**: Instant help with coding, system design, and behavioral questions.
- [x] **Modular Architecture**: Clean, scalable codebase using GetIt, Provider, and Service-Abstraction pattern.
- [x] **Voice Interaction**: Intelligent hands-free mode with VAD (Voice Activity Detection).
- [ ] **Multi-Model Support**: Gemini (current), Claude, and OpenAI integration via abstraction.

---

## 🛠 Project Phases

### Phase 1: Foundation (Completed)
- [x] **Project Scaffolding**: Setup feature-based structure and global widgets.
- [x] **Stealth Core**: Implement macOS native `sharingType = .none` to hide window from capture.
- [x] **AI Service Core**: Integrate Gemini 1.5 Pro/Flash for text and vision analysis.
- [x] **API Infrastructure**: Robust architecture with DI and specialized services.
- [x] **Floating UI**: Frameless, glassmorphic, always-on-top overlay.
- [x] **Smart Capture**: Region-based screen capture for real-time context.

### Phase 2: Enhanced Intelligence & Context (Completed)
- [x] **Interview Modes Expansion**: Refine system prompts for all 9 supported skills.
- [x] **Context Continuity**: Maintain conversation history for a single interview session.
- [x] **Model Selection**: Allow user to toggle between Gemini 1.5 Pro and Flash based on latency needs.
- [x] **Cyber-HUD Styling**: Premium mesh gradients and high-end glassmorphism aesthetics.

### Phase 3: Interaction & Performance (Completed)
- [x] **Global Hotkeys**: System-wide shortcuts (`Option + S, F, L, H`) for hands-free control.
- [x] **Active Listener**: VAD-based auto-stop and auto-trigger for voice queries.
- [x] **Audio Hardening**: Native noise suppression, echo cancellation, and auto-gain.
- [x] **Unshakeable Overlay**: Elevated window levels to stay on top of native full-screen apps and spaces.
- [x] **Modular UI Refactor**: Decomposed panel into granular, testable widgets.

### Phase 4: Persistence & Ecosystem (Planned)
- [ ] **Local Storage**: Save settings (API keys, themes) and optionally encrypted session logs.
- [ ] **Secure Vault**: Storage for API keys using macOS Keychain.
- [ ] **Multi-Provider Hub**: Integration for Claude 3.5 Sonnet and GPT-4o.
- [ ] **Prompt Templates**: Customizable templates for different company styles (e.g., Google, Amazon).
- [ ] **Auto-Updater**: Integrated update mechanism for the desktop client.

---

## 📐 Architecture Guidelines
- **State Management**: Provider (ChangeNotifier).
- **Dependency Injection**: GetIt with `StartUpService` in `lib/core/startup/`.
- **Environment Management**: `ApiEnvironmentEnum` and `AppFlavor` in `lib/core/enums/`.
- **Feature Structure**: 
  - `lib/features/[feature_name]/services/` (Interface + Implementation)
  - `lib/features/[feature_name]/models/`
  - `lib/features/[feature_name]/providers/`
  - `lib/features/[feature_name]/widgets/`
- **Native**: Maintain stealth logic in `macos/Runner/MainFlutterWindow.swift`.

---

## 📝 Coding Standards
- Use **Dart 3** features (records, patterns, class modifiers).
- Maintain **100% Stealth** during development (verify with QuickTime/Zoom).
- Keep components focused and reusable.

*Built with precision for the modern developer.* 👻💻
