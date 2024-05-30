import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntryDetail extends StatefulWidget {
  final DateTime selectedDate;
  final Function onSave;

  const EntryDetail({required this.selectedDate, required this.onSave, super.key});

  @override
  EntryDetailState createState() => EntryDetailState();
}

class EntryDetailState extends State<EntryDetail> {
  final _titleController = TextEditingController();
  TimeOfDay _startTime = TimeOfDay.now();
  String _repeat = 'Never';
  String _endRepeat = 'Never';
  DateTime? _endDate;
  String _remind = 'None';

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              widget.onSave(
                _titleController.text,
                _startTime,
                _repeat,
                _endRepeat,
                _endDate,
                _remind,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            ListTile(
              title: Text('Start Time: ${_startTime.format(context)}'),
              trailing: const Icon(Icons.keyboard_arrow_down),
              onTap: () => _selectTime(context),
            ),
            ListTile(
              title: Text('Repeat: $_repeat'),
              trailing: const Icon(Icons.keyboard_arrow_down),
              onTap: () async {
                final selected = await showDialog<String>(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Text('Repeat'),
                    children: [
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, 'Never'),
                        child: const Text('Never'),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, 'Every day'),
                        child: const Text('Every day'),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, 'Every month'),
                        child: const Text('Every month'),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, 'Custom'),
                        child: const Text('Custom'),
                      ),
                    ],
                  ),
                );
                if (selected != null && selected != _repeat) {
                  setState(() {
                    _repeat = selected;
                  });
                }
              },
            ),
            ListTile(
              title: Text('End Repeat: $_endRepeat'),
              trailing: const Icon(Icons.keyboard_arrow_down),
              onTap: () async {
                final selected = await showDialog<String>(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Text('End Repeat'),
                    children: [
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, 'Never'),
                        child: const Text('Never'),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, 'On date'),
                        child: const Text('On date'),
                      ),
                    ],
                  ),
                );
                if (selected != null && selected != _endRepeat) {
                  setState(() {
                    _endRepeat = selected;
                  });
                }
              },
            ),
            if (_endRepeat == 'On date')
              ListTile(
                title: Text(
                  'End Date: ${_endDate != null ? DateFormat.yMd().format(_endDate!) : 'Select date'}',
                ),
                trailing: const Icon(Icons.keyboard_arrow_down),
                onTap: () => _selectDate(context),
              ),
            ListTile(
              title: Text('Remind: $_remind'),
              trailing: const Icon(Icons.keyboard_arrow_down),
              onTap: () async {
                final selected = await showDialog<String>(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Text('Remind'),
                    children: [
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, 'None'),
                        child: const Text('None'),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, 'After 5 mins'),
                        child: const Text('After 5 mins'),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, 'After 10 mins'),
                        child: const Text('After 10 mins'),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, 'Custom'),
                        child: const Text('Custom'),
                      ),
                    ],
                  ),
                );
                if (selected != null && selected != _remind) {
                  setState(() {
                    _remind = selected;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
