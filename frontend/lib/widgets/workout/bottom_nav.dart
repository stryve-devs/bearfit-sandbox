import 'package:flutter/material.dart';
import '../../constants/workout_colors.dart';
import '../../constants/workout_sizes.dart';

/// Bottom nav with rounded background.
/// Color rule:
/// - Active tab icon + label: orange
/// - Inactive tabs: white
class WorkoutBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;

  const WorkoutBottomNav({super.key, required this.index, required this.onTap});

  Color _tabColor(int i) {
    return i == index ? WorkoutColors.orange : WorkoutColors.white;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        // Add padding so rounded corners are visible
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: Material(
          color: WorkoutColors.surface,          // slightly grey background
          borderRadius: WRadii.pill,             // rounded nav bar
          clipBehavior: Clip.antiAlias,          // clip children to rounded shape
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => onTap(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home, color: _tabColor(0), size: 24),
                        const SizedBox(height: 4),
                        Text('Home', style: TextStyle(color: _tabColor(0), fontFamily: 'Quicksand', fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => onTap(1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fitness_center, color: _tabColor(1), size: 24),
                        const SizedBox(height: 4),
                        Text('Workout', style: TextStyle(color: _tabColor(1), fontFamily: 'Quicksand', fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => onTap(2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, color: _tabColor(2), size: 24),
                        const SizedBox(height: 4),
                        Text('Profile', style: TextStyle(color: _tabColor(2), fontFamily: 'Quicksand', fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}