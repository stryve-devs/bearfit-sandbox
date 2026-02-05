// Travel routines data file
import '../../home/models/routine_model.dart';
import '../../home/models/exercise_model.dart';

final List<RoutineModel> travelRoutines = [
  const RoutineModel(
    id: 'travel_1',
    title: 'Hotel Room Cardio Circuit',
    difficulty: 'Intermediate',
    exercises: [
      ExerciseModel(name: 'Warm Up', sets: '1 set'),
      ExerciseModel(name: 'Burpees', sets: '3 sets'),
      ExerciseModel(name: 'Jump Squats', sets: '3 sets'),
      ExerciseModel(name: 'Jumping Jacks', sets: '3 sets'),
      ExerciseModel(name: 'High Knees', sets: '3 sets'),
      ExerciseModel(name: 'Mountain Climbers', sets: '3 sets'),
    ],
    duration: 25,
  ),

  const RoutineModel(
    id: 'travel_2',
    title: 'HIIT Circuit (No Equipment)',
    difficulty: 'Advanced',
    exercises: [
      ExerciseModel(name: 'Warm Up', sets: '1 set'),
      ExerciseModel(name: 'Jumping Lunges', sets: '3 sets'),
      ExerciseModel(name: 'Kneeling Push-up', sets: '3 sets'),
      ExerciseModel(name: 'High Knees', sets: '3 sets'),
      ExerciseModel(name: 'Bicycle Crunch', sets: '3 sets'),
      ExerciseModel(name: 'Glute Bridge', sets: '3 sets'),
    ],
    duration: 20,
  ),

  const RoutineModel(
    id: 'travel_3',
    title: 'Quick Core Blaster',
    difficulty: 'Beginner',
    exercises: [
      ExerciseModel(name: 'Warm Up', sets: '1 set'),
      ExerciseModel(name: 'Plank', sets: '3 sets'),
      ExerciseModel(name: 'Bicycle Crunch', sets: '3 sets'),
      ExerciseModel(name: 'Russian Twist', sets: '3 sets'),
      ExerciseModel(name: 'Dead Bug', sets: '3 sets'),
    ],
    duration: 18,
  ),

  const RoutineModel(
    id: 'travel_4',
    title: 'Leg and Glute Workout',
    difficulty: 'Intermediate',
    exercises: [
      ExerciseModel(name: 'Warm Up', sets: '1 set'),
      ExerciseModel(name: 'Bulgarian Split Squat', sets: '3 sets'),
      ExerciseModel(name: 'Single Leg Hip Thrust', sets: '3 sets'),
      ExerciseModel(name: 'Lunge', sets: '3 sets'),
      ExerciseModel(name: 'Glute Kickback (Floor)', sets: '3 sets'),
      ExerciseModel(name: 'Single Leg Standing Calf Raise', sets: '3 sets'),
    ],
    duration: 30,
  ),

  const RoutineModel(
    id: 'travel_5',
    title: 'Upper Body Workout',
    difficulty: 'Intermediate',
    exercises: [
      ExerciseModel(name: 'Warm Up', sets: '1 set'),
      ExerciseModel(name: 'Push-up', sets: '3 sets'),
      ExerciseModel(name: 'Inverted Row', sets: '3 sets'),
      ExerciseModel(name: 'Close Grip Push-up', sets: '3 sets'),
      ExerciseModel(name: 'Plank', sets: '2 sets'),
      ExerciseModel(name: 'Superman', sets: '2 sets'),
    ],
    duration: 25,
  ),
];
