import 'dart:async';
import 'package:flutter/material.dart';
import '../../../constants/workout_colors.dart';
import '../../../constants/workout_typography.dart';
import '../../../constants/workout_sizes.dart';
import '../../../widgets/workout/duration_picker.dart';

class ClockOverlay extends StatefulWidget {
  const ClockOverlay({super.key});
  @override
  State<ClockOverlay> createState() => _ClockOverlayState();
}

class _ClockOverlayState extends State<ClockOverlay> {
  bool isTimer = true;
  bool isRunning = false;
  Duration timerDur = Duration.zero;
  Duration stopwatchElapsed = Duration.zero;
  Timer? _ticker;

  void _start() {
    if (isRunning) return;
    setState(() => isRunning = true);
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (isTimer) {
          if (timerDur.inSeconds > 0) {
            timerDur -= const Duration(seconds: 1);
          } else {
            _stop(); // auto stop at 0
          }
        } else {
          stopwatchElapsed += const Duration(seconds: 1);
        }
      });
    });
  }

  void _stop() {
    _ticker?.cancel();
    _ticker = null;
    setState(() => isRunning = false);
  }

  void _reset() {
    _stop();
    setState(() {
      if (isTimer) {
        timerDur = Duration.zero;
      } else {
        stopwatchElapsed = Duration.zero;
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _fmt(Duration d) => '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  Future<void> _openPicker() async {
    if (isRunning) return; // avoid changing while running
    final res = await showDialog<DurationPickerResult>(
      context: context,
      builder: (_) => const DurationPickerDialog(
        initialMinutes: 0,
        initialSeconds: 0,
        minTotalSeconds: 5,
        maxTotalSeconds: 3599,
      ),
    );
    if (res != null) setState(() => timerDur = res.duration);
  }

  @override
  Widget build(BuildContext context) {
    final timerTextColor = isTimer ? WorkoutColors.orange : WorkoutColors.black;
    final timerBgOpacity = isTimer ? 1.0 : 0.7;
    final swTextColor = isTimer ? WorkoutColors.black : WorkoutColors.orange;
    final swBgOpacity = isTimer ? 0.7 : 1.0;

    return Dialog(
      backgroundColor: WorkoutColors.black,
      shape: const RoundedRectangleBorder(borderRadius: WRadii.pill),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 337),
        child: Container(
          decoration: BoxDecoration(
            color: WorkoutColors.black,
            borderRadius: WRadii.pill,
            border: Border.all(color: WorkoutColors.orange, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              const Center(
                child: Text(
                  'Clock',
                  style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w400, fontSize: 16, color: WorkoutColors.white),
                ),
              ),
              const SizedBox(height: 16),

              // Toggle pills
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: WorkoutColors.surface.withOpacity(timerBgOpacity),
                    borderRadius: WRadii.pill,
                    child: InkWell(
                      borderRadius: WRadii.pill,
                      onTap: () => setState(() => isTimer = true),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        child: Text('Timer', style: WT.h2(context, color: timerTextColor)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: WorkoutColors.surface.withOpacity(swBgOpacity),
                    borderRadius: WRadii.pill,
                    child: InkWell(
                      borderRadius: WRadii.pill,
                      onTap: () => setState(() => isTimer = false),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        child: Text('Stopwatch', style: WT.h2(context, color: swTextColor)),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Text(isTimer ? _fmt(timerDur) : _fmt(stopwatchElapsed), style: WT.title(context)),
              const SizedBox(height: 12),

              // Always-visible "Set duration" when Timer is selected (works even if you miss the icon)
              if (isTimer)
                Material(
                  color: WorkoutColors.black,
                  borderRadius: WRadii.pill,
                  child: InkWell(
                    borderRadius: WRadii.pill,
                    onTap: _openPicker,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Center(
                        child: Text(
                          'Set duration',
                          style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.orange),
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              // Controls: Start / Stop / Reset
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: WorkoutColors.surface,
                    borderRadius: WRadii.pill,
                    child: InkWell(
                      borderRadius: WRadii.pill,
                      onTap: _start,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        child: Text('Start', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.orange)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: WorkoutColors.surface,
                    borderRadius: WRadii.pill,
                    child: InkWell(
                      borderRadius: WRadii.pill,
                      onTap: _stop,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        child: Text('Stop', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.orange)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: WorkoutColors.surface,
                    borderRadius: WRadii.pill,
                    child: InkWell(
                      borderRadius: WRadii.pill,
                      onTap: _reset,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        child: Text('Reset', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.orange)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}