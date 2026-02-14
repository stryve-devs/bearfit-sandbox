import 'dart:async';
import 'package:flutter/material.dart';
import '../../../constants/workout_colors.dart';
import '../../../constants/workout_sizes.dart';

class RestCompleteOverlay extends StatefulWidget {
  final String exerciseName;
  const RestCompleteOverlay({super.key, required this.exerciseName});

  @override
  State<RestCompleteOverlay> createState() => _RestCompleteOverlayState();
}

class _RestCompleteOverlayState extends State<RestCompleteOverlay> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: WorkoutColors.surface, // grey
      shape: const RoundedRectangleBorder(borderRadius: WRadii.pill),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Text(
          'Time for the next set!',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.white),
        ),
      ),
    );
  }
}