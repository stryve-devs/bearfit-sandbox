import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

import '../state/app_state.dart';
import '../data/mock_data.dart';

class BearFitApp extends StatefulWidget {
  const BearFitApp({super.key});

  @override
  State<BearFitApp> createState() => _BearFitAppState();
}

class _BearFitAppState extends State<BearFitApp> {
  late final AppState appState;

  @override
  void initState() {
    super.initState();

    appState = AppState(
      athletes: mockAthletes,
      posts: mockPosts,
      notifications: mockNotifications,
      contacts: mockContacts,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (_, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BearFit',
          theme: AppTheme.darkTheme,
          onGenerateRoute: (settings) =>
              AppRouter(appState).onGenerateRoute(settings, appState),
          initialRoute: AppRoutes.home1,
        );
      },
    );
  }
}
