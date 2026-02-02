import 'package:flutter/material.dart';
import 'filters/explore_filters_sheet.dart';
import 'widgets/program_card.dart';
import 'widgets/routine_chip.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Explore'),
        leading: const BackButton(),
        actions: [
          TextButton.icon(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.black,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (_) => const ExploreFiltersSheet(),
              );
            },
            icon: const Icon(Icons.tune, color: Colors.orange),
            label: const Text(
              'Filters',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Programs',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ...List.generate(
            showAll ? 12 : 5,
            (_) => const ProgramCard(
              title: 'Bench Press (Barbell)',
              subtitle: 'Chest',
            ),
          ),

          Center(
            child: TextButton(
              onPressed: () {
                setState(() => showAll = !showAll);
              },
              child: Text(
                showAll ? 'Show less programs' : 'Show all programs',
                style: const TextStyle(color: Colors.orange),
              ),
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'Routines',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              RoutineChip(title: 'Home'),
              RoutineChip(title: 'Travel'),
              RoutineChip(title: 'Dumbbells only'),
              RoutineChip(title: 'Band'),
              RoutineChip(title: 'Cardio & HIIT'),
              RoutineChip(title: 'Gym'),
              RoutineChip(title: 'Bodyweight'),
              RoutineChip(title: 'Suspension Band'),
            ],
          ),
        ],
      ),
    );
  }
}
