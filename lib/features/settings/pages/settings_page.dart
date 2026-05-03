import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../../assistant/models/assistant_skill.dart';
import '../widgets/settings_header.dart';
import '../widgets/settings_footer.dart';
import '../widgets/vault_settings_tab.dart';
import '../widgets/prompt_settings_tab.dart';

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
  void dispose() {
    _tabController.dispose();
    _geminiController.dispose();
    _openaiController.dispose();
    _anthropicController.dispose();
    _templateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: const Color(0xFF0F0F0F),
        child: Column(
          children: [
            SettingsHeader(onBack: widget.onBack),
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
                children: [
                  VaultSettingsTab(
                    geminiController: _geminiController,
                    openaiController: _openaiController,
                    anthropicController: _anthropicController,
                  ),
                  PromptSettingsTab(templateController: _templateController),
                ],
              ),
            ),
            SettingsFooter(onSave: _saveAll),
          ],
        ),
      ),
    );
  }
}
