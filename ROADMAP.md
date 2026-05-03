# Ghost Assist Roadmap

**Project Goal**: A professional, AI-powered desktop assistant for interviews that remains completely invisible to screen sharing and recording software.

---

## 🎯 Core Objectives
- [x] **Completely Stealth**: Invisible to Zoom, Teams, Meet, and all screen sharing tools.
- [x] **Real-time AI Assistance**: Instant help with coding, system design, and behavioral questions.
- [x] **Modular Architecture**: Clean, scalable codebase using Dio, Provider, and Library/Part pattern.
- [ ] **Multi-Model Support**: Gemini (current), Claude, and OpenAI integration via abstraction.

---

## 🛠 Project Phases

### Phase 1: Foundation (Completed)
- [x] **Project Scaffolding**: Setup feature-based structure and global widgets.
- [x] **Stealth Core**: Implement macOS native `sharingType = .none` to hide window from capture.
- [x] **AI Service Core**: Integrate Gemini 1.5 Pro/Flash for text and vision analysis.
- [x] **API Infrastructure**: Robust Dio-based client with interceptors and multipart support.
- [x] **Floating UI**: Frameless, glassmorphic, always-on-top overlay.
- [x] **Smart Capture**: Region-based screen capture for real-time context.

### Phase 2: Enhanced Intelligence & Context (Completed)
- [x] **Interview Modes Expansion**: Refine system prompts for all 9 supported skills.
- [x] **Context Continuity**: Maintain conversation history for a single interview session.
- [x] **Model Selection**: Allow user to toggle between Gemini 1.5 Pro and Flash based on latency needs.
- [ ] **Prompt Templates**: Customizable templates for different company styles (e.g., Google, Amazon).

### Phase 3: UX & Performance
- [ ] **Global Hotkeys**: Trigger "Smart Capture" or "Hide/Show" via keyboard shortcuts.
- [ ] **OCR Pre-processing**: Optimize images before sending to AI to reduce latency.
- [ ] **Animations & Micro-interactions**: Fluid transitions between modes and responses.
- [ ] **Response Formatting**: Enhanced Markdown rendering (tables, charts, mermaid diagrams).

### Phase 4: Persistence & Settings
- [ ] **Local Storage**: Save settings (API keys, themes) and optionally encrypted session logs.
- [ ] **Security**: Secure storage for API keys using Keychain/Keyring.
- [ ] **Updates**: Integrated auto-updater for desktop client.

---

## 📐 Architecture Guidelines
- **State Management**: Provider (ChangeNotifier).
- **Dependency Injection**: GetIt with `StartUpService` in `lib/core/startup/`.
- **Environment Management**: `ApiEnvironmentEnum` and `AppFlavor` in `lib/core/enums/`.
- **Network**: Dio with `Library/Part` pattern in `lib/api/`.
- **Feature Structure**: 
  - `lib/features/[feature_name]/services/` (Interface + Implementation)
  - `lib/features/[feature_name]/models/`
  - `lib/features/[feature_name]/providers/`
  - `lib/features/[feature_name]/widgets/`
- **Native**: Maintain stealth logic in `macos/Runner/MainFlutterWindow.swift`.

---

## 📝 Coding Standards
- Use **Dart 3** features (records, patterns, class modifiers).
- All API calls must go through `ApiFunctionsV2` extension.
- Maintain **100% Stealth** during development (do not accidentally enable sharing).
