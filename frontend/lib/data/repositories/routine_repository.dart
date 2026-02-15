/// In-memory routines store to support saving targets and loading them in Log Workout.
class ExerciseTarget {
  final String name;
  int sets;
  double targetWeightKg;
  int targetReps;
  int restSeconds; 

  ExerciseTarget({
    required this.name,
    this.sets = 1,
    this.targetWeightKg = 0,
    this.targetReps = 0,
    this.restSeconds = 60,
  });
}

class Routine {
  final String title;
  final List<ExerciseTarget> targets;

  Routine({required this.title, required this.targets});
}

class RoutineRepository {
  static final List<Routine> _routines = <Routine>[];

  static List<Routine> all() => List.unmodifiable(_routines);

  static void add(Routine routine) {
    _routines.removeWhere((r) => r.title == routine.title);
    _routines.add(routine);
  }

  static Routine? byTitle(String title) {
    try {
      return _routines.firstWhere((r) => r.title == title);
    } catch (_) {
      return null;
    }
  }

  static void clear() {
    _routines.clear();
  }
}