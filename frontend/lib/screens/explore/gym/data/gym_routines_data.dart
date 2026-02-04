import '../../home/models/routine_model.dart';
import '../../home/models/exercise_model.dart';

final List<RoutineModel> gymRoutines = [
  RoutineModel(
    id: 'gym_1',
    title: 'Push Pull Legs',
    difficulty: 'Intermediate',
    exercises: List.generate(
      12,
      (i) => ExerciseModel(name: 'Gym Exercise ${i + 1}', sets: '4x8'),
    ),
    duration: 50,
  ),
  RoutineModel(
    id: 'gym_2',
    title: 'Upper Lower Split',
    difficulty: 'Beginner',
    exercises: List.generate(
      10,
      (i) => ExerciseModel(name: 'Gym Exercise ${i + 1}', sets: '3x10'),
    ),
    duration: 45,
  ),
  RoutineModel(
    id: 'gym_3',
    title: 'Full Body Strength',
    difficulty: 'Advanced',
    exercises: List.generate(
      14,
      (i) => ExerciseModel(name: 'Gym Exercise ${i + 1}', sets: '5x5'),
    ),
    duration: 60,
  ),
  RoutineModel(
    id: 'gym_4',
    title: 'Bodybuilding Hypertrophy',
    difficulty: 'Advanced',
    exercises: List.generate(
      13,
      (i) => ExerciseModel(name: 'Gym Exercise ${i + 1}', sets: '4x10'),
    ),
    duration: 55,
  ),
  RoutineModel(
    id: 'gym_5',
    title: 'Powerlifting',
    difficulty: 'Advanced',
    exercises: List.generate(
      9,
      (i) => ExerciseModel(name: 'Gym Exercise ${i + 1}', sets: '3x5'),
    ),
    duration: 60,
  ),
  RoutineModel(
    id: 'gym_6',
    title: 'Functional Fitness',
    difficulty: 'Intermediate',
    exercises: List.generate(
      11,
      (i) => ExerciseModel(name: 'Gym Exercise ${i + 1}', sets: '3x12'),
    ),
    duration: 40,
  ),
  RoutineModel(
    id: 'gym_7',
    title: 'Circuit Training',
    difficulty: 'Intermediate',
    exercises: List.generate(
      10,
      (i) => ExerciseModel(name: 'Gym Exercise ${i + 1}', sets: 'AMRAP'),
    ),
    duration: 35,
  ),
  RoutineModel(
    id: 'gym_8',
    title: 'Endurance Builder',
    difficulty: 'Beginner',
    exercises: List.generate(
      8,
      (i) => ExerciseModel(name: 'Gym Exercise ${i + 1}', sets: '2x15'),
    ),
    duration: 45,
  ),
];
