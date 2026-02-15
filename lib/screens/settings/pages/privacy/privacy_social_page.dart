import 'package:flutter/material.dart';
import 'default_workout_visibility_page.dart';

class PrivacySocialPage extends StatefulWidget {
  const PrivacySocialPage({super.key});

  @override
  State<PrivacySocialPage> createState() => _PrivacySocialPageState();
}

class _PrivacySocialPageState extends State<PrivacySocialPage> {
  bool privateProfile = false;
  bool hideSuggestedUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Color(0xFFFF7825)),
        title: const Text(
          'Privacy & Social',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _switchTile(
            title: 'Private Profile',
            description:
                'Having a private profile means other users need to request to follow you. Only if you accept their follow request will they be able to see your workouts.',
            value: privateProfile,
            onChanged: (v) => setState(() => privateProfile = v),
          ),
          const SizedBox(height: 16),
          _switchTile(
            title: 'Hide Suggested Users',
            description:
                'Enabling this will remove the suggested user section from your feed.',
            value: hideSuggestedUsers,
            onChanged: (v) => setState(() => hideSuggestedUsers = v),
          ),
          const SizedBox(height: 16),
          _navigationTile(
            title: 'Default Workout Visibility',
            description:
                'Set the default visibility for new workouts. You can change it to specific workouts when saving them.',
            trailingText: 'Everyone',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DefaultWorkoutVisibilityPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _switchTile({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFFF7A00),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: const Color(0xFFFF7A00),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _navigationTile({
    required String title,
    required String description,
    required String trailingText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF2E2E2E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFFF7A00),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  trailingText,
                  style: const TextStyle(color: Color(0xFFFF7A00)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
