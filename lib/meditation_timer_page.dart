import 'package:flutter/material.dart';
import 'dart:math';

class MeditationTimerPage extends StatefulWidget {
  final int currentPageIndex;

  const MeditationTimerPage({super.key, this.currentPageIndex = 0});

  @override
  State<MeditationTimerPage> createState() => _MeditationTimerPageState();
}

class _MeditationTimerPageState extends State<MeditationTimerPage> {
  int _selectedMinutes = 10;
  String _selectedSound = 'default';
  int _preparationSeconds = 10;

  final List<String> _inspirationalQuotes = [
    "The present moment is the only time over which we have dominion.",
    "Meditation is not about stopping thoughts, but recognizing that we are more than our thoughts.",
    "In the midst of movement and chaos, keep stillness inside of you.",
    "The mind is everything. What you think you become.",
    "Peace comes from within. Do not seek it without.",
    "Wherever you are, be there totally.",
    "The quieter you become, the more you are able to hear.",
    "Mindfulness is about being fully awake in our lives.",
    "Breathe in peace, breathe out stress.",
    "The best way to take care of the future is to take care of the present moment.",
  ];

  final List<Map<String, String>> _soundOptions = [
    {'label': 'Default', 'value': 'default'},
    {'label': 'Singing Bowl', 'value': 'singing_bowl'},
    {'label': 'Bell', 'value': 'bell'},
    {'label': 'Chime', 'value': 'chime'},
    {'label': 'Nature Sounds', 'value': 'nature'},
  ];

  String get _randomQuote {
    final random = Random();
    return _inspirationalQuotes[random.nextInt(_inspirationalQuotes.length)];
  }

  void _showTimePicker() async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) => _TimePickerDialog(initialMinutes: _selectedMinutes),
    );
    if (result != null) {
      setState(() {
        _selectedMinutes = result;
      });
    }
  }

  void _showSoundPicker() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _SoundPickerDialog(
        soundOptions: _soundOptions,
        selectedSound: _selectedSound,
      ),
    );
    if (result != null) {
      setState(() {
        _selectedSound = result;
      });
    }
  }

  void _showPreparationPicker() async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) =>
          _PreparationPickerDialog(initialSeconds: _preparationSeconds),
    );
    if (result != null) {
      setState(() {
        _preparationSeconds = result;
      });
    }
  }

  void _savePreset() {
    // TODO: Implement preset saving functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Preset saved successfully!')));
  }

  void _startMeditation() {
    // TODO: Implement meditation timer functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Starting ${_selectedMinutes}min meditation with ${_preparationSeconds}s preparation...',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show only heading when this page is not active (currentPageIndex is 1)
    if (widget.currentPageIndex == 1) {
      return Container(
        decoration: BoxDecoration(color: Colors.deepPurple[50]),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.self_improvement,
                size: 48,
                color: Colors.deepPurple[700],
              ),
              const SizedBox(height: 16),
              Text(
                'Meditation Timer',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Show full content when this page is active (currentPageIndex is 0)
    return Container(
      decoration: BoxDecoration(color: Colors.deepPurple[50]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Meditation Timer',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Random inspirational quote - reduced space
            Flexible(
              flex: 2,
              child: Container(
                width: double.infinity,
                child: Center(
                  child: Text(
                    _randomQuote,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.deepPurple[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            // Timer, Sound, and Preparation Controls - more space
            Flexible(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Timer Picker
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.timer,
                        color: Colors.deepPurple,
                      ),
                      title: const Text('Meditation Duration'),
                      subtitle: Text('$_selectedMinutes minutes'),
                      trailing: const Icon(Icons.arrow_drop_down),
                      onTap: _showTimePicker,
                    ),
                  ),

                  // Sound Picker
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.music_note,
                        color: Colors.deepPurple,
                      ),
                      title: const Text('Sound'),
                      subtitle: Text(
                        _soundOptions.firstWhere(
                          (s) => s['value'] == _selectedSound,
                        )['label']!,
                      ),
                      trailing: const Icon(Icons.arrow_drop_down),
                      onTap: _showSoundPicker,
                    ),
                  ),

                  // Preparation Time Picker
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.hourglass_empty,
                        color: Colors.deepPurple,
                      ),
                      title: const Text('Preparation Time'),
                      subtitle: Text('$_preparationSeconds seconds'),
                      trailing: const Icon(Icons.arrow_drop_down),
                      onTap: _showPreparationPicker,
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons - optimized size
            Flexible(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _savePreset,
                        icon: const Icon(Icons.save),
                        label: const Text('Save Preset'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.deepPurple,
                          minimumSize: const Size(0, 48),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _startMeditation,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Meditate'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 48),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ), // Column
      ), // Padding
    ); // Container
  } // build method
}

// Time Picker Dialog
class _TimePickerDialog extends StatefulWidget {
  final int initialMinutes;

  const _TimePickerDialog({required this.initialMinutes});

  @override
  State<_TimePickerDialog> createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<_TimePickerDialog> {
  late int _selectedMinutes;

  @override
  void initState() {
    super.initState();
    _selectedMinutes = widget.initialMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Duration'),
      content: SizedBox(
        height: 300,
        width: 200,
        child: ListWheelScrollView.useDelegate(
          itemExtent: 60,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (index) {
            _selectedMinutes = 5 + index;
          },
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              final minutes = 5 + index;
              if (minutes > 60) return null;
              return Center(
                child: Text(
                  '$minutes min',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: minutes == _selectedMinutes
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_selectedMinutes),
          child: const Text('Select'),
        ),
      ],
    );
  }
}

// Sound Picker Dialog
class _SoundPickerDialog extends StatelessWidget {
  final List<Map<String, String>> soundOptions;
  final String selectedSound;

  const _SoundPickerDialog({
    required this.soundOptions,
    required this.selectedSound,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Sound'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: soundOptions.map((sound) {
          final isSelected = sound['value'] == selectedSound;
          return ListTile(
            title: Text(sound['label']!),
            leading: Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? Colors.deepPurple : Colors.grey,
            ),
            onTap: () => Navigator.of(context).pop(sound['value']),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

// Preparation Time Picker Dialog
class _PreparationPickerDialog extends StatefulWidget {
  final int initialSeconds;

  const _PreparationPickerDialog({required this.initialSeconds});

  @override
  State<_PreparationPickerDialog> createState() =>
      _PreparationPickerDialogState();
}

class _PreparationPickerDialogState extends State<_PreparationPickerDialog> {
  late int _selectedSeconds;

  @override
  void initState() {
    super.initState();
    _selectedSeconds = widget.initialSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Preparation Time'),
      content: SizedBox(
        height: 300,
        width: 200,
        child: ListWheelScrollView.useDelegate(
          itemExtent: 60,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (index) {
            _selectedSeconds = 10 + (index * 10);
          },
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              final seconds = 10 + (index * 10);
              if (seconds > 60) return null;
              return Center(
                child: Text(
                  '$seconds sec',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: seconds == _selectedSeconds
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_selectedSeconds),
          child: const Text('Select'),
        ),
      ],
    );
  }
}
