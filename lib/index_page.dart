import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as glass;
import 'features/assistant/assistant_page.dart';
import 'features/assistant/providers/assistant_provider.dart';
import 'features/assistant/models/ai_model.dart';
import 'features/settings/pages/settings_page.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  bool _isSettingsOpen = false;
  bool _isCollapsed = false;

  Future<void> _toggleCollapse() async {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });

    if (_isCollapsed) {
      await windowManager.setResizable(false);
      await windowManager.setSize(const Size(180, 45));
      await glass.Window.setEffect(effect: glass.WindowEffect.transparent);
    } else {
      await windowManager.setResizable(true);
      await windowManager.setSize(const Size(600, 900));
      await windowManager.center();
      
      // Restore glass effect based on platform
      if (Platform.isWindows) {
        await glass.Window.setEffect(
          effect: glass.WindowEffect.acrylic,
          color: const Color(0x660A0A0B),
        );
      } else if (Platform.isMacOS) {
        await glass.Window.setEffect(effect: glass.WindowEffect.acrylic);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Main Glass Window
          if (!_isCollapsed)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0B).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1.5),
                      ),
                      child: Column(
                        children: [
                          _GhostHeader(
                            isSettings: _isSettingsOpen,
                            onSettingsToggle: () => setState(() => _isSettingsOpen = true),
                            onBack: () => setState(() => _isSettingsOpen = false),
                            isCollapsed: _isCollapsed,
                            onCollapseToggle: _toggleCollapse,
                          ),
                          Expanded(
                            child: _isSettingsOpen
                                ? SettingsPage(
                                    onBack: () => setState(() => _isSettingsOpen = false),
                                  )
                                : AssistantPage(
                                    onSettingsOpen: () => setState(() => _isSettingsOpen = true),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Collapsed Pill Bar (Re-using Header logic)
          if (_isCollapsed)
            Align(
              alignment: Alignment.topCenter,
              child: _GhostHeader(
                isSettings: _isSettingsOpen,
                onSettingsToggle: () {},
                isCollapsed: true,
                onCollapseToggle: _toggleCollapse,
              ),
            ),
        ],
      ),
    );
  }
}

class _GhostHeader extends StatelessWidget {
  final VoidCallback onSettingsToggle;
  final bool isCollapsed;
  final VoidCallback onCollapseToggle;
  final bool isSettings;
  final VoidCallback? onBack;

  const _GhostHeader({
    required this.onSettingsToggle,
    required this.isCollapsed,
    required this.onCollapseToggle,
    this.isSettings = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssistantProvider>();

    if (isCollapsed) {
      return _buildCollapsedPill();
    }

    return GestureDetector(
      onPanStart: (details) => windowManager.startDragging(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
        ),
        child: Row(
          children: [
            if (isSettings) ...[
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white70, size: 20),
                onPressed: onBack,
              ),
              const SizedBox(width: 8),
              const Text(
                'SYSTEM CONFIGURATION',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ] else ...[
              const Icon(Icons.auto_awesome, color: Colors.blueAccent, size: 20),
              const SizedBox(width: 12),
              const Text(
                '👻 GHOST ASSIST',
                style: TextStyle(
                  letterSpacing: 2,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
            const Spacer(),

            if (!isSettings) ...[
              IconButton(
                icon: Icon(
                  provider.isListening ? Icons.mic : Icons.mic_none,
                  size: 18,
                  color: provider.isListening ? Colors.redAccent : Colors.white60,
                ),
                onPressed: provider.toggleListening,
              ),
              IconButton(
                icon: Icon(
                  provider.isStealth ? Icons.visibility_off : Icons.visibility,
                  size: 18,
                  color: provider.isStealth ? Colors.greenAccent : Colors.redAccent,
                ),
                onPressed: provider.toggleStealth,
              ),
              PopupMenuButton<AIModel>(
                icon: Icon(_getModelIcon(provider.aiModel), size: 18, color: _getModelColor(provider.aiModel)),
                onSelected: provider.setModel,
                itemBuilder: (context) => _buildModelItems(provider),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 18, color: Colors.white38),
                onPressed: provider.resetChat,
              ),
              IconButton(
                icon: const Icon(Icons.settings, size: 18, color: Colors.white38),
                onPressed: onSettingsToggle,
              ),
            ],

            IconButton(
              icon: const Icon(Icons.keyboard_arrow_up, size: 18, color: Colors.white38),
              onPressed: onCollapseToggle,
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.white38),
              onPressed: () => windowManager.close(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedPill() {
    return GestureDetector(
      onPanStart: (details) => windowManager.startDragging(),
      child: Center(
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1B).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: onCollapseToggle,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome_motion, size: 14, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.white.withValues(alpha: 0.6)),
                const SizedBox(width: 4),
                const Text(
                  'Ask',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PopupMenuEntry<AIModel>> _buildModelItems(AssistantProvider provider) {
    return [
      const PopupMenuItem(enabled: false, child: Text('GEMINI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueAccent))),
      ...AIModel.values.where((m) => m.provider == AIProvider.gemini).map((m) => _buildMenuItem(m, provider)),
      const PopupMenuDivider(),
      const PopupMenuItem(enabled: false, child: Text('OPENAI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.greenAccent))),
      ...AIModel.values.where((m) => m.provider == AIProvider.openai).map((m) => _buildMenuItem(m, provider)),
      const PopupMenuDivider(),
      const PopupMenuItem(enabled: false, child: Text('ANTHROPIC', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orangeAccent))),
      ...AIModel.values.where((m) => m.provider == AIProvider.anthropic).map((m) => _buildMenuItem(m, provider)),
    ];
  }

  PopupMenuItem<AIModel> _buildMenuItem(AIModel model, AssistantProvider provider) {
    return PopupMenuItem<AIModel>(
      value: model,
      child: Row(
        children: [
          Icon(_getModelIcon(model), size: 16, color: _getModelColor(model)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(model.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              Text(model.description, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.6))),
            ],
          ),
          if (provider.aiModel == model) ...[
            const Spacer(),
            const Icon(Icons.check, size: 14, color: Colors.greenAccent),
          ],
        ],
      ),
    );
  }

  IconData _getModelIcon(AIModel model) => model == AIModel.geminiPro || model == AIModel.gpt4o ? Icons.bolt : Icons.flash_on;

  Color _getModelColor(AIModel model) {
    if (model.provider == AIProvider.openai) return Colors.greenAccent;
    if (model.provider == AIProvider.anthropic) return Colors.orangeAccent;
    return model == AIModel.geminiPro ? Colors.amberAccent : Colors.blueAccent;
  }
}
