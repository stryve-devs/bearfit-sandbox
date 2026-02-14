import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/workout_colors.dart';
import '../../constants/workout_typography.dart';
import '../../constants/workout_sizes.dart';
import '../../widgets/workout/custom_header.dart';
import '../../constants/workout_strings.dart';
import '../../data/repositories/routine_repository.dart';
import 'overlays/empty_routine_dialog.dart';
import 'overlays/discard_workout_dialog.dart';
import 'overlays/clock_overlay.dart';
import 'overlays/workout_in_progress_sheet.dart';
import 'overlays/rest_picker_sheet.dart';
import 'overlays/rest_complete_overlay.dart';
import '../../widgets/common/asset_svg.dart';

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
  int restSeconds; // current rest setting for this exercise
  int restRemaining; // countdown state (seconds), 0 when not resting
  Timer? restTimer;

  ExerciseLog(this.name, {List<SetEntry>? initial, this.restSeconds = 60})
      : sets = initial ?? [SetEntry()],
        restRemaining = 0;

  double get totalVolumeKg => sets.fold(0.0, (sum, s) => sum + s.volumeKg);

  void startRest(VoidCallback onTick, VoidCallback onDone) {
    restTimer?.cancel();
    restRemaining = restSeconds;
    restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      restRemaining = (restRemaining - 1).clamp(0, 999999);
      onTick();
      if (restRemaining == 0) {
        t.cancel();
        onDone();
      }
    });
  }

  void stopRest() {
    restTimer?.cancel();
    restRemaining = 0;
  }
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
  bool _loadedFromArgs = false;

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
      _exercises.add(ExerciseLog(t.name, initial: initialSets, restSeconds: t.restSeconds));
    }
    _currentRoutine = r;
    _addExerciseLabel = null;
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final e in _exercises) {
      e.restTimer?.cancel();
    }
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
        _exercises.add(ExerciseLog(selected)); // default restSeconds=60
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
        restSeconds: ex.restSeconds,
      );
    }).toList();
    final updated = Routine(title: _currentRoutine!.title, targets: updatedTargets);
    RoutineRepository.add(updated);
    setState(() {
      _currentRoutine = updated;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Routine updated with current workout')));
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
                child: SvgPicture.asset('assets/icons/arrow_back.svg', colorFilter: const ColorFilter.mode(WorkoutColors.orange, BlendMode.srcIn), height: 18),
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

                    // Metrics
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

                    // Row 1: Choose from saved routine (uses list/menu SVG)
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
                                const AssetSvg(
                                  assetPath: 'assets/icons/icon_menu.svg',
                                  width: 20,
                                  height: 20,
                                  color: WorkoutColors.orange,
                                ),
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

                    // Row 2: Add Exercise (uses plus icon)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        height: 41,
                        decoration: const BoxDecoration(color: WorkoutColors.surface, borderRadius: WRadii.pill),
                        child: InkWell(
                          borderRadius: WRadii.pill,
                          onTap: _pickExercise,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add, color: WorkoutColors.orange, size: 20),
                              const SizedBox(width: 8),
                              Text(WS.addExercise, style: WT.h2(context, color: WorkoutColors.orange)),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Exercises list
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: _exercises.asMap().entries.map((entry) {
                          final index = entry.key;
                          final ex = entry.value;
                          return _ExerciseCard(
                            key: ValueKey('${ex.name}-$index'),
                            isPhone: _isPhone,
                            exercise: ex,
                            onChanged: () => setState(() {}),
                            onRestChanged: (seconds) {
                              setState(() => ex.restSeconds = seconds);
                            },
                            onRestEnded: () {
                              showDialog(context: context, builder: (_) => RestCompleteOverlay(exerciseName: ex.name));
                            },
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Update Routine with background wrapper (surface pill)
                    if (_currentRoutine != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          height: 41,
                          decoration: const BoxDecoration(color: WorkoutColors.surface, borderRadius: WRadii.pill),
                          child: InkWell(
                            borderRadius: WRadii.pill,
                            onTap: _updateRoutineFromWorkout,
                            child: const Center(
                              child: Text(
                                'Update Routine with current workout',
                                style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.orange),
                              ),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Settings / Discard
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
                                onTap: () => Navigator.pushNamed(context, '/settings'),
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
          FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: valueStyle)),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatefulWidget {
  final ExerciseLog exercise;
  final VoidCallback onChanged;
  final bool isPhone;
  final ValueChanged<int> onRestChanged;
  final VoidCallback onRestEnded;

  const _ExerciseCard({
    super.key,
    required this.exercise,
    required this.onChanged,
    required this.isPhone,
    required this.onRestChanged,
    required this.onRestEnded,
  });

  @override
  State<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<_ExerciseCard> {
  String get _restLabel {
    final s = widget.exercise.restSeconds;
    return s >= 60 ? '${(s ~/ 60)}m' : '${s}s';
  }

  String get _restRemainingLabel {
    final s = widget.exercise.restRemaining;
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    widget.exercise.restTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pillPadH = widget.isPhone ? 20.0 : 24.0;
    final pillPadV = widget.isPhone ? 8.0 : 10.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: WorkoutColors.surface, borderRadius: WRadii.pill),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Rest selector
          Row(
            children: [
              Expanded(
                child: Text(widget.exercise.name, style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.white)),
              ),
              InkWell(
                onTap: () async {
                  final s = await showModalBottomSheet<int>(
                    context: context,
                    backgroundColor: WorkoutColors.black,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (_) => RestPickerSheet(initial: widget.exercise.restSeconds),
                  );
                  if (s != null) {
                    widget.onRestChanged(s);
                    setState(() {});
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer, color: WorkoutColors.orange, size: 18),
                    const SizedBox(width: 6),
                    Text('Rest: $_restLabel', style: const TextStyle(fontFamily: 'Quicksand', fontSize: 14, color: WorkoutColors.orange)),
                  ],
                ),
              ),
            ],
          ),

          // Active rest countdown above the table
          if (widget.exercise.restRemaining > 0) ...[
            const SizedBox(height: 8),
            Container(
              height: 32,
              decoration: const BoxDecoration(color: WorkoutColors.black, borderRadius: WRadii.pill),
              child: Center(
                child: Text('Rest: $_restRemainingLabel', style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 14, color: WorkoutColors.orange)),
              ),
            ),
          ],

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

          ...widget.exercise.sets.asMap().entries.map((entry) {
            final i = entry.key;
            final set = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: FittedBox(fit: BoxFit.scaleDown, child: Text('${i + 1}', style: const TextStyle(fontFamily: 'Quicksand', fontSize: 16, color: WorkoutColors.white))),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _iconBtn('-', () { set.weightKg = (set.weightKg - 1).clamp(0, double.infinity); widget.onChanged(); }, widget.isPhone),
                            const SizedBox(width: 6),
                            Text('${set.weightKg.toStringAsFixed(0)} kg', style: const TextStyle(fontFamily: 'Quicksand', fontSize: 16, color: WorkoutColors.white)),
                            const SizedBox(width: 6),
                            _iconBtn('+', () { set.weightKg = set.weightKg + 1; widget.onChanged(); }, widget.isPhone),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _iconBtn('-', () { set.reps = (set.reps - 1).clamp(0, 999); widget.onChanged(); }, widget.isPhone),
                            const SizedBox(width: 6),
                            Text('${set.reps}', style: const TextStyle(fontFamily: 'Quicksand', fontSize: 16, color: WorkoutColors.white)),
                            const SizedBox(width: 6),
                            _iconBtn('+', () { set.reps = (set.reps + 1).clamp(0, 999); widget.onChanged(); }, widget.isPhone),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          set.done = !set.done;
                          widget.onChanged();
                          // If marking a set done, (re)start rest for this exercise
                          if (set.done) {
                            widget.exercise.startRest(
                              () => setState(() {}),
                              () {
                                widget.onRestEnded();
                                setState(() {}); // hide countdown
                              },
                            );
                          }
                        },
                        child: Container(
                          width: widget.isPhone ? 18 : 20,
                          height: widget.isPhone ? 18 : 20,
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
              onTap: () { widget.exercise.sets.add(SetEntry()); widget.onChanged(); },
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

  // Plus/minus WITHOUT pill/background
  Widget _iconBtn(String label, VoidCallback onTap, bool isPhone) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isPhone ? 6 : 8, vertical: isPhone ? 2 : 3),
        child: Text(label, style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: isPhone ? 14 : 16, color: WorkoutColors.orange)),
      ),
    );
  }
}