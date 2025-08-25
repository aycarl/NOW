import 'package:flutter/material.dart';
import 'bell_form_dialog.dart';
import 'angel_numbers_page.dart';

class MindfulBellsPage extends StatefulWidget {
  final int currentPageIndex;

  const MindfulBellsPage({super.key, this.currentPageIndex = 1});

  @override
  State<MindfulBellsPage> createState() => _MindfulBellsPageState();
}

class _MindfulBellsPageState extends State<MindfulBellsPage> {
  List<Map<String, String>> bells = [
    {'time': '07:00 AM', 'label': 'Morning Bell', 'sound': 'default'},
    {'time': '08:30 AM', 'label': 'Work Bell', 'sound': 'default'},
  ];

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
    if (widget.currentPageIndex == 0) {
      return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
        child: Text(
          'Mindful Bells',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Mindful Bells',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Angel Numbers Card
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Card(
                color: Colors.deepPurple[100],
                child: ListTile(
                  leading: const Icon(Icons.numbers, color: Colors.deepPurple),
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
      floatingActionButton: bells.length < 5
          ? FloatingActionButton(
              onPressed: _addBell,
              tooltip: 'Add Mindful Bell',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
