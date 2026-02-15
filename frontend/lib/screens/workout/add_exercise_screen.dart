import 'package:flutter/material.dart';
import '../../constants/workout_colors.dart';
import '../../constants/workout_strings.dart';
import '../../constants/workout_typography.dart';
import '../../constants/workout_sizes.dart';
import '../../widgets/workout/custom_header.dart';
import '../../data/repositories/exercise_repository.dart';
import '../../data/models/exercise_model.dart';
import 'overlays/muscles_filter_sheet.dart';
import 'overlays/equipment_filter_sheet.dart';
import 'overlays/empty_routine_dialog.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key});
  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  String? selectedEquipment;
  String? selectedMuscle;

  bool get _eqActive => selectedEquipment != null && selectedEquipment != WS.allEquipment;
  bool get _mActive => selectedMuscle != null && selectedMuscle != WS.allMuscles;
  bool get _hasActiveFilters => _eqActive || _mActive;

  List<Exercise> get filtered {
    final q = searchController.text.trim().toLowerCase();
    return ExerciseRepository.all.where((e) {
      final eq = !_eqActive || e.equipment == selectedEquipment;
      final mq = !_mActive || e.muscle == selectedMuscle;
      final sq = q.isEmpty || e.name.toLowerCase().contains(q);
      return eq && mq && sq;
    }).toList();
  }

  double get _contentWidth => MediaQuery.of(context).size.width - 24;

  Future<void> _openEquipmentSheet() async {
    final v = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: WorkoutColors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => const EquipmentFilterSheet(),
    );
    if (v != null) setState(() => selectedEquipment = v == WS.allEquipment ? null : v);
  }

  Future<void> _openMusclesSheet() async {
    final v = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: WorkoutColors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => const MusclesFilterSheet(),
    );
    if (v != null) setState(() => selectedMuscle = v == WS.allMuscles ? null : v);
  }

  void _resetFilters() => setState(() { selectedEquipment = null; selectedMuscle = null; });

  void _onCreate() {
    showDialog(context: context, builder: (_) => const EmptyRoutineDialog(message: 'Your routine needs at least one exercise'));
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
              center: Text(WS.addExercise, style: WT.h2(context)),
              right: GestureDetector(onTap: _onCreate, child: Text(WS.create, style: WT.body(context, color: WorkoutColors.orange))),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // Search
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        width: cw,
                        child: Container(
                          height: 41,
                          decoration: const BoxDecoration(color: WorkoutColors.surface, borderRadius: WRadii.pill),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.add_box_rounded, color: WorkoutColors.orange, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  focusNode: _searchFocus,
                                  controller: searchController,
                                  onChanged: (_) => setState(() {}),
                                  style: WT.h2(context, color: WorkoutColors.orange),
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
                    ),

                    const SizedBox(height: 9),

                    // Filter chips
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        width: cw,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 41,
                                decoration: const BoxDecoration(color: WorkoutColors.surface, borderRadius: WRadii.pill),
                                child: InkWell(
                                  borderRadius: WRadii.pill,
                                  onTap: _openEquipmentSheet,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                                      child: FittedBox(fit: BoxFit.scaleDown, child: Text(selectedEquipment ?? WS.allEquipment, style: WT.h2(context, color: WorkoutColors.orange))),
                                    ),
                                  ),
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
                                  onTap: _openMusclesSheet,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                                      child: FittedBox(fit: BoxFit.scaleDown, child: Text(selectedMuscle ?? WS.allMuscles, style: WT.h2(context, color: WorkoutColors.orange))),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (_hasActiveFilters)
                              InkWell(
                                onTap: _resetFilters,
                                customBorder: const CircleBorder(),
                                child: Container(
                                  width: 17,
                                  height: 17,
                                  decoration: const BoxDecoration(color: WorkoutColors.orange, shape: BoxShape.circle),
                                  child: const Icon(Icons.close, size: 12, color: WorkoutColors.black),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Label
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Align(alignment: Alignment.centerLeft, child: Text(WS.popularExercises, style: WT.h2(context, color: const Color(0xB3FD7A2A)))),
                    ),

                    const SizedBox(height: 12),

                    // List
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        width: cw,
                        child: Column(
                          children: [
                            ...filtered.map((e) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _ExerciseListCard(
                                    title: e.name,
                                    subtitle: e.muscle,
                                    onSelect: () => Navigator.pop(context, e.name),
                                    onDetail: () => Navigator.pushNamed(context, '/exercise/detail', arguments: e.name),
                                  ),
                                )),
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

class _ExerciseListCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onSelect;
  final VoidCallback onDetail;

  const _ExerciseListCard({
    required this.title,
    required this.subtitle,
    required this.onSelect,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: WorkoutColors.surface,
      borderRadius: WRadii.pill,
      child: InkWell(
        borderRadius: WRadii.pill,
        onTap: onSelect, // tap card selects exercise
        child: Container(
          height: 59,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.fitness_center, color: WorkoutColors.white, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, height: 20/16, color: WorkoutColors.white)),
                          const SizedBox(height: 6),
                          Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w400, fontSize: 12, height: 15/12, color: WorkoutColors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Right arrow opens the detail placeholder page
              InkWell(
                customBorder: const CircleBorder(),
                onTap: onDetail,
                child: const Icon(Icons.chevron_right, color: WorkoutColors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}