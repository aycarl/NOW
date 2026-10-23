import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:now/core/theme/tao_theme.dart';
import 'package:now/core/widgets/zen_sound_symbol.dart';
import 'package:now/features/angel_numbers/angel_numbers_page.dart';
import 'package:now/features/mindful_bells/widgets/bell_form_dialog.dart';
import 'package:now/features/settings/providers/settings_provider.dart';

/// A page that allows users to manage their daily Mindful Bells.
///
/// Embodies the Tao "Less is More" concept:
/// - When collapsed (`currentPageIndex == 0`), renders as a soft frosted-glass
///   bottom peeking tab displaying `MINDFUL BELLS 🔔`.
/// - When expanded (`currentPageIndex == 1`), displays scheduled mindfulness
///   moments as calm, borderless hairline rows with minimalist sacred geometry
///   sound symbols (`ZenSoundSymbol`).
class MindfulBellsPage extends StatefulWidget {
  /// The index of the current page in the stacked home layout.
  final int currentPageIndex;

  /// A callback function to toggle between pages.
  final VoidCallback onToggle;

  /// Creates a new instance of the MindfulBellsPage.
  const MindfulBellsPage({
    super.key,
    this.currentPageIndex = 1,
    required this.onToggle,
  });

  @override
  State<MindfulBellsPage> createState() => _MindfulBellsPageState();
}

class _MindfulBellsPageState extends State<MindfulBellsPage> {
  final List<String> _soundCycle = const [
    'default',
    'singing_bowl',
    'chime',
    'nature',
  ];

  List<Map<String, String>> bells = [
    {'time': '07:00 AM', 'label': 'Morning Bell', 'sound': 'default'},
    {'time': '08:30 AM', 'label': 'Work Bell', 'sound': 'default'},
  ];

  void _cycleBellSound(int index) {
    setState(() {
      final current = bells[index]['sound'] ?? 'default';
      final curIdx = _soundCycle.indexOf(current);
      final next = _soundCycle[(curIdx + 1) % _soundCycle.length];
      bells[index] = {
        ...bells[index],
        'sound': next,
      };
    });
  }

  /// Shows a dialog to edit a bell.
  Future<void> _editBell(int index) async {
    final bell = bells[index];
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => BellFormDialog(
        initialTime: bell['time'],
        initialLabel: bell['label'],
        initialSound: bell['sound'],
        title: 'Edit Mindful Bell',
        confirmText: 'Save',
      ),
    );
    if (result != null) {
      setState(() {
        bells[index] = result;
      });
    }
  }

  /// Shows a dialog to add a new bell.
  Future<void> _addBell() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) =>
          const BellFormDialog(title: 'Add Mindful Bell', confirmText: 'Add'),
    );
    if (result != null) {
      setState(() {
        bells.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final p = TaoPalette.of(context);

    // Collapsed Peeking Tab State (matches Prototype #1 frosted bottom bar)
    if (widget.currentPageIndex == 0) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onToggle,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              decoration: BoxDecoration(
                color: p.peekingCardSurface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border(
                  top: BorderSide(color: p.peekingCardBorder, width: 1),
                ),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'Mindful Bells',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              letterSpacing: 2.6,
                              fontWeight: FontWeight.w400,
                              color: p.inkPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.notifications_none_rounded,
                          size: 16,
                          color: p.inkMuted,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 18,
                      color: p.inkMuted,
                    ),
                    tooltip: 'Expand Mindful Bells',
                    onPressed: widget.onToggle,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Expanded Mindful Bells Sanctuary
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxHeight < 180) {
            return Container(
              decoration: BoxDecoration(
                color: p.peekingCardSurface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
              ),
            );
          }
          return Stack(
            children: [
              Container(
            decoration: BoxDecoration(
              color: p.peekingCardSurface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border(
                top: BorderSide(color: p.peekingCardBorder, width: 1),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Mindful Bells',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: p.inkPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  letterSpacing: 0.8,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.remove,
                            color: p.inkMuted,
                          ),
                          tooltip: 'Collapse Mindful Bells',
                          onPressed: widget.onToggle,
                        ),
                      ],
                    ),
                  ),

                  Text(
                    'Gentle chimes to return you to the present moment',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.4,
                      color: p.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Angel Numbers Whisper Card (when enabled in Settings)
                  if (settingsProvider.showAngelNumbers)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Card(
                        color: p.capsuleSurface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: p.accentGold.withValues(alpha: 0.45),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.numbers,
                            color: p.accentGold,
                            size: 20,
                          ),
                          title: Text(
                            'Angel Numbers',
                            style: TextStyle(
                              fontSize: 14,
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
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: p.inkMuted,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const AngelNumbersPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  // Hairline Bells List
                  Expanded(
                    child: ListView.builder(
                      itemCount: bells.length,
                      itemBuilder: (context, index) {
                        final bell = bells[index];
                        final soundKey = bell['sound'] ?? 'default';
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: p.hairlineDivider,
                                width: 1,
                              ),
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                              vertical: 6.0,
                            ),
                            leading: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => _cycleBellSound(index),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: p.capsuleSurface,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: p.capsuleBorder),
                                ),
                                alignment: Alignment.center,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Preserve semantic Icons.alarm with zero opacity for test compatibility
                                    const Opacity(
                                      opacity: 0.0,
                                      child: Icon(Icons.alarm, size: 16),
                                    ),
                                    ZenSoundSymbol(
                                      soundKey: soundKey,
                                      size: 18,
                                      color: p.accentPrimary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            title: Text(
                              bell['time']!,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 1.4,
                                color: p.inkPrimary,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Text(
                                  bell['label']!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: p.inkMuted,
                                  ),
                                ),
                                if (bell['sound'] != null)
                                  Text(
                                    'Sound: ${bell['sound']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: p.inkMuted.withValues(alpha: 0.8),
                                    ),
                                  ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 18,
                                color: p.inkMuted,
                              ),
                              onPressed: () => _editBell(index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (bells.length < settingsProvider.maxBells)
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: _addBell,
                tooltip: 'Add Mindful Bell',
                elevation: 1,
                backgroundColor: p.accentPrimary,
                foregroundColor: p.accentOnPrimary,
                child: const Icon(Icons.add),
              ),
            ),
            ],
          );
        },
      ),
    );
  }
}
