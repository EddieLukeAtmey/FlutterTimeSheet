import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/timesheet_entry.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});
  @override
  CalendarWidgetState createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<TimesheetEntry> _entries = [];
  void _addEntry(TimesheetEntry entry) {
    setState(() {
      _entries.add(entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [ 
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update `_focusedDay` here as well
            });
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 8.0), _selectedDay != null ? _buildEntryForm() : Container(), _buildEntriesList(),
      ],
    );
  }

  Widget _buildEntryForm() {
    final TextEditingController _controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Entry Description',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                _addEntry(TimesheetEntry(
                  date: _selectedDay!,
                  description: _controller.text,
                ));
                _controller.clear();
              }
            },
            child: const Text('Add Entry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesList() {
    final entriesForSelectedDay = _entries.where((entry) => isSameDay(entry.date, _selectedDay)).toList();

    return Expanded(
      child: ListView.builder(
        itemCount: entriesForSelectedDay.length,
        itemBuilder: (context, index) {
          final entry = entriesForSelectedDay[index];
          return ListTile(
            title: Text(entry.description),
            subtitle: Text(entry.date.toIso8601String()),
          );
        },
      ),
    );
  }
}
