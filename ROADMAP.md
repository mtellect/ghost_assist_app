# Ghost Assist Roadmap

**Project Goal**: A professional, cross-platform AI-powered desktop assistant for interviews that remains completely invisible to screen sharing and recording software.

---

## 🎯 Core Objectives
- [x] **Completely Stealth**: Invisible to Zoom, Teams, Meet on both macOS and Windows.
- [x] **Skill-Based Identity**: Tailored expert instructions for specific technical and behavioral domains.
- [x] **Multi-Model Support**: Integrated Gemini, Claude 3.5, and GPT-4o.
- [x] **Secure Vault**: API keys stored in system-native secure storage.
- [x] **Voice Interaction**: Intelligent hands-free mode with VAD (Voice Activity Detection).

---

## 🛠 Project Phases

### Phase 1: Foundation (Completed)
- [x] **Project Scaffolding**: Setup feature-based structure and global widgets.
- [x] **macOS Stealth Core**: Implement native `sharingType = .none` hardening.
- [x] **AI Service Core**: Integrate Gemini 1.5 Pro/Flash for text and vision analysis.
- [x] **Floating UI**: Frameless, glassmorphic, always-on-top overlay.
- [x] **Smart Capture**: Region-based screen capture for real-time context.

### Phase 2: Platform Parity & Intelligence (Completed)
- [x] **Windows Stealth Core**: Native C++ `SetWindowDisplayAffinity` integration.
- [x] **Skill-Based Architecture**: Renamed "Modes" to "Skills" for expert-domain coaching.
- [x] **Multi-Provider Hub**: Abstraction for Claude 3.5 Sonnet and GPT-4o.
- [x] **Modular settings**: DE-coupled settings page with individual skill prompt editing.
- [x] **Cyber-HUD styling**: Premium mesh gradients and high-end glassmorphism aesthetics.

### Phase 3: Interaction & Reliability (Completed)
- [x] **Global Hotkeys**: System-wide shortcuts (`Option + S, F, L, H`) on both platforms.
- [x] **Active Listener**: VAD-based auto-stop and auto-trigger for voice queries.
- [x] **Architecture Refactor**: Implemented `IndexPage` orchestration and modular widget decomposition.
- [x] **Unshakeable Overlay**: Elevated window levels (Floating/TopMost) to persist over full-screen apps.

### Phase 4: Production Ecosystem (In Progress)
- [x] **Secure Storage**: Integration of `flutter_secure_storage` for all API credentials.
- [x] **Custom Prompt Dashboard**: Intuitive UI for fine-tuning skill instructions.
- [ ] **Vision Refinement**: Finalize multi-image analysis for Claude and Gemini SDKs.
- [ ] **Auto-Updater**: GitHub-integrated update mechanism for the desktop client.
- [ ] **Release Packaging**: DMG and MSIX installer workflows.

---

## 📐 Architecture Guidelines
- **Orchestration**: `IndexPage` acts as the master shell for HUD navigation.
- **State Management**: Provider (ChangeNotifier) with localized session controllers.
- **Dependency Injection**: GetIt with `StartUpService` in `lib/core/startup/`.
- **Native Parity**: Maintain shared MethodChannel signatures across `Swift` and `C++` runners.

---

## 📝 Coding Standards
- Use **Dart 3** features (records, patterns, class modifiers).
- Maintain **100% Stealth** during development (verify with Zoom/Teams).
- Keep UI components granular and focused.

*Built with precision for the modern developer.* 👻💻
