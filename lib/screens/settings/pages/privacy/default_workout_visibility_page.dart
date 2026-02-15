import 'package:flutter/material.dart';

class DefaultWorkoutVisibilityPage extends StatefulWidget {
  const DefaultWorkoutVisibilityPage({super.key});

  @override
  State<DefaultWorkoutVisibilityPage> createState() =>
      _DefaultWorkoutVisibilityPageState();
}

class _DefaultWorkoutVisibilityPageState
    extends State<DefaultWorkoutVisibilityPage> {
  bool isPrivate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Color(0xFFFF7825)),
        title: const Text(
          'Default Workout Visibility',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set the default visibility of new workouts. You can change it for a specific workout when saving them. It does not affect existing workouts retroactively.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            _optionTile(
              title: 'Everyone',
              description:
                  'Workouts will be visible to all users on Bearfit.',
              selected: !isPrivate,
              onTap: () => setState(() => isPrivate = false),
            ),
            const SizedBox(height: 12),
            _optionTile(
              title: 'Private',
              description: 'Workouts will be only visible to you.',
              selected: isPrivate,
              onTap: () => setState(() => isPrivate = true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionTile({
    required String title,
    required String description,
    required bool selected,
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
        child: Row(
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
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check, color: Color(0xFFFF7A00)),
          ],
        ),
      ),
    );
  }
}
