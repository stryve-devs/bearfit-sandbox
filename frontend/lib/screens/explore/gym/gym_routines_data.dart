// Gym routines data file
class GymExercise {
  final String name;
  final int sets;

  GymExercise({
    required this.name,
    required this.sets,
  });
}

class GymRoutine {
  final String title;
  final String? description;
  final List<GymExercise> exercises;

  GymRoutine({
    required this.title,
    this.description,
    required this.exercises,
  });
}

final List<GymRoutine> gymRoutines = [
  GymRoutine(
    title: 'Arm Blaster',
    description:
        'This simple arm workout consists of three supersets that allow you to condense more work in less time.',
    exercises: [
      GymExercise(name: 'Warm Up', sets: 1),
      GymExercise(name: 'EZ Bar Bicep Curl', sets: 2),
      GymExercise(name: 'Curl Crusher', sets: 2),
      GymExercise(name: 'Bicep Curl', sets: 2),
      GymExercise(name: 'Tricep Extension', sets: 2),
      GymExercise(name: 'Preacher Curl', sets: 2),
      GymExercise(name: 'Tricep Rope Pushdown', sets: 2),
    ],
  ),

  GymRoutine(
    title: 'Back Builder',
    description:
        'Negative pull-ups are an excellent back builder, but you can substitute them with assisted pull-ups or inverted rows.',
    exercises: [
      GymExercise(name: 'Warm Up', sets: 1),
      GymExercise(name: 'Negative Pull-Up', sets: 3),
      GymExercise(name: 'Bent Over Row', sets: 3),
      GymExercise(name: 'Lat Pull Down', sets: 3),
      GymExercise(name: 'Shrugs', sets: 3),
    ],
  ),

  GymRoutine(
    title: 'Leg Growth Workout',
    exercises: [
      GymExercise(name: 'Warm Up', sets: 1),
      GymExercise(name: 'Squat', sets: 5),
      GymExercise(name: 'Romanian Deadlift', sets: 4),
      GymExercise(name: 'Leg Extension', sets: 3),
      GymExercise(name: 'Lying Leg Curl', sets: 3),
      GymExercise(name: 'Standing Calf Raise', sets: 3),
    ],
  ),
];
