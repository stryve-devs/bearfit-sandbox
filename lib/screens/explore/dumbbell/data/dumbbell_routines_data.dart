// Dumbbell routines data file
import '../../home/models/routine_model.dart';
import '../../home/models/exercise_model.dart';

final List<RoutineModel> dumbbellRoutines = [
  const RoutineModel(
    id: 'db_1',
    title: 'Dumbbell Arms Workout',
    difficulty: 'Intermediate',
    exercises: [
      ExerciseModel(name: 'Warm Up', sets: '1 set'),
      ExerciseModel(name: 'Bicep Curl', sets: '3 sets'),
      ExerciseModel(name: 'Preacher Curl', sets: '2 sets'),
      ExerciseModel(name: 'Concentration Curl', sets: '2 sets'),
      ExerciseModel(name: 'Skull Crusher', sets: '2 sets'),
      ExerciseModel(name: 'Single Arm Tricep Extension', sets: '2 sets'),
      ExerciseModel(name: 'Tricep Kickback', sets: '2 sets'),
    ],
    duration: 35,
  ),

  const RoutineModel(
    id: 'db_2',
    title: 'Dumbbell Upper Body Focus',
    difficulty: 'Intermediate',
    exercises: [
      ExerciseModel(name: 'Warm Up', sets: '1 set'),
      ExerciseModel(name: 'Incline Bench Press', sets: '4 sets'),
      ExerciseModel(name: 'Dumbbell Row', sets: '4 sets'),
      ExerciseModel(name: 'Overhead Press', sets: '3 sets'),
      ExerciseModel(name: 'Bent Over Row', sets: '3 sets'),
      ExerciseModel(name: 'Lateral Raise', sets: '2 sets'),
      ExerciseModel(name: 'Hammer Curl', sets: '2 sets'),
    ],
    duration: 40,
  ),

  const RoutineModel(
    id: 'db_3',
    title: 'Full Body Dumbbell Workout For Mass',
    difficulty: 'Advanced',
    exercises: [
      ExerciseModel(name: 'Warm Up', sets: '1 set'),
      ExerciseModel(name: 'Floor Press', sets: '4 sets'),
      ExerciseModel(name: 'Bulgarian Split Squat', sets: '4 sets'),
      ExerciseModel(name: 'Bent Over Row', sets: '3 sets'),
      ExerciseModel(name: 'Shoulder Press', sets: '3 sets'),
      ExerciseModel(name: 'Single Leg Hip Thrust', sets: '3 sets'),
      ExerciseModel(name: 'Bicep Curl', sets: '2 sets'),
      ExerciseModel(name: 'Tricep Extension', sets: '2 sets'),
    ],
    duration: 50,
  ),

  const RoutineModel(
    id: 'db_4',
    title: 'Dumbbell Lower Body And Glutes',
    difficulty: 'Intermediate',
    exercises: [
      ExerciseModel(name: 'Warm Up', sets: '1 set'),
      ExerciseModel(name: 'Bulgarian Split Squat', sets: '1 set'),
      ExerciseModel(name: 'Romanian Deadlift', sets: '3 sets'),
      ExerciseModel(name: 'Split Squat', sets: '3 sets'),
      ExerciseModel(name: 'Standing Calf Raise', sets: '3 sets'),
    ],
    duration: 30,
  ),

  const RoutineModel(
    id: 'db_5',
    title: 'Dumbbell HIIT Session',
    difficulty: 'Advanced',
    exercises: [
      ExerciseModel(name: 'Warm Up', sets: '1 set'),
      ExerciseModel(name: 'Renegade Row', sets: '3 sets'),
      ExerciseModel(name: 'Lunges', sets: '3 sets'),
      ExerciseModel(name: 'Bent Over Row', sets: '3 sets'),
      ExerciseModel(name: 'Frog Pumps', sets: '3 sets'),
      ExerciseModel(name: 'Dumbbell Snatch', sets: '3 sets'),
    ],
    duration: 25,
  ),
];
