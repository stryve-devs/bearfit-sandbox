import 'package:flutter/material.dart';
import '../../constants/workout_colors.dart';
import '../../constants/workout_typography.dart';
import '../../constants/workout_sizes.dart';
import '../../widgets/workout/custom_header.dart';
import '../../widgets/workout/pill_button.dart';
import '../../data/repositories/routine_repository.dart';

class ExploreRoutinesScreen extends StatelessWidget {
  const ExploreRoutinesScreen({super.key});

  double _contentWidth(BuildContext context) => MediaQuery.of(context).size.width - 24;

  @override
  Widget build(BuildContext context) {
    final cw = _contentWidth(context);
    final saved = RoutineRepository.all();

    return Scaffold(
      backgroundColor: WorkoutColors.black,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              left: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new, color: WorkoutColors.orange, size: 18),
              ),
              center: Text('Routines', style: WT.h2(context)),
              right: const SizedBox.shrink(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text('Saved Routines', style: WT.h1(context)),
                      const SizedBox(height: 12),

                      if (saved.isEmpty) ...[
                        Container(
                          width: cw,
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(color: WorkoutColors.surface, borderRadius: WRadii.pill),
                          child: Column(
                            children: [
                              Text('No routines saved yet', style: WT.title(context)),
                              const SizedBox(height: 8),
                              Text('Create a routine to see it here', style: WT.small(context)),
                              const SizedBox(height: 12),
                              PillButton(
                                label: 'Create Routine',
                                onTap: () => Navigator.pushNamed(context, '/workout/routine'),
                                bg: WorkoutColors.black,
                                fg: WorkoutColors.orange,
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        for (final r in saved)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: const BoxDecoration(color: WorkoutColors.surface, borderRadius: WRadii.pill),
                            child: ListTile(
                              leading: const Icon(Icons.list_alt, color: WorkoutColors.white),
                              title: Text(r.title, style: WT.title(context)),
                              subtitle: Text('${r.targets.length} exercises', style: WT.small(context)),
                              trailing: const Icon(Icons.chevron_right, color: WorkoutColors.white),
                              onTap: () => Navigator.pushNamed(context, '/workout/log', arguments: r),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}