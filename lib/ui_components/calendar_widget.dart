import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/timesheet_entry.dart';
import 'entry_detail_widget.dart';
import 'package:intl/intl.dart';

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

   void _openEntryDetail() {
    if (_selectedDay == null) { return; }
    
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EntryDetailWidget(
          selectedDate: _selectedDay!,
          onSave: (title, startTime, repeat, endRepeat, endDate, remind) {
            final newEntry = TimesheetEntry(
              date: DateTime(
                _selectedDay!.year,
                _selectedDay!.month,
                _selectedDay!.day,
                startTime.hour,
                startTime.minute,
              ),
              description: title,
            );
            _addEntry(newEntry);
          },
        ),
      ),
    );
  }

  @override
   Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Cute Timesheet'),
      ),
      child: Column(
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
                _focusedDay = focusedDay;
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
            eventLoader: (day) {
              return _entries.where((entry) => isSameDay(entry.date, day)).toList();
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: CupertinoColors.systemPink,
                      ),
                      width: 7.0,
                      height: 7.0,),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 8.0),
          CupertinoButton(
            onPressed: _openEntryDetail,
            color: CupertinoColors.activeBlue,
            child: const Text('Add Entry'),
          ),
          _buildEntriesList(),
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
            subtitle: Text(DateFormat.jm().format(entry.date)),
            onTap: () {
              // TODO: Implement editing entry functionality later
            },
          );
        },
      ),
    );
  }
}
