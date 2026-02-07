import 'package:flutter/material.dart';

// Core workout screens
import '../screens/workout/workout_home_screen.dart';
import '../screens/workout/add_exercise_screen.dart';
import '../screens/workout/routine_editor_screen.dart';
import '../screens/workout/log_workout_screen.dart';
import '../screens/workout/explore_routines_screen.dart';

// Blank tabs
import '../screens/home/home_blank_screen.dart';
import '../screens/profile/profile_blank_screen.dart';

// Exercise detail placeholder
import '../screens/exercise/exercise_detail_blank_screen.dart';

class App extends StatelessWidget {
  final Map<String, WidgetBuilder> externalRoutes;

  const App({super.key, this.externalRoutes = const {}});

  @override
  Widget build(BuildContext context) {
    final Map<String, WidgetBuilder> baseRoutes = {
      '/home': (c) => const HomeBlankScreen(),
      '/workout': (c) => const WorkoutHomeScreen(),
      '/workout/add': (c) => const AddExerciseScreen(),
      '/workout/routine': (c) => const RoutineEditorScreen(),
      '/workout/log': (c) => const LogWorkoutScreen(),
      '/workout/explore': (c) => const ExploreRoutinesScreen(),
      '/profile': (c) => const ProfileBlankScreen(),
      '/exercise/detail': (c) => const ExerciseDetailBlankScreen(),
    };

    final routes = <String, WidgetBuilder>{}
      ..addAll(baseRoutes)
      ..addAll(externalRoutes);

    return MaterialApp(
      title: 'Bearfit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Quicksand',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        useMaterial3: true,
      ),
      initialRoute: '/workout',
      routes: routes,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => _UnknownRouteScreen(routeName: settings.name ?? 'unknown'),
        );
      },
    );
  }
}

class _UnknownRouteScreen extends StatelessWidget {
  final String routeName;
  const _UnknownRouteScreen({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route not found')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No screen registered for:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            Text(routeName, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/workout', (route) => false),
              child: const Text('Go to Workout Home'),
            ),
          ],
        ),
      ),
    );
  }
}