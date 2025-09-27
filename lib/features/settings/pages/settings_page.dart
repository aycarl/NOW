import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:now/providers/theme_provider.dart';
import 'package:now/features/settings/providers/settings_provider.dart';
import 'package:now/features/settings/pages/about_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _showMaxBellsDialog(
    BuildContext context,
    SettingsProvider settingsProvider,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Max Bells'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(6, (index) {
            final value = 5 + index;
            return ListTile(
              title: Text('$value bells'),
              onTap: () {
                settingsProvider.maxBells = value;
                Navigator.of(context).pop();
              },
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeProvider.darkTheme,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
          ListTile(
            title: const Text('Max Bells'),
            subtitle: Text('${settingsProvider.maxBells} bells'),
            onTap: () => _showMaxBellsDialog(context, settingsProvider),
          ),
          SwitchListTile(
            title: const Text('Show Angel Numbers'),
            value: settingsProvider.showAngelNumbers,
            onChanged: (value) {
              settingsProvider.showAngelNumbers = value;
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('Learn about N:OW and Paper Huts'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AboutPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
