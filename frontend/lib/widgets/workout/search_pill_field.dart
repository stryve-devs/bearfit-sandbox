import 'package:flutter/material.dart';
import '../../constants/workout_colors.dart';
import '../../constants/workout_typography.dart';
import '../../utils/figma_sizer.dart';
import '../../constants/workout_sizes.dart';
import '../../constants/workout_strings.dart';

class SearchPillField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const SearchPillField({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = FigmaSizer.of(context);
    final focus = FocusNode();

    void focusInput() {
      FocusScope.of(context).requestFocus(focus);
    }

    return Material(
      color: WorkoutColors.surface,
      borderRadius: WRadii.pill, // BorderRadius, not a function
      child: InkWell(
        borderRadius: WRadii.pill,
        onTap: focusInput, // clicking the whole pill focuses input
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: s.fw(16), vertical: s.fh(12)),
          child: Row(
            children: [
              InkWell(
                onTap: focusInput,
                customBorder: const CircleBorder(),
                child: Container(
                  width: s.fw(28),
                  height: s.fw(28),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // circle shape
                    border: Border.all(color: WorkoutColors.orange, width: 2),
                  ),
                  child: Icon(Icons.add, size: s.fs(18), color: WorkoutColors.orange),
                ),
              ),
              SizedBox(width: s.fw(12)),
              Expanded(
                child: TextField(
                  focusNode: focus,
                  controller: controller,
                  onChanged: onChanged,
                  style: WT.h2(context, color: WorkoutColors.orange), // use typography
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: WS.searchExercises,
                    hintStyle: WT.h2(context, color: WorkoutColors.orange),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}