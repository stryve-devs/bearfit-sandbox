import 'package:flutter/material.dart';
import '../../../constants/workout_colors.dart';
import '../../../constants/workout_typography.dart';
import '../../../constants/workout_sizes.dart';

class RestPickerSheet extends StatelessWidget {
  final int initial; // in seconds

  const RestPickerSheet({super.key, required this.initial});

  List<int> _options() {
    final seconds5to55 = List<int>.generate(11, (i) => (i + 1) * 5);

    List<int> minuteQuarters(int startMin, int endMin) {
      const quarterOffsets = [0, 15, 30, 45];
      final count = (endMin - startMin + 1) * quarterOffsets.length;
      return List<int>.generate(count, (i) {
        final m = startMin + (i ~/ quarterOffsets.length);
        final q = quarterOffsets[i % quarterOffsets.length];
        return m * 60 + q;
      });
    }

    return [
      ...seconds5to55,
      ...minuteQuarters(1, 4), 
      5 * 60,                  
    ];
  }

  String _label(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final m = seconds ~/ 60;
    final s = seconds % 60;
    if (s == 0) return '${m}m';
    return '${m}m ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final opts = _options();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: const BoxDecoration(
          color: WorkoutColors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Thin pill (drag handle) at the top
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: const BoxDecoration(
                  color: WorkoutColors.surface,
                  borderRadius: WRadii.pill,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Title
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('Pick rest time', style: WT.title(context, color: WorkoutColors.white)),
            ),

            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: opts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final seconds = opts[i];
                  final isSelected = seconds == initial;
                  return Material(
                    color: WorkoutColors.surface,
                    borderRadius: WRadii.pill,
                    child: InkWell(
                      borderRadius: WRadii.pill,
                      onTap: () => Navigator.pop(context, seconds),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _label(seconds),
                                style: WT.h2(context, color: WorkoutColors.white),
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check, color: WorkoutColors.orange, size: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}