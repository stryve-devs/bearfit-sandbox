import 'dart:async';
import 'package:flutter/material.dart';
import '../../constants/workout_colors.dart';
import '../../constants/workout_typography.dart';
import '../../constants/workout_sizes.dart';
import '../../widgets/workout/custom_header.dart';
import '../../widgets/workout/pill_button.dart';
import '../../constants/workout_strings.dart';
import '../../data/repositories/routine_repository.dart';
import 'overlays/empty_routine_dialog.dart';
import 'overlays/discard_workout_dialog.dart';
import 'overlays/clock_overlay.dart';
import 'overlays/workout_in_progress_sheet.dart';

class SetEntry {
  double weightKg;
  int reps;
  bool done;
  SetEntry({this.weightKg = 0, this.reps = 0, this.done = false});
  double get volumeKg => weightKg * reps;
}

class ExerciseLog {
  final String name;
  final List<SetEntry> sets;
  ExerciseLog(this.name, {List<SetEntry>? initial}) : sets = initial ?? [SetEntry()];
  double get totalVolumeKg => sets.fold(0.0, (sum, s) => sum + s.volumeKg);
}

class LogWorkoutScreen extends StatefulWidget {
  const LogWorkoutScreen({super.key});
  @override
  State<LogWorkoutScreen> createState() => _LogWorkoutScreenState();
}

