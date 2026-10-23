import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:now/core/theme/tao_theme.dart';
import 'package:now/providers/theme_provider.dart';
import 'package:now/features/settings/providers/settings_provider.dart';
import 'package:now/features/settings/pages/about_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _showMaxBellsDialog(
    BuildContext context,
    SettingsProvider settingsProvider,
  ) async {
    final p = TaoPalette.of(context);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: p.frostedSheetSurface,
        title: Text(
          'Set Max Bells',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: p.inkPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(6, (index) {
            final value = 5 + index;
            return ListTile(
              title: Text(
                '$value bells',
                style: TextStyle(color: p.inkPrimary),
              ),
              trailing: settingsProvider.maxBells == value
                  ? Icon(Icons.check, color: p.accentPrimary, size: 18)
                  : null,
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
    final p = TaoPalette.of(context);

    return Scaffold(
      backgroundColor: p.scaffoldCanvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            letterSpacing: 2.0,
            fontSize: 16,
            color: p.inkPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          SwitchListTile(
            title: Text(
              'Dark Mode',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: p.inkPrimary,
              ),
            ),
            subtitle: Text(
              themeProvider.darkTheme
                  ? 'Obsidian Night (Yin) · Moonlit stone & warm amber'
                  : 'Washi Light (Yang) · Warm stone paper & bamboo sage',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: p.inkMuted,
              ),
            ),
            activeThumbColor: p.accentPrimary,
            value: themeProvider.darkTheme,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
          Divider(color: p.hairlineDivider),
          ListTile(
            title: Text(
              'Max Bells',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: p.inkPrimary,
              ),
            ),
            subtitle: Text(
              '${settingsProvider.maxBells} bells',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: p.inkMuted,
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: p.inkMuted),
            onTap: () => _showMaxBellsDialog(context, settingsProvider),
          ),
          Divider(color: p.hairlineDivider),
          SwitchListTile(
            title: Text(
              'Show Angel Numbers',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: p.inkPrimary,
              ),
            ),
            subtitle: Text(
              'Spontaneous alignments (11:11 · 3:33)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: p.inkMuted,
              ),
            ),
            activeThumbColor: p.accentPrimary,
            value: settingsProvider.showAngelNumbers,
            onChanged: (value) {
              settingsProvider.showAngelNumbers = value;
            },
          ),
          Divider(color: p.hairlineDivider),
          ListTile(
            leading: Icon(Icons.info_outline, color: p.inkMuted),
            title: Text(
              'About',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: p.inkPrimary,
              ),
            ),
            subtitle: Text(
              'Learn about N:OW and Paper Huts',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: p.inkMuted,
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: p.inkMuted),
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
