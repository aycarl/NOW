import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:now/features/angel_numbers/angel_numbers_page.dart';
import 'package:now/features/mindful_bells/widgets/bell_form_dialog.dart';
import 'package:now/features/settings/providers/settings_provider.dart';

/// A page that allows users to manage their mindful bells.
class MindfulBellsPage extends StatefulWidget {
  /// The index of the current page in the carousel.
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
  List<Map<String, String>> bells = [
    {'time': '07:00 AM', 'label': 'Morning Bell', 'sound': 'default'},
    {'time': '08:30 AM', 'label': 'Work Bell', 'sound': 'default'},
  ];

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

    return Stack(
      children: [
        Container(
          color: Colors.deepPurple[50],
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mindful Bells',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      IconButton(
                        icon: Icon(
                          widget.currentPageIndex == 1
                              ? Icons.remove
                              : Icons.add,
                          color: Colors.deepPurple,
                        ),
                        onPressed: widget.onToggle,
                      ),
                    ],
                  ),
                ),

                // Angel Numbers Card
                if (settingsProvider.showAngelNumbers)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Card(
                      color: Colors.deepPurple[100],
                      child: ListTile(
                        leading: const Icon(Icons.numbers,
                            color: Colors.deepPurple),
                        title: const Text('Angel Numbers'),
                        trailing: const Icon(Icons.arrow_forward_ios),
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

                // Bells List
                Expanded(
                  child: Column(
                    children: bells.asMap().entries.map((entry) {
                      final index = entry.key;
                      final bell = entry.value;
                      return ListTile(
                        leading: const Icon(Icons.alarm),
                        title: Text(bell['time']!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(bell['label']!),
                            if (bell['sound'] != null)
                              Text(
                                'Sound: ${bell['sound']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editBell(index),
                        ),
                      );
                    }).toList(),
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
              child: const Icon(Icons.add),
            ),
          ),
      ],
    );
  }
}
