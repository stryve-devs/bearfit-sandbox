import 'package:flutter/material.dart';
import 'sounds_page.dart';
import 'first_day_of_week_page.dart';
import 'previous_workout_values_page.dart';
import 'warmup_sets_page.dart';

class WorkoutSettingsPage extends StatefulWidget {
  const WorkoutSettingsPage({super.key});

  @override
  State<WorkoutSettingsPage> createState() => _WorkoutSettingsPageState();
}

class _WorkoutSettingsPageState extends State<WorkoutSettingsPage> {
  bool keepAwake = false;
  bool plateCalculator = false;
  bool rpeTracking = false;
  bool smartScroll = false;
  bool inlineTimer = false;
  bool livePR = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Color(0xFFFF7825)),
        title: const Text('Workout Settings',
            style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _navTile('Sounds', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SoundsPage()),
            );
          }),
          _navTile('Default Rest Timer', () {
            _showRestTimerPicker();
          }),
          _navTile('First day of the week', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FirstDayOfWeekPage()),
            );
          }),
          _navTile('Previous Workout Values', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const PreviousWorkoutValuesPage()),
            );
          }),
          _navTile('Warm up Sets', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WarmupSetsPage()),
            );
          }),

          const SizedBox(height: 20),

          _switchTile(
            'Keep Awake During Workout',
            'Enable this if you don\'t want your phone to sleep',
            keepAwake,
            (v) => setState(() => keepAwake = v),
          ),
          _switchTile(
            'Plate Calculator',
            'Calculate plates for barbell exercises',
            plateCalculator,
            (v) => setState(() => plateCalculator = v),
          ),
          _switchTile(
            'RPE Tracking',
            'Log perceived exertion for each set',
            rpeTracking,
            (v) => setState(() => rpeTracking = v),
          ),
          _switchTile(
            'Smart Superset Scrolling',
            'Auto scroll to next exercise',
            smartScroll,
            (v) => setState(() => smartScroll = v),
          ),
          _switchTile(
            'Inline Timer',
            'Built-in stopwatch for duration exercises',
            inlineTimer,
            (v) => setState(() => inlineTimer = v),
          ),
          _switchTile(
            'Live Personal Record Notification',
            'Notify when you hit a PR',
            livePR,
            (v) => setState(() => livePR = v),
          ),
        ],
      ),
    );
  }

  Widget _navTile(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.orange)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white),
      onTap: onTap,
    );
  }

  Widget _switchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: Colors.orange,
      title: Text(title, style: const TextStyle(color: Colors.orange)),
      subtitle: Text(subtitle,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
    );
  }

  void _showRestTimerPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2E2E2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const SizedBox(
        height: 250,
        child: Column(
          children: [
            SizedBox(height: 12),
            Text('Select Rest Time',
                style: TextStyle(color: Colors.orange, fontSize: 16)),
            SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Text('15s – 5 min Picker (placeholder)',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
