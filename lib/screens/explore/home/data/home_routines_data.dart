// Home routines data file
import '../models/routine_model.dart';
import '../models/exercise_model.dart';

final List<RoutineModel> homeRoutines = [
  const RoutineModel(
    id: 'home_1',
    title: 'Full Body Muscle Builder',
    difficulty: 'Intermediate',
    exercises: [
      ExerciseModel(name: 'Warm Up', sets: '1 set'),
      ExerciseModel(name: 'Pike Push-ups', sets: '3 sets'),
      ExerciseModel(name: 'Bulgarian Split Squat', sets: '3 sets'),
      ExerciseModel(name: 'Push-up', sets: '3 sets'),
      ExerciseModel(name: 'Inverted Row', sets: '3 sets'),
      ExerciseModel(name: 'Single Leg Hip Thrust', sets: '3 sets'),
      ExerciseModel(name: 'Lat Pulldown', sets: '3 sets'),
      ExerciseModel(name: 'Hammer Curl', sets: '2 sets'),
      ExerciseModel(name: 'Bench Dip', sets: '2 sets'),
    ],
    duration: 40,
  ),

  const RoutineModel(
    id: 'home_2',
    title: 'Push-up Routine',
    difficulty: 'Beginner',
    exercises: [
      ExerciseModel(name: 'Warm Up', sets: '1 set'),
      ExerciseModel(name: 'Decline Push-up', sets: '3 sets'),
      ExerciseModel(name: 'Pike Push-up', sets: '3 sets'),
      ExerciseModel(name: 'Close Grip Push-up', sets: '3 sets'),
      ExerciseModel(name: 'Push-up', sets: '3 sets'),
      ExerciseModel(name: 'Incline Push-up', sets: '2 sets'),
    ],
    duration: 30,
  ),

  const RoutineModel(
    id: 'home_3',
    title: 'Upper Body Beginner',
    difficulty: 'Beginner',
    exercises: [
      ExerciseModel(name: 'Warm Up', sets: '1 set'),
      ExerciseModel(name: 'Push-up', sets: '3 sets'),
      ExerciseModel(name: 'Inverted Row', sets: '3 sets'),
      ExerciseModel(name: 'Shoulder Press', sets: '3 sets'),
      ExerciseModel(name: 'Bicep Curl', sets: '3 sets'),
      ExerciseModel(name: 'Bench Dip', sets: '3 sets'),
    ],
    duration: 35,
  ),

  const RoutineModel(
    id: 'home_4',
    title: 'Home Pull Workout',
    difficulty: 'Intermediate',
    exercises: [
      ExerciseModel(name: 'Warm Up', sets: '1 set'),
      ExerciseModel(name: 'Negative Pull-down', sets: '3 sets'),
      ExerciseModel(name: 'Bent Over Row', sets: '3 sets'),
      ExerciseModel(name: 'Lat Pulldown', sets: '3 sets'),
      ExerciseModel(name: 'Shrug Dumbbell', sets: '3 sets'),
      ExerciseModel(name: 'Bicep Curl', sets: '3 sets'),
    ],
    duration: 30,
  ),

  const RoutineModel(
    id: 'home_5',
    title: 'No Equipment Lower Body',
    difficulty: 'Beginner',
    exercises: [
      ExerciseModel(name: 'Warm Up', sets: '1 set'),
      ExerciseModel(name: 'Bulgarian Split Squat', sets: '3 sets'),
      ExerciseModel(name: 'Nordic Hamstring Curl', sets: '3 sets'),
      ExerciseModel(name: 'Squat', sets: '3 sets'),
      ExerciseModel(name: 'Reverse Lunge', sets: '3 sets'),
    ],
    duration: 35,
  ),
];
