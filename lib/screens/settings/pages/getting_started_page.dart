import 'package:flutter/material.dart';

class GettingStartedPage extends StatelessWidget {
  const GettingStartedPage({super.key});

  static const Color bgBlack = Colors.black;
  static const Color cardGrey = Color(0xFF2E2E2E);
  static const Color accentOrange = Color(0xFFFF8C2B);
  static const Color textGrey = Color(0xFFB5B5B5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Getting Started Guide',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SECTION: Getting started
                      const Text(
                        'Getting started',
                        style: TextStyle(
                          color: accentOrange,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Starting a workout is easy! Just tap “Start Empty Workout” '
                        'and start tracking your sets.',
                        style: TextStyle(color: textGrey, fontSize: 14),
                      ),

                      const SizedBox(height: 32),

                      // EMPTY SPACE FOR IMAGE (INTENTIONAL)
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'Add an exercise to your workout, input the weight and reps '
                        'for each set, and then easily check it off as you complete it.',
                        style: TextStyle(color: textGrey, fontSize: 14),
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        'If you have a workout routine that you do often, you can '
                        'create a “Routine”.',
                        style: TextStyle(color: textGrey, fontSize: 14),
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        'Routines are reusable and save you time by letting you plan '
                        'your workout before going to the gym.',
                        style: TextStyle(color: textGrey, fontSize: 14),
                      ),

                      const SizedBox(height: 40),

                      // SECTION: Creating routines
                      const Text(
                        'Creating routines',
                        style: TextStyle(
                          color: accentOrange,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Just select the exercise you want to perform in your routine '
                        'and optionally add the reps and weight to your sets.',
                        style: TextStyle(color: textGrey, fontSize: 14),
                      ),

                      const SizedBox(height: 28),

                      // EMPTY SPACE FOR IMAGE (INTENTIONAL)
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        'Save your new routine and use it the next time you work out.',
                        style: TextStyle(color: textGrey, fontSize: 14),
                      ),

                      const SizedBox(height: 48),

                      // CHECK ICON + TEXT
                      const Column(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 56,
                            color: accentOrange,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Now get started!',
                            style: TextStyle(
                              color: accentOrange,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // BACK BUTTON
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: cardGrey,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      color: accentOrange,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
