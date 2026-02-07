import 'package:flutter/material.dart';
import '../../constants/workout_colors.dart';
import '../../constants/workout_typography.dart';
import '../../constants/workout_sizes.dart';
import '../../widgets/workout/custom_header.dart';
import '../../widgets/workout/pill_button.dart';
import '../../constants/workout_strings.dart';
import 'overlays/empty_routine_dialog.dart';
import 'overlays/routine_saved_dialog.dart';
import '../../data/repositories/routine_repository.dart';

class RoutineEditorScreen extends StatefulWidget {
  const RoutineEditorScreen({super.key});
  @override
  State<RoutineEditorScreen> createState() => _RoutineEditorScreenState();
}

class _RoutineEditorScreenState extends State<RoutineEditorScreen> {
  final TextEditingController titleCtrl = TextEditingController();
  bool _editingTitle = false;
  final List<ExerciseTarget> _targets = [];

  double get _contentWidth => MediaQuery.of(context).size.width - 24;
  bool get _isPhone => MediaQuery.of(context).size.width < 380;

  void _onSave() async {
    if (_targets.isEmpty) {
      showDialog(context: context, builder: (_) => const EmptyRoutineDialog(message: 'Your routine needs at least one exercise'));
      return;
    }
    final routine = Routine(
      title: titleCtrl.text.isEmpty ? 'Untitled Routine' : titleCtrl.text,
      targets: List.of(_targets),
    );
    RoutineRepository.add(routine);

    final action = await showDialog<String>(context: context, builder: (_) => const RoutineSavedDialog());
    if (action == 'start') {
      await Navigator.pushNamed(context, '/workout/log', arguments: routine);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/workout', (r) => false);
    } else {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/workout', (r) => false);
    }
  }

  Future<void> _pickExercise() async {
    final selected = await Navigator.pushNamed(context, '/workout/add');
    if (selected is String && selected.isNotEmpty) {
      setState(() => _targets.add(ExerciseTarget(name: selected)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cw = _contentWidth;

    return Scaffold(
      backgroundColor: WorkoutColors.black,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              left: GestureDetector(onTap: () => Navigator.pop(context), child: Text(WS.cancel, style: WT.body(context, color: WorkoutColors.orange))),
              center: Text(WS.workout, style: WT.h2(context)),
              right: GestureDetector(
                onTap: _onSave,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 24,
                  decoration: const BoxDecoration(color: WorkoutColors.orange, borderRadius: WRadii.pill),
                  child: Center(child: Text(WS.save, style: WT.body(context, color: WorkoutColors.black))),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        width: cw,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Inline editable title
                            !_editingTitle
                                ? GestureDetector(
                                    onTap: () => setState(() => _editingTitle = true),
                                    child: Text(titleCtrl.text.isEmpty ? 'Routine title' : titleCtrl.text, style: WT.h2(context, color: const Color(0xB3FD7A2A))),
                                  )
                                : Container(
                                    height: 41,
                                    decoration: const BoxDecoration(color: WorkoutColors.surface, borderRadius: WRadii.pill),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    alignment: Alignment.centerLeft,
                                    child: TextField(
                                      controller: titleCtrl,
                                      style: WT.title(context),
                                      decoration: const InputDecoration(border: InputBorder.none),
                                      onSubmitted: (_) => setState(() => _editingTitle = false),
                                      onEditingComplete: () => setState(() => _editingTitle = false),
                                    ),
                                  ),

                            const SizedBox(height: 16),

                            // Meditating figure centered
                            Center(
                              child: Icon(
                                Icons.self_improvement,
                                color: WorkoutColors.white,
                                size: _isPhone ? 48 : 60,
                              ),
                            ),

                            const SizedBox(height: 16),

                            PillButton(label: WS.addExercise, onTap: _pickExercise, bg: WorkoutColors.surface, fg: WorkoutColors.orange),

                            const SizedBox(height: 16),

                            if (_targets.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Column(
                                children: _targets
                                    .map<Widget>((t) => _TargetCard(target: t, onChanged: () => setState(() {})))
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetCard extends StatelessWidget {
  final ExerciseTarget target;
  final VoidCallback onChanged;
  const _TargetCard({required this.target, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: WorkoutColors.surface, borderRadius: WRadii.pill),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(target.name, style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.white)),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(child: Center(child: Text('Sets', style: TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: WorkoutColors.white)))),
              Expanded(child: Center(child: Text('Target Weight', style: TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: WorkoutColors.white)))),
              Expanded(child: Center(child: Text('Target Reps', style: TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: WorkoutColors.white)))),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _iconBtn('-', () { target.sets = (target.sets - 1).clamp(0, 999); onChanged(); }),
                      const SizedBox(width: 8),
                      Text('${target.sets}', style: const TextStyle(fontFamily: 'Quicksand', fontSize: 16, color: WorkoutColors.white)),
                      const SizedBox(width: 8),
                      _iconBtn('+', () { target.sets = (target.sets + 1).clamp(0, 999); onChanged(); }),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _iconBtn('-', () { target.targetWeightKg = (target.targetWeightKg - 1).clamp(0, double.infinity); onChanged(); }),
                      const SizedBox(width: 8),
                      Text('${target.targetWeightKg.toStringAsFixed(0)} kg', style: const TextStyle(fontFamily: 'Quicksand', fontSize: 16, color: WorkoutColors.white)),
                      const SizedBox(width: 8),
                      _iconBtn('+', () { target.targetWeightKg = target.targetWeightKg + 1; onChanged(); }),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _iconBtn('-', () { target.targetReps = (target.targetReps - 1).clamp(0, 999); onChanged(); }),
                      const SizedBox(width: 8),
                      Text('${target.targetReps}', style: const TextStyle(fontFamily: 'Quicksand', fontSize: 16, color: WorkoutColors.white)),
                      const SizedBox(width: 8),
                      _iconBtn('+', () { target.targetReps = (target.targetReps + 1).clamp(0, 999); onChanged(); }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(String label, VoidCallback onTap) {
    return Material(
      color: WorkoutColors.black,
      borderRadius: WRadii.pill,
      child: InkWell(
        borderRadius: WRadii.pill,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(label, style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, color: WorkoutColors.orange)),
        ),
      ),
    );
  }
}