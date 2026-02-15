// Cardio HIIT data file
class CardioExercise {
  final String name;
  final int sets;

  CardioExercise({
    required this.name,
    required this.sets,
  });
}

class CardioWorkout {
  final String title;
  final String description;
  final List<CardioExercise> exercises;

  CardioWorkout({
    required this.title,
    required this.description,
    required this.exercises,
  });
}

final List<CardioWorkout> cardioHiitWorkouts = [
  CardioWorkout(
    title: 'Core & Cardio',
    description:
        'Perform each exercise for the prescribed time or RPE, recover for 30 seconds, and move to the next activity. Once you do a set of each, rest for two minutes and repeat two more rounds.',
    exercises: [
      CardioExercise(name: 'Warm Up', sets: 1),
      CardioExercise(name: 'Plank Push-Up', sets: 3),
      CardioExercise(name: 'Russian Twist', sets: 3),
      CardioExercise(name: 'Bird Mountain Climber', sets: 3),
      CardioExercise(name: 'Superman', sets: 3),
      CardioExercise(name: 'High Knees', sets: 3),
    ],
  ),
  CardioWorkout(
    title: 'High-Intensity Blast',
    description:
        'Perform each movement for 40 seconds, recover for 20 seconds, and move to the next activity. After all exercises, rest two minutes and repeat.',
    exercises: [
      CardioExercise(name: 'Warm Up', sets: 1),
      CardioExercise(name: 'Jumping Jacks', sets: 3),
      CardioExercise(name: 'Flutter Kicks', sets: 3),
      CardioExercise(name: 'Frog Jumps', sets: 3),
      CardioExercise(name: 'High Knees Skips', sets: 3),
    ],
  ),
  CardioWorkout(
    title: 'Full Body Burn',
    description:
        'This cardio workout combines endurance and strength-based movements to improve athletic capacity, strength endurance, and coordination.',
    exercises: [
      CardioExercise(name: 'Warm Up', sets: 1),
      CardioExercise(name: 'Burpee', sets: 2),
      CardioExercise(name: 'High Knees', sets: 2),
      CardioExercise(name: 'Jump Squat', sets: 2),
      CardioExercise(name: 'Mountain Climber', sets: 2),
      CardioExercise(name: 'Kneeling Push-Up', sets: 2),
    ],
  ),
  CardioWorkout(
    title: 'Explosive HIIT Workout',
    description:
        'Perform each movement for 30 seconds, recover for 30 seconds, and move on. After completing all exercises, rest for two minutes and repeat.',
    exercises: [
      CardioExercise(name: 'Warm Up', sets: 1),
      CardioExercise(name: 'Box Jump', sets: 3),
      CardioExercise(name: 'Clap Push-Up', sets: 3),
      CardioExercise(name: 'Single Leg Glute Bridge', sets: 3),
      CardioExercise(name: 'Mountain Climber', sets: 3),
      CardioExercise(name: 'Jumping Lunge', sets: 3),
    ],
  ),
];
