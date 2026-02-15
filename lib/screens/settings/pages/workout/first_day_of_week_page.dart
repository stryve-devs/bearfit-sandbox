import 'package:flutter/material.dart';

class FirstDayOfWeekPage extends StatefulWidget {
  const FirstDayOfWeekPage({super.key});

  @override
  State<FirstDayOfWeekPage> createState() => _FirstDayOfWeekPageState();
}

class _FirstDayOfWeekPageState extends State<FirstDayOfWeekPage> {
  String selected = 'Monday';

  final days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Color(0xFFFF7825)),
        title: const Text('First Weekday',
            style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: days.map((day) {
          return ListTile(
            title: Text(day, style: const TextStyle(color: Colors.orange)),
            trailing: selected == day
                ? const Icon(Icons.check, color: Colors.orange)
                : null,
            onTap: () {
              setState(() => selected = day);
            },
          );
        }).toList(),
      ),
    );
  }
}
