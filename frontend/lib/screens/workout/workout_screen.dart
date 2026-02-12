import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:frontend/constants/colors.dart';
import '../auth/auth_config.dart';
import '../auth/splash_screen.dart';
import '../../services/api_client.dart';
import '../../services/token_service.dart';
import 'protected_test_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        title: const Text(
          "Workout Setup",
          style: TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Workout Screen",
              style: TextStyle(color: AppColors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Make a test POST to /api/me/workouts to exercise auth flow
                final now = DateTime.now().toIso8601String();
                final payload = {
                  'client_id': 'test-${DateTime.now().millisecondsSinceEpoch}',
                  'date': now,
                  'exercises': [],
                };

                debugPrint('[WorkoutScreen] Sending POST to /api/me/workouts');
                final resp = await ApiClient.postWithAuth(context, '/api/me/workouts', body: jsonEncode(payload));
                debugPrint('[WorkoutScreen] POST returned: ${resp == null ? 'null' : resp.statusCode}');
                if (resp == null) return; // handled inside ApiClient (logout)

                if (resp.statusCode == 201 || resp.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('POST succeeded')));
                } else {
                  final msg = resp.body.isNotEmpty ? resp.body : 'Request failed';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                }
              },
              child: const Text('POST to backend (test auth)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProtectedTestScreen()),
                );
              },
              child: const Text('Go to Protected Test'),
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                TokenService.clear();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SplashScreen()), (r) => false);
              },
              child: const Text('Logout (clear tokens)'),
            ),
          ],
        ),
      ),
    );
  }
}
