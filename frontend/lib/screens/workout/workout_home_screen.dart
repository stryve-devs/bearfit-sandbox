import 'package:flutter/material.dart';
import '../../constants/workout_colors.dart';
import '../../constants/workout_typography.dart';
import '../../constants/workout_sizes.dart';
import '../../widgets/workout/custom_header.dart';
import '../../widgets/workout/bottom_nav.dart';
import '../../constants/workout_strings.dart';

class WorkoutHomeScreen extends StatefulWidget {
  const WorkoutHomeScreen({super.key});
  @override
  State<WorkoutHomeScreen> createState() => _WorkoutHomeScreenState();
}

class _WorkoutHomeScreenState extends State<WorkoutHomeScreen> {
  int navIndex = 1; // Workout active

  bool get _isPhone => MediaQuery.of(context).size.width < 380;

  void _onNavTap(int i) {
    setState(() => navIndex = i);
    if (i == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (i == 1) {
      // Stay on Workout
    } else if (i == 2) {
      Navigator.pushNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Match Add Exercise button text style (16, bold)
    const cardLabelStyle = TextStyle(
      fontFamily: 'Quicksand',
      fontWeight: FontWeight.w700,
      fontSize: 16,
      color: WorkoutColors.white,
    );

    // Slightly smaller icon and tighter spacing to avoid bottom overflow
    final newRoutineIconSize = _isPhone ? 18.0 : 20.0;
    final exploreIconSize = _isPhone ? 18.0 : 20.0;
    final cardHPadding = _isPhone ? 16.0 : 20.0; // reduce horizontal padding
    final cardVPadding = _isPhone ? 10.0 : 10.0; // reduce vertical padding
    final gap = 4.0;

    return Scaffold(
      backgroundColor: WorkoutColors.black,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              left: const SizedBox.shrink(),
              center: Text(WS.workout, style: WT.h2(context)),
              right: const SizedBox.shrink(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // Quick Start
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(WS.quickStart, style: WT.h1(context)),
                          const SizedBox(height: 22),
                          // Add Exercise with Plus icon (stretches full width)
                          Material(
                            color: WorkoutColors.surface,
                            borderRadius: WRadii.pill,
                            child: InkWell(
                              borderRadius: WRadii.pill,
                              onTap: () => Navigator.pushNamed(context, '/workout/log'),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, color: WorkoutColors.white, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      WS.addExercise,
                                      style: TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: WorkoutColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Routines cards (New + Explore)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(WS.routines, style: WT.h1(context)),
                          const SizedBox(height: 22),

                          // Ensure both cards are always the same height (equal to tallest)
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // New Routine card (text and icon stacked vertically)
                                Expanded(
                                  child: Material(
                                    color: WorkoutColors.surface,
                                    borderRadius: WRadii.pill,
                                    child: InkWell(
                                      borderRadius: WRadii.pill,
                                      onTap: () => Navigator.pushNamed(context, '/workout/routine'),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: cardHPadding, vertical: cardVPadding),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('New Routine', style: cardLabelStyle, textAlign: TextAlign.center),
                                            SizedBox(height: gap),
                                            Icon(Icons.auto_awesome, color: WorkoutColors.white, size: newRoutineIconSize),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Explore Routines card (text and icon stacked vertically)
                                Expanded(
                                  child: Material(
                                    color: WorkoutColors.surface,
                                    borderRadius: WRadii.pill,
                                    child: InkWell(
                                      borderRadius: WRadii.pill,
                                      onTap: () => Navigator.pushNamed(context, '/workout/explore'),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: cardHPadding, vertical: cardVPadding),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Explore Routines', style: cardLabelStyle, textAlign: TextAlign.center),
                                            SizedBox(height: gap),
                                            Icon(Icons.explore, color: WorkoutColors.white, size: exploreIconSize),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            WorkoutBottomNav(index: navIndex, onTap: _onNavTap),
          ],
        ),
      ),
    );
  }
}