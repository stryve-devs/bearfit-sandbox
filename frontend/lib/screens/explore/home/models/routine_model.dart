// Routine model file
import 'exercise_model.dart';

class RoutineModel {
  final String id;
  final String title;
  final String difficulty;
  final List<ExerciseModel> exercises;
  final int duration; // minutes

  const RoutineModel({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.exercises,
    required this.duration,
  });
}
