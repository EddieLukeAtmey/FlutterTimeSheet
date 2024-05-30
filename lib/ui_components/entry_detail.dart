import 'package:flutter/cupertino.dart';
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
    final TimeOfDay? picked = await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              _startTime.hour,
              _startTime.minute,
            ),
            onDateTimeChanged: (DateTime newTime) {
              setState(() {
                _startTime = TimeOfDay.fromDateTime(newTime);
              });
            },
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _endDate = newDate;
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Add Entry'),
        trailing: GestureDetector(
          child: const Icon(CupertinoIcons.check_mark),
          onTap: () {
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
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CupertinoTextField(
              controller: _titleController,
              placeholder: 'Title',
            ),
            CupertinoButton(
              onPressed: () => _selectTime(context),
              child: Text('Start Time: ${_startTime.format(context)}'),
            ),
            CupertinoButton(
              onPressed: () async {
                final selected = await showCupertinoModalPopup<String>(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    title: const Text('Repeat'),
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () => Navigator.pop(context, 'Never'),
                        child: const Text('Never'),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () => Navigator.pop(context, 'Every day'),
                        child: const Text('Every day'),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () => Navigator.pop(context, 'Every month'),
                        child: const Text('Every month'),
                      ),
                      CupertinoActionSheetAction(
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
              child: Text('Repeat: $_repeat'),
            ),
            CupertinoButton(
              onPressed: () async {
                final selected = await showCupertinoModalPopup<String>(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    title: const Text('End Repeat'),
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () => Navigator.pop(context, 'Never'),
                        child: const Text('Never'),
                      ),
                      CupertinoActionSheetAction(
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
              child: Text('End Repeat: $_endRepeat'),
            ),
            if (_endRepeat == 'On date')
              CupertinoButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  'End Date: ${_endDate != null ? DateFormat.yMd().format(_endDate!) : 'Select date'}',
                ),
              ),
            CupertinoButton(
              onPressed: () async {
                final selected = await showCupertinoModalPopup<String>(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    title: const Text('Remind'),
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () => Navigator.pop(context, 'None'),
                        child: const Text('None'),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () => Navigator.pop(context, 'After 5 mins'),
                        child: const Text('After 5 mins'),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () => Navigator.pop(context, 'After 10 mins'),
                        child: const Text('After 10 mins'),
                      ),
                      CupertinoActionSheetAction(
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
              child: Text('Remind: $_remind'),
            ),
          ],
        ),
      ),
    );
  }
}
