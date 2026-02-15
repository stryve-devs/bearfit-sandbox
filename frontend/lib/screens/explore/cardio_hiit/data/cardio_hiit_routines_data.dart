import '../../home/models/routine_model.dart';
import '../../home/models/exercise_model.dart';

final List<RoutineModel> cardioHiitRoutines = [
  RoutineModel(
    id: 'cardio_1',
    title: 'HIIT Cardio Blast',
    difficulty: 'Intermediate',
    exercises: List.generate(
      6,
      (i) => ExerciseModel(name: 'HIIT ${i + 1}', sets: '30s'),
    ),
    duration: 20,
  ),
  RoutineModel(
    id: 'cardio_2',
    title: 'Fat Burning HIIT',
    difficulty: 'Advanced',
    exercises: List.generate(
      8,
      (i) => ExerciseModel(name: 'HIIT ${i + 1}', sets: '40s'),
    ),
    duration: 25,
  ),
  RoutineModel(
    id: 'cardio_3',
    title: 'Steady State Cardio',
    difficulty: 'Beginner',
    exercises: [ExerciseModel(name: 'Steady State', sets: '40min')],
    duration: 40,
  ),
];
