import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calendar & Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          headlineMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String selectedCountry = 'US';
  late Timer timer;
  String timeString = '';

  final Map<String, String> countries = {
    'US': 'Amerika Serikat',
    'GB': 'Inggris',
    'IN': 'India',
    'JP': 'Jepang',
    'ID': 'Indonesia',
  };

  @override
  void initState() {
    super.initState();
    timeString = _formatDateTime(DateTime.now());
    timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    setState(() {
      timeString = _formatDateTime(DateTime.now());
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime.toUtc().add(Duration(
        hours: _getOffsetHours())));
  }

  int _getOffsetHours() {
    switch (selectedCountry) {
      case 'US': return -4;
      case 'GB': return 0;
      case 'IN': return 5;
      case 'JP': return 9;
      case 'ID': return 7;
      default: return 0;
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        flexibleSpace: Center(
          child: Text(
            'Flutter Calendar & Clock',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white, // Atur warna teks jika perlu
              fontWeight: FontWeight.bold, // Atur ketebalan teks jika perlu
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() => _calendarFormat = format);
              }
            },
            onPageChanged: (focusedDay) => _focusedDay = focusedDay,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(color: Colors.black),
              defaultTextStyle: TextStyle(color: Colors.black),
            ),
            headerStyle: HeaderStyle(
              titleTextStyle: const TextStyle(color: Colors.black),
              formatButtonTextStyle: const TextStyle(color: Colors.black),
              formatButtonDecoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20.0),
              ),
              leftChevronIcon: const Icon(
                Icons.chevron_left,
                color: Colors.black,
              ),
              rightChevronIcon: const Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.black),
              weekdayStyle: TextStyle(color: Colors.black),
            ),
          ),
          DropdownButton<String>(
            value: selectedCountry,
            onChanged: (newValue) {
              setState(() {
                selectedCountry = newValue!;
                _updateTime();
              });
            },
            items: countries.keys.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(countries[value]!, style: const TextStyle(color: Colors.black)),
              );
            }).toList(),
            dropdownColor: Colors.white,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              timeString,
              style: const TextStyle(fontSize: 48, color: Colors.black),
            ),
          ),
          if (_selectedDay != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Selected day: ${_selectedDay?.toLocal()}'.split(' ')[0],
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}