class _LogWorkoutScreenState extends State<LogWorkoutScreen> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  final List<ExerciseLog> _exercises = [];
  String? _addExerciseLabel;
  Routine? _currentRoutine;
  bool _loadedFromArgs = false; // prevents reloading the routine and clearing added exercises

  double get _w => MediaQuery.of(context).size.width;
  bool get _isPhone => _w < 380;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) => setState(() => _elapsed += const Duration(seconds: 1)));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load routine from route arguments ONLY once
    if (!_loadedFromArgs) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg is Routine) {
        _applyRoutine(arg);
      }
      _loadedFromArgs = true;
    }
  }

  void _applyRoutine(Routine r) {
    _exercises.clear();
    for (final t in r.targets) {
      final initialSets = List<SetEntry>.generate(
        t.sets,
        (_) => SetEntry(weightKg: t.targetWeightKg, reps: t.targetReps, done: false),
      );
      _exercises.add(ExerciseLog(t.name, initial: initialSets));
    }
    _currentRoutine = r;
    _addExerciseLabel = null;
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(Duration d) => '${d.inHours}:${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  double get _totalVolumeKg => _exercises.fold(0.0, (sum, e) => sum + e.totalVolumeKg);
  String get _volumeText => '${_totalVolumeKg.toStringAsFixed(0)} kg';

  Future<void> _pickExercise() async {
    final selected = await Navigator.pushNamed(context, '/workout/add');
    if (selected is String && selected.isNotEmpty) {
      setState(() {
        _addExerciseLabel = selected;
        _exercises.add(ExerciseLog(selected));
      });
    }
  }

  void _onLeave() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: WorkoutColors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => const WorkoutInProgressSheet(),
    );
    if (choice == 'Discard') {
      final confirm = await showDialog<bool>(context: context, builder: (_) => const DiscardWorkoutDialog());
      if (confirm == true) Navigator.popUntil(context, ModalRoute.withName('/workout'));
    }
  }

  void _onFinish() {
    if (_exercises.isEmpty) {
      showDialog(context: context, builder: (_) => const EmptyRoutineDialog(message: 'Add an exercise'));
      return;
    }
    Navigator.pop(context);
  }

  Future<void> _chooseRoutine() async {
    final routines = RoutineRepository.all();
    if (routines.isEmpty) return;
    final r = await showModalBottomSheet<Routine>(
      context: context,
      backgroundColor: WorkoutColors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (c) {
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const SizedBox(height: 8),
              const Center(child: Text('Choose Routine', style: TextStyle(fontFamily: 'Quicksand', fontSize: 16, fontWeight: FontWeight.w700, color: WorkoutColors.white))),
              const SizedBox(height: 12),
              for (final rr in routines)
                ListTile(
                  title: Text(rr.title, style: const TextStyle(fontFamily: 'Quicksand', color: WorkoutColors.white)),
                  subtitle: Text('${rr.targets.length} exercises', style: const TextStyle(fontFamily: 'Quicksand', color: WorkoutColors.white)),
                  trailing: const Icon(Icons.chevron_right, color: WorkoutColors.white),
                  onTap: () => Navigator.pop(c, rr),
                ),
            ],
          ),
        );
      },
    );
    if (r != null) {
      _applyRoutine(r);
    }
  }

  // Update the current routine to include exactly the current workout (including newly added exercises)
  void _updateRoutineFromWorkout() {
    if (_currentRoutine == null) return;
    final updatedTargets = _exercises.map((ex) {
      final sets = ex.sets.length;
      final first = ex.sets.isNotEmpty ? ex.sets.first : SetEntry();
      return ExerciseTarget(
        name: ex.name,
        sets: sets,
        targetWeightKg: first.weightKg,
        targetReps: first.reps,
      );
    }).toList();
    final updated = Routine(title: _currentRoutine!.title, targets: updatedTargets);
    RoutineRepository.add(updated);
    setState(() {
      _currentRoutine = updated;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Routine updated with current workout')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routines = RoutineRepository.all();

    return Scaffold(
      backgroundColor: WorkoutColors.black,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              left: GestureDetector(
                onTap: _onLeave,
                child: const Icon(Icons.arrow_back_ios_new, color: WorkoutColors.orange, size: 18),
              ),
              center: Text('Log Workout', style: WT.h2(context)),
              right: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.access_time, color: WorkoutColors.orange, size: 24),
                    onPressed: () => showDialog(context: context, builder: (_) => const ClockOverlay()),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _onFinish,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: 24,
                      decoration: const BoxDecoration(color: WorkoutColors.orange, borderRadius: WRadii.pill),
                      child: Center(child: Text('Finish', style: WT.body(context, color: WorkoutColors.black))),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // Metrics: use Expanded cells so they shrink on small screens
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(child: _metricBlock(context, 'Duration', _fmt(_elapsed))),
                          Expanded(child: _metricBlock(context, 'Volume', _volumeText)),
                          Expanded(child: _metricBlock(context, 'Sets', _exercises.fold<int>(0, (sum, e) => sum + e.sets.length).toString())),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Saved routine picker (always available if you have any)
                    if (routines.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          height: 41,
                          decoration: const BoxDecoration(color: WorkoutColors.surface, borderRadius: WRadii.pill),
                          child: InkWell(
                            borderRadius: WRadii.pill,
                            onTap: _chooseRoutine,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.list_alt, color: WorkoutColors.orange, size: 20),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    _currentRoutine?.title ?? 'Choose saved routine',
                                    overflow: TextOverflow.ellipsis,
                                    style: WT.h2(context, color: WorkoutColors.orange),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 12),

                    // Add Exercise
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: PillButton(
                        label: _addExerciseLabel ?? WS.addExercise,
                        onTap: _pickExercise,
                        bg: WorkoutColors.surface,
                        fg: WorkoutColors.orange,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Exercises list with sets table
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: _exercises.map((ex) => _ExerciseCard(isPhone: _isPhone, exercise: ex, onChanged: () => setState(() {}))).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Update Routine (visible when a routine is selected)
                    if (_currentRoutine != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Material(
                          color: WorkoutColors.black,
                          borderRadius: WRadii.pill,
                          child: InkWell(
                            borderRadius: WRadii.pill,
                            onTap: _updateRoutineFromWorkout,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              child: Center(
                                child: Text(
                                  'Update Routine with current workout',
                                  style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.orange),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Settings / Discard moved below exercises
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 41,
                              decoration: const BoxDecoration(color: WorkoutColors.surface, borderRadius: WRadii.pill),
                              child: InkWell(
                                borderRadius: WRadii.pill,
                                onTap: () {},
                                child: Center(child: Text('Settings', style: WT.h2(context, color: WorkoutColors.orange))),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 41,
                              decoration: const BoxDecoration(color: WorkoutColors.surface, borderRadius: WRadii.pill),
                              child: InkWell(
                                borderRadius: WRadii.pill,
                                onTap: () async {
                                  final ok = await showDialog<bool>(context: context, builder: (_) => const DiscardWorkoutDialog());
                                  if (ok == true) Navigator.pop(context);
                                },
                                child: Center(child: Text(WS.discardWorkout, style: WT.h2(context, color: WorkoutColors.orange))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricBlock(BuildContext c, String label, String value) {
    // Shrink text slightly on narrow screens
    final labelStyle = WT.title(c);
    final valueStyle = WT.body(c);
    return Container(
      height: 50,
      decoration: const BoxDecoration(color: WorkoutColors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: labelStyle),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: valueStyle),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final ExerciseLog exercise;
  final VoidCallback onChanged;
  final bool isPhone;
  const _ExerciseCard({required this.exercise, required this.onChanged, required this.isPhone});

  @override
  Widget build(BuildContext context) {
    final pillPadH = isPhone ? 20.0 : 24.0;
    final pillPadV = isPhone ? 8.0 : 10.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: WorkoutColors.surface, borderRadius: WRadii.pill),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(exercise.name, style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.white)),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(child: Center(child: Text('Set', style: TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: WorkoutColors.white)))),
              Expanded(child: Center(child: Text('Weight', style: TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: WorkoutColors.white)))),
              Expanded(child: Center(child: Text('Reps', style: TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: WorkoutColors.white)))),
              Expanded(child: Center(child: Text('Done', style: TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: WorkoutColors.white)))),
            ],
          ),
          const SizedBox(height: 6),
          ...exercise.sets.asMap().entries.map((entry) {
            final i = entry.key;
            final set = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  // Set #
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('${i + 1}', style: const TextStyle(fontFamily: 'Quicksand', fontSize: 16, color: WorkoutColors.white)),
                      ),
                    ),
                  ),
                  // Weight
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _iconBtn('-', () { set.weightKg = (set.weightKg - 1).clamp(0, double.infinity); onChanged(); }, isPhone),
                            const SizedBox(width: 6),
                            Text('${set.weightKg.toStringAsFixed(0)} kg', style: const TextStyle(fontFamily: 'Quicksand', fontSize: 16, color: WorkoutColors.white)),
                            const SizedBox(width: 6),
                            _iconBtn('+', () { set.weightKg = set.weightKg + 1; onChanged(); }, isPhone),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Reps
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _iconBtn('-', () { set.reps = (set.reps - 1).clamp(0, 999); onChanged(); }, isPhone),
                            const SizedBox(width: 6),
                            Text('${set.reps}', style: const TextStyle(fontFamily: 'Quicksand', fontSize: 16, color: WorkoutColors.white)),
                            const SizedBox(width: 6),
                            _iconBtn('+', () { set.reps = (set.reps + 1).clamp(0, 999); onChanged(); }, isPhone),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Done
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        onTap: () { set.done = !set.done; onChanged(); },
                        child: Container(
                          width: isPhone ? 18 : 20,
                          height: isPhone ? 18 : 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: WorkoutColors.orange, width: 2),
                            color: set.done ? WorkoutColors.orange : Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 8),
          Material(
            color: WorkoutColors.black,
            borderRadius: WRadii.pill,
            child: InkWell(
              borderRadius: WRadii.pill,
              onTap: () { exercise.sets.add(SetEntry()); onChanged(); },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: pillPadH, vertical: pillPadV),
                child: const Center(child: Text('+ Add Set', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.orange))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(String label, VoidCallback onTap, bool isPhone) {
    // Smaller wrapper and padding on phones to avoid overflow
    return Material(
      color: WorkoutColors.black,
      borderRadius: WRadii.pill,
      child: InkWell(
        borderRadius: WRadii.pill,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isPhone ? 8 : 10, vertical: isPhone ? 4 : 6),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w700,
              fontSize: isPhone ? 14 : 16,
              color: WorkoutColors.orange,
            ),
          ),
        ),
      ),
    );
  }
}