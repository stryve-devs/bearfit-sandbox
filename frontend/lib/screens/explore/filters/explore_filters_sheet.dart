import 'package:flutter/material.dart';

class ExploreFiltersSheet extends StatelessWidget {
  const ExploreFiltersSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Filters',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 24),

          _section('Level', ['Beginner', 'Medium', 'Advanced']),
          const SizedBox(height: 16),
          _section('Goal', ['Gain Muscle', 'Strength', 'Lose Weight']),
          const SizedBox(height: 16),
          _section('Equipment', ['Gym', 'Dumbbells', 'None']),

          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Clear Filters'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Show results'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: items
              .map(
                (e) => Chip(
                  backgroundColor: const Color(0xFF1C1C1E),
                  label: Text(
                    e,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

