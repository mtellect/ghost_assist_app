import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Initialize the editing session in the provider
    context.read<SettingsProvider>().startEditSession();
  }

  Future<void> _handleSave() async {
    final provider = context.read<SettingsProvider>();
    await provider.saveSettingsFromSession();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved successfully.')),
      );
      widget.onBack();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    // Disposal is handled by the provider if it's app-wide, 
    // but here we should be careful if the provider lives longer than the page.
    // However, for this app, the provider is a singleton in GetIt/MultiProvider.
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
            const Expanded(
              child: TabBarView(
                children: [
                  VaultSettingsTab(),
                  PromptSettingsTab(),
                ],
              ),
            ),
            SettingsFooter(onSave: _handleSave),
          ],
        ),
      ),
    );
  }
}
