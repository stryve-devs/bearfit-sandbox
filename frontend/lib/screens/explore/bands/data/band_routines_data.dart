import '../../home/models/routine_model.dart';
import '../../home/models/exercise_model.dart';

final List<RoutineModel> bandRoutines = [
  RoutineModel(
    id: 'band_1',
    title: 'Full Body Bands',
    difficulty: 'Beginner',
    exercises: List.generate(
      7,
      (i) => ExerciseModel(name: 'Band Exercise ${i + 1}', sets: '3x12'),
    ),
    duration: 28,
  ),
  RoutineModel(
    id: 'band_2',
    title: 'Upper Body Band',
    difficulty: 'Intermediate',
    exercises: List.generate(
      8,
      (i) => ExerciseModel(name: 'Band Exercise ${i + 1}', sets: '3x10'),
    ),
    duration: 35,
  ),
  RoutineModel(
    id: 'band_3',
    title: 'Leg & Glute Band',
    difficulty: 'Beginner',
    exercises: List.generate(
      6,
      (i) => ExerciseModel(name: 'Band Exercise ${i + 1}', sets: '3x15'),
    ),
    duration: 25,
  ),
];
