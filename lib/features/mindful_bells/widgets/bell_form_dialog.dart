import 'package:flutter/material.dart';

class BellFormDialog extends StatefulWidget {
  final String? initialTime;
  final String? initialLabel;
  final String? initialSound;
  final String title;
  final String confirmText;

  const BellFormDialog({
    super.key,
    this.initialTime,
    this.initialLabel,
    this.initialSound,
    required this.title,
    required this.confirmText,
  });

  @override
  State<BellFormDialog> createState() => _BellFormDialogState();
}

class _BellFormDialogState extends State<BellFormDialog> {
  late TextEditingController _labelController;
  TimeOfDay? _selectedTime;
  String? _selectedSound;
  final List<Map<String, String>> _systemSounds = [
    {'label': 'Default', 'value': 'default'},
    {'label': 'Alarm', 'value': 'alarm'},
    {'label': 'Notification', 'value': 'notification'},
    {'label': 'Ringtone', 'value': 'ringtone'},
  ];

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.initialLabel);
    if (widget.initialTime != null) {
      final timeParts = widget.initialTime!.split(' ');
      final hourMinute = timeParts[0].split(':');
      int hour = int.parse(hourMinute[0]);
      int minute = int.parse(hourMinute[1]);
      if (timeParts[1] == 'PM' && hour != 12) hour += 12;
      if (timeParts[1] == 'AM' && hour == 12) hour = 0;
      _selectedTime = TimeOfDay(hour: hour, minute: minute);
    }
    _selectedSound = widget.initialSound ?? _systemSounds.first['value'];
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedTime != null
                      ? 'Time: ${_selectedTime!.format(context)}'
                      : 'No time selected',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: _pickTime,
              ),
            ],
          ),
          TextField(
            controller: _labelController,
            decoration: const InputDecoration(labelText: 'Label'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedSound,
            decoration: const InputDecoration(labelText: 'System Sound'),
            items: _systemSounds
                .map(
                  (sound) => DropdownMenuItem<String>(
                    value: sound['value'],
                    child: Text(sound['label']!),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedSound = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedTime == null
              ? null
              : () {
                  if (_selectedTime == null) return;
                  final hour =
                      _selectedTime!.hourOfPeriod == 0 &&
                          _selectedTime!.period == DayPeriod.pm
                      ? 12
                      : _selectedTime!.hourOfPeriod;
                  final timeString =
                      '${hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')} ${_selectedTime!.period == DayPeriod.am ? 'AM' : 'PM'}';
                  Navigator.of(context).pop({
                    'time': timeString,
                    'label': _labelController.text,
                    'sound': _selectedSound ?? _systemSounds.first['value']!,
                  });
                },
          child: Text(widget.confirmText),
        ),
      ],
    );
  }
}
