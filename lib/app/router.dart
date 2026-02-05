import 'package:flutter/material.dart';
import 'package:flutter_frontend/data/models/athlete.dart';
import 'package:flutter_frontend/data/models/post.dart';
import 'package:flutter_frontend/screens/home/home24_share_screen.dart';
import '../state/app_state.dart';

import '../screens/home/home_screen.dart';
import '../screens/home/home3_discover_feed.dart';
import '../screens/home/home4_post_detail.dart';
import '../screens/home/home5_full_image.dart';
import '../screens/home/notifications_screen.dart';
import '../screens/home/contacts_screen.dart';
import '../screens/home/profile_screen.dart';
import '../screens/home/workout_stats_screen.dart';
import '../screens/home/home21_routine_screen.dart';
import '../screens/home/home22_warmup_screen.dart';
import '../screens/home/home23_warmup_detail_screen.dart';

// ✅ FIX: keep ONLY ONE import for Screen24Share (remove duplicates)
import '../screens/home/home24_share_screen.dart';

// ✅ Home14 + Home15
import '../screens/home/stats_share_screen.dart';

// ✅ Home12 + Home13
import '../screens/home/workout_history_screen.dart';
import '../screens/home/workout_howto_screen.dart';

// ✅ NEW: Home17 + Home18/19/20
import '../screens/home/home17_profile_media.dart';
import '../screens/home/home18_workout_detail.dart';
import '../screens/home/home19_workout_detail.dart';
import '../screens/home/home20_workout_detail.dart';

class AppRoutes {
  static const home1 = '/home1';
  static const home3 = '/home3';
  static const home4 = '/home4';
  static const home5 = '/home5';

  // ✅ Home21 + Home22 + Home23 + Home24
  static const home21 = '/home21';
  static const home22 = '/home22';
  static const home23 = '/home23';
  static const home24 = '/home24';

  // ✅ REAL Screen24Share route
  static const screen24Share = '/screen24-share';

  static const notifications = '/notifications';
  static const contacts = '/contacts';
  static const profile = '/profile';
  static const workoutStats = '/workout-stats';

  static const workoutHistory = '/workout-history';
  static const workoutHowTo = '/workout-howto';

  // ✅ Home14 + Home15
  static const statsShare = '/stats-share';
  static const statsShare2 = '/stats-share-2';

  static const routineDetail = '/routine-detail';
  static const profileMedia = '/profile-media';

  static const home18 = '/home18';
  static const home19 = '/home19';
  static const home20 = '/home20';

  static const home6 = '/home6';
}

class AppRouter {
  final AppState appState;

  AppRouter(this.appState);

  Route<dynamic> onGenerateRoute(RouteSettings settings, AppState appState) {
    switch (settings.name) {
      case AppRoutes.home1:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HomeScreen(appState: appState),
        );

      case AppRoutes.home3:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Home3DiscoverFeed(appState: appState),
        );

      case AppRoutes.home4: {
        final post = settings.arguments as Post?;
        if (post == null) {
          return _errorRoute(settings, "Home4 requires a Post argument.");
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Home4PostDetail(appState: appState, post: post),
        );
      }

      case AppRoutes.home5: {
        final imageUrl = settings.arguments as String?;
        if (imageUrl == null || imageUrl.isEmpty) {
          return _errorRoute(settings, "Home5 requires an imageUrl String.");
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Home5FullImage(imageUrl: imageUrl),
        );
      }

      case AppRoutes.notifications:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => NotificationsScreen(appState: appState),
        );

      case AppRoutes.contacts:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ContactsScreen(appState: appState),
        );

      case AppRoutes.profile: {
        final athlete = settings.arguments as Athlete?;
        if (athlete == null) {
          return _errorRoute(settings, "Profile requires an Athlete argument.");
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ProfileScreen(appState: appState, athlete: athlete),
        );
      }

      case AppRoutes.workoutStats: {
        final title = settings.arguments as String? ?? "Workout Stats";
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => WorkoutStatsScreen(title: title),
        );
      }

      case AppRoutes.statsShare: {
        final title = settings.arguments as String? ?? "Share";
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => StatsShareScreen(title: title),
        );
      }

      case AppRoutes.statsShare2: {
        final title = settings.arguments as String? ?? "Share";
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => StatsShareScreen(title: title),
        );
      }

      case AppRoutes.workoutHistory: {
        final title = settings.arguments as String? ?? "Workout";
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => WorkoutHistoryScreen(title: title, username: ''),
        );
      }

      case AppRoutes.workoutHowTo: {
        final title = settings.arguments as String? ?? "Workout";
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => WorkoutHowToScreen(title: title),
        );
      }

      case AppRoutes.profileMedia: {
        final athlete = settings.arguments as Athlete?;
        if (athlete == null) {
          return _errorRoute(settings, "Home17 requires an Athlete argument.");
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Home17ProfileMedia(appState: appState, athlete: athlete),
        );
      }

      case AppRoutes.home18: {
        final post = settings.arguments as Post?;
        if (post == null) return _errorRoute(settings, "Home18 requires a Post argument.");
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Home18WorkoutDetail(appState: appState, post: post),
        );
      }

      case AppRoutes.home19: {
        final post = settings.arguments as Post?;
        if (post == null) return _errorRoute(settings, "Home19 requires a Post argument.");
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Home19WorkoutDetail(appState: appState, post: post),
        );
      }

      case AppRoutes.home20: {
        final post = settings.arguments as Post?;
        if (post == null) return _errorRoute(settings, "Home20 requires a Post argument.");
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Home20WorkoutDetail(appState: appState, post: post),
        );
      }

      case AppRoutes.home21:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Home21Routine(),
        );

      case AppRoutes.home22:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Home22WarmUp(),
        );

      case AppRoutes.home23: {
        final arg = settings.arguments;
        final title = (arg is String) ? arg : "Warm Up";
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Home23WarmUpDetail(title: title),
        );
      }

      // ✅ REAL Screen24Share (NOW SUPPORTS args)
      case AppRoutes.screen24Share: {
        final arg = settings.arguments;

        String title = "Warm Up";
        String username = "niha";

        if (arg is Map) {
          final t = arg["title"];
          final u = arg["username"];
          if (t is String && t.trim().isNotEmpty) title = t;
          if (u is String && u.trim().isNotEmpty) username = u;
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Home24ShareScreen(title: title, username: username),
        );
      }

      // ✅ IMPORTANT ADD: if someone uses /home24, OPEN SAME Screen24Share with args
      case AppRoutes.home24: {
        final arg = settings.arguments;

        String title = "Warm Up";
        String username = "niha";

        if (arg is Map) {
          final t = arg["title"];
          final u = arg["username"];
          if (t is String && t.trim().isNotEmpty) title = t;
          if (u is String && u.trim().isNotEmpty) username = u;
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Home24ShareScreen(title: title, username: username),
        );
      }

      case AppRoutes.home6: {
        final title = settings.arguments as String? ?? "Bench Press (Barbell)";
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => WorkoutStatsScreen(title: title),
        );
      }

      case AppRoutes.routineDetail: {
        final username = settings.arguments as String? ?? "unknown";
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(_),
              ),
              title: Text("Routine • $username"),
            ),
            body: const Center(
              child: Text(
                "Routine Detail Screen\nTODO: build UI",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      }

      default:
        return _errorRoute(settings, 'Route not found: ${settings.name}');
    }
  }

  MaterialPageRoute _errorRoute(RouteSettings settings, String message) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
