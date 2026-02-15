import 'package:flutter/material.dart';

class PreviousWorkoutValuesPage extends StatefulWidget {
  const PreviousWorkoutValuesPage({super.key});

  @override
  State<PreviousWorkoutValuesPage> createState() =>
      _PreviousWorkoutValuesPageState();
}

class _PreviousWorkoutValuesPageState
    extends State<PreviousWorkoutValuesPage> {
  bool anyWorkout = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Color(0xFFFF7825)),
        title: const Text('Previous Workout Values',
            style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          RadioListTile(
            activeColor: Colors.orange,
            title: const Text('Any workout',
                style: TextStyle(color: Colors.orange)),
            subtitle: Text(
              'Fetch values from last time you did the exercise',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            ),
            value: true,
            // ignore: deprecated_member_use
            groupValue: anyWorkout,
            // ignore: deprecated_member_use
            onChanged: (_) => setState(() => anyWorkout = true),
          ),
          RadioListTile(
            activeColor: Colors.orange,
            title: const Text('Same Routine',
                style: TextStyle(color: Colors.orange)),
            subtitle: Text(
              'Fetch values only from current routine',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            ),
            value: false,
            // ignore: deprecated_member_use
            groupValue: anyWorkout,
            // ignore: deprecated_member_use
            onChanged: (_) => setState(() => anyWorkout = false),
          ),
        ],
      ),
    );
  }
}
