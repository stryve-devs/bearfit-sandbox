// Band data file
class BandExercise {
  final String name;
  final int sets;

  BandExercise({
    required this.name,
    required this.sets,
  });
}

class BandWorkout {
  final String title;
  final String description;
  final List<BandExercise> exercises;

  BandWorkout({
    required this.title,
    required this.description,
    required this.exercises,
  });
}

final List<BandWorkout> bandWorkouts = [
  BandWorkout(
    title: 'Upper Body (Resistance Band + Bodyweight)',
    description:
        'You will need a resistance band set (preferably open-ended bands with handles) and a band door anchor. Push-up handles/stands are optional.',
    exercises: [
      BandExercise(name: 'Warm Up', sets: 1),
      BandExercise(name: 'Pike Push-Up', sets: 3),
      BandExercise(name: 'Push-Up', sets: 3),
      BandExercise(name: 'Inverted Row', sets: 3),
      BandExercise(name: 'Lat Pull-Down', sets: 2),
      BandExercise(name: 'Chest Fly', sets: 2),
      BandExercise(name: 'Hammer Curl', sets: 2),
      BandExercise(name: 'Bench Dip', sets: 2),
    ],
  ),
  BandWorkout(
    title: 'Full Body (Resistance Band + Bodyweight)',
    description:
        'You will need a pull-up bar, resistance band set, and a band door anchor. Push-up handles are optional.',
    exercises: [
      BandExercise(name: 'Warm Up', sets: 1),
      BandExercise(name: 'Push-Up', sets: 3),
      BandExercise(name: 'Negative Pull-Down', sets: 3),
      BandExercise(name: 'Bulgarian Split Squat', sets: 3),
      BandExercise(name: 'Lat Pull-Down', sets: 2),
      BandExercise(name: 'Chest Fly', sets: 2),
      BandExercise(name: 'Single Leg Glute Bridge', sets: 2),
      BandExercise(name: 'Lateral Raise', sets: 2),
    ],
  ),
  BandWorkout(
    title: 'Resistance Band Leg Builder',
    description:
        'You will need several open-ended resistance bands and looped bands to mix and match resistance.',
    exercises: [
      BandExercise(name: 'Warm Up', sets: 1),
      BandExercise(name: 'Bulgarian Split Squat', sets: 3),
      BandExercise(name: 'Deadlift', sets: 3),
      BandExercise(name: 'Squat', sets: 2),
      BandExercise(name: 'Lateral Band Walks', sets: 2),
    ],
  ),
  BandWorkout(
    title: 'Bands and Bodyweight Quick HIIT Session',
    description:
        'Do each exercise quickly with proper form. Perform each for 40 seconds, rest 20 seconds.',
    exercises: [
      BandExercise(name: 'Warm Up', sets: 1),
      BandExercise(name: 'Squat', sets: 2),
      BandExercise(name: 'Push-Up', sets: 2),
      BandExercise(name: 'Bent Over Row', sets: 2),
      BandExercise(name: 'Jumping Lunge', sets: 2),
      BandExercise(name: 'Mountain Climber', sets: 2),
    ],
  ),
  BandWorkout(
    title: 'Band and Bodyweight Cardio Circuit',
    description:
        'Perform each exercise for 60 seconds. Rest 30 seconds between exercises.',
    exercises: [
      BandExercise(name: 'Warm Up', sets: 1),
      BandExercise(name: 'Burpees', sets: 2),
      BandExercise(name: 'Jump Squat', sets: 2),
      BandExercise(name: 'High Knees', sets: 2),
      BandExercise(name: 'Lat Pull-Down', sets: 2),
      BandExercise(name: 'Lateral Band Walks', sets: 2),
      BandExercise(name: 'Bicycle Crunch', sets: 2),
    ],
  ),
];
