import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'bell_form_dialog.dart';
import 'angel_numbers_page.dart';

void main() {
  runApp(const NOWApp());
}

class NOWApp extends StatelessWidget {
  const NOWApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NOW',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MindfulBellListScreen(),
      debugShowCheckedModeBanner: !kReleaseMode,
    );
  }
}

class MindfulBellListScreen extends StatefulWidget {
  const MindfulBellListScreen({super.key});

  @override
  State<MindfulBellListScreen> createState() => _MindfulBellListScreenState();
}

class _MindfulBellListScreenState extends State<MindfulBellListScreen> {
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
    return Scaffold(
      appBar: AppBar(title: const Text('Mindful Bells')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.amber[100],
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
          Expanded(
            child: ListView.builder(
              itemCount: bells.length,
              itemBuilder: (context, index) {
                final bell = bells[index];
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
              },
            ),
          ),
        ],
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
