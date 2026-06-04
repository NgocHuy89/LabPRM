import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _sliderValue = 50;
  bool _switchValue = false;
  String _selectedGenre = 'None';
  DateTime? _selectedDate;

  Future<void> _openDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 2 – Input Controls Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slider
            const Text('Rating (Slider)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              onChanged: (v) => setState(() => _sliderValue = v),
            ),
            Text('Current value: ${_sliderValue.toInt()}'),
            const SizedBox(height: 16),

            // Switch
            const Text('Active (Switch)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text('Is movie active?'),
              value: _switchValue,
              onChanged: (v) => setState(() => _switchValue = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),

            // RadioListTile
            const Text('Genre (RadioListTile)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<String>(
              title: const Text('Action'),
              value: 'Action',
              groupValue: _selectedGenre,
              onChanged: (v) => setState(() => _selectedGenre = v!),
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<String>(
              title: const Text('Comedy'),
              value: 'Comedy',
              groupValue: _selectedGenre,
              onChanged: (v) => setState(() => _selectedGenre = v!),
              contentPadding: EdgeInsets.zero,
            ),
            Text('Selected genre: $_selectedGenre'),
            const SizedBox(height: 16),

            // DatePicker
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _openDatePicker(context),
                child: const Text('Open Date Picker'),
              ),
            ),
            if (_selectedDate != null)
              Text(
                'Selected: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              ),
          ],
        ),
      ),
    );
  }
}