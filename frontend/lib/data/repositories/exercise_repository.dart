import '../models/exercise_model.dart';

class ExerciseRepository {
  static final List<String> muscleList = [
    'All Muscles',
    'Chest',
    'Back',
    'Biceps',
    'Triceps',
    'Shoulders',
    'Legs',
    'Abs',
  ];

  static final List<String> equipmentList = [
    'All Equipment',
    'No Equipment',
    'Barbell',
    'Dumbbell',
    'Kettlebell',
    'Machine',
    'Plate',
    'Resistance Band',
    'Suspension Band',
  ];

  static final List<Exercise> all = [
    Exercise(name: 'Bench Press (Barbell)', muscle: 'Chest', equipment: 'Barbell', imageAsset: 'assets/icons/icon_svg_design.svg'),
    Exercise(name: 'Incline Bench (Barbell)', muscle: 'Chest', equipment: 'Barbell', imageAsset: 'assets/icons/icon_svg_design.svg'),
    Exercise(name: 'Dumbbell Press', muscle: 'Chest', equipment: 'Dumbbell', imageAsset: 'assets/icons/icon_svg_design.svg'),
    Exercise(name: 'Lat Pulldown', muscle: 'Back', equipment: 'Machine', imageAsset: 'assets/icons/icon_svg_design.svg'),
    Exercise(name: 'Barbell Row', muscle: 'Back', equipment: 'Barbell', imageAsset: 'assets/icons/icon_svg_design.svg'),
    Exercise(name: 'Bicep Curl', muscle: 'Biceps', equipment: 'Dumbbell', imageAsset: 'assets/icons/icon_svg_design.svg'),
  ];
}