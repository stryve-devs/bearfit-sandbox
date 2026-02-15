import 'package:flutter/material.dart';
import 'filter_tile.dart';

class ExploreFiltersSheet extends StatefulWidget {
  const ExploreFiltersSheet({super.key});

  @override
  State<ExploreFiltersSheet> createState() => _ExploreFiltersSheetState();
}

class _ExploreFiltersSheetState extends State<ExploreFiltersSheet> {
  String level = '';
  String goal = '';
  String equipment = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const Center(
            child: Text(
              'Filters',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 24),

          sectionTitle('Level'),
          grid([
            FilterTile(
              label: 'Beginner',
              icon: 'assets/icons/level_beginner.png',
              selected: level == 'beginner',
              onTap: () => setState(() => level = 'beginner'),
            ),
            FilterTile(
              label: 'Medium',
              icon: 'assets/icons/level_medium.png',
              selected: level == 'medium',
              onTap: () => setState(() => level = 'medium'),
            ),
            FilterTile(
              label: 'Advanced',
              icon: 'assets/icons/level_advanced.png',
              selected: level == 'advanced',
              onTap: () => setState(() => level = 'advanced'),
            ),
          ]),

          sectionTitle('Goal'),
          grid([
            FilterTile(
              label: 'Gain Muscle',
              icon: 'assets/icons/goal_muscle.png',
              selected: goal == 'muscle',
              onTap: () => setState(() => goal = 'muscle'),
            ),
            FilterTile(
              label: 'Strength',
              icon: 'assets/icons/goal_strength.png',
              selected: goal == 'strength',
              onTap: () => setState(() => goal = 'strength'),
            ),
            FilterTile(
              label: 'Lose Weight',
              icon: 'assets/icons/goal_weight.png',
              selected: goal == 'weight',
              onTap: () => setState(() => goal = 'weight'),
            ),
          ]),

          sectionTitle('Equipment'),
          grid([
            FilterTile(
              label: 'Gym',
              icon: 'assets/icons/equip_gym.png',
              selected: equipment == 'gym',
              onTap: () => setState(() => equipment = 'gym'),
            ),
            FilterTile(
              label: 'Dumbbells',
              icon: 'assets/icons/equip_dumbbells.png',
              selected: equipment == 'dumbbells',
              onTap: () => setState(() => equipment = 'dumbbells'),
            ),
            FilterTile(
              label: 'None',
              icon: 'assets/icons/equip_none.png',
              selected: equipment == 'none',
              onTap: () => setState(() => equipment = 'none'),
            ),
          ]),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      level = '';
                      goal = '';
                      equipment = '';
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.orange),
                    foregroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Clear Filters'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Show results'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget grid(List<Widget> children) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}
