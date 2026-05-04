# Ghost Assist Roadmap

**Project Goal**: A professional, cross-platform AI-powered desktop assistant for interviews that remains completely invisible to screen sharing and recording software.

---

## 🎯 Core Objectives
- [x] **Completely Stealth**: Invisible to Zoom, Teams, Meet on both macOS and Windows.
- [x] **Skill-Based Identity**: Tailored expert instructions for specific technical and behavioral domains.
- [x] **Multi-Model Support**: Integrated Gemini, Claude 3.5, and GPT-4o.
- [x] **Secure Vault**: API keys stored in system-native secure storage.
- [x] **Interview Mode**: Continuous, hands-free standby with auto-restart and Hysteresis VAD.

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
- [x] **Infinite Standby**: Auto-restart listening loop for truly hands-free sessions.
- [x] **Hysteresis VAD**: Amplitude smoothing and moving average tracking to prevent mid-sentence cutoffs.
- [x] **Unified Stealth Frame**: Centralized `GhostHeader` with master window control and adaptive stealth pill.
- [x] **Expert Context Actions**: Smart "What should I say?" flow with automated screenshot integration.

### Phase 4: Production Ecosystem (In Progress)
- [x] **Secure Storage**: Integration of `flutter_secure_storage` for all API credentials.
- [x] **Custom Prompt Dashboard**: Intuitive UI for fine-tuning skill instructions.
- [/] **Vision Refinement**: Finalize multi-image analysis for Claude and Gemini SDKs.
- [ ] **Auto-Updater**: GitHub-integrated update mechanism for the desktop client.
- [ ] **Release Packaging**: DMG and MSIX installer workflows.

---

## 📐 Architecture Guidelines
- **Orchestration**: `IndexPage` acts as the master shell for HUD navigation and window state.
- **Unified Header**: `GhostHeader` handles all window controls, state transitions, and stealth logic.
- **State Management**: Provider (ChangeNotifier) with localized session controllers.
- **Dependency Injection**: GetIt with `StartUpService` in `lib/core/startup/`.

*Built with precision for the modern developer.* 👻💻
