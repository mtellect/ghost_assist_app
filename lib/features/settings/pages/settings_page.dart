import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../../assistant/models/assistant_skill.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback onBack;
  const SettingsPage({super.key, required this.onBack});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _geminiController = TextEditingController();
  final _openaiController = TextEditingController();
  final _anthropicController = TextEditingController();
  final _templateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final provider = context.read<SettingsProvider>();
    _geminiController.text = provider.geminiKey;
    _openaiController.text = provider.openaiKey;
    _anthropicController.text = provider.anthropicKey;

    // Load current templates into JSON editor
    final templates = <String, String>{};
    for (var skill in AssistantSkill.values) {
      templates[skill.name] = provider.getCustomTemplate(skill) ?? '';
    }
    _templateController.text = const JsonEncoder.withIndent('  ').convert(templates);
  }

  Future<void> _saveAll() async {
    final provider = context.read<SettingsProvider>();

    // Save Keys
    await provider.saveKeys(
      gemini: _geminiController.text,
      openai: _openaiController.text,
      anthropic: _anthropicController.text,
    );

    // Save Templates
    try {
      final Map<String, dynamic> decoded = jsonDecode(_templateController.text);
      final Map<String, String> templates = decoded.map((k, v) => MapEntry(k, v.toString()));
      await provider.saveTemplates(templates);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid JSON in templates: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Settings saved successfully.')));
      widget.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: const Color(0xFF0F0F0F),
        child: Column(
          children: [
            _buildHeader(),
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.blueAccent,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white24,
              tabs: const [
                Tab(text: 'VAULT'),
                Tab(text: 'SKILL PROMPTS'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildVaultTab(), _buildPromptsTab()],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white70),
            onPressed: widget.onBack,
          ),
          const SizedBox(width: 8),
          const Text(
            'SYSTEM CONFIGURATION',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'API CREDENTIALS',
            style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildKeyField('GOOGLE GEMINI', _geminiController, Colors.blueAccent),
          const SizedBox(height: 20),
          _buildKeyField('OPENAI GPT-4o', _openaiController, Colors.greenAccent),
          const SizedBox(height: 20),
          _buildKeyField('ANTHROPIC CLAUDE', _anthropicController, Colors.orangeAccent),
        ],
      ),
    );
  }

  Widget _buildPromptsTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'JSON SKILL TEMPLATES',
            style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TextField(
              controller: _templateController,
              maxLines: null,
              expands: true,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black,
                hintText: '{ "skill_name": "Prompt instruction..." }',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.1)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: _saveAll,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('SAVE & APPLY'),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyField(String label, TextEditingController controller, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: accentColor, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: true,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
