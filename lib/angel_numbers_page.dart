import 'package:flutter/material.dart';

class AngelNumbersPage extends StatefulWidget {
  const AngelNumbersPage({super.key});

  @override
  State<AngelNumbersPage> createState() => _AngelNumbersPageState();
}

class _AngelNumbersPageState extends State<AngelNumbersPage> {
  // Example angel numbers for a 12-hour clock
  final List<String> angelNumbers = [
    '1:11', '2:22', '3:33', '4:44', '5:55', '11:11',
  ];
  final Set<String> enabledNumbers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Angel Numbers')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Toggle mindful bells for angel numbers on a 12-hour clock',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: angelNumbers.length,
              itemBuilder: (context, index) {
                final number = angelNumbers[index];
                return SwitchListTile(
                  title: Text(number),
                  value: enabledNumbers.contains(number),
                  onChanged: (val) {
                    setState(() {
                      if (val) {
                        enabledNumbers.add(number);
                      } else {
                        enabledNumbers.remove(number);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

