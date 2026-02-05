import 'package:flutter/material.dart';

class RoutineHelpPage extends StatelessWidget {
  const RoutineHelpPage({super.key});

  static const Color bgBlack = Colors.black;
  static const Color cardGrey = Color(0xFF2E2E2E);
  static const Color accentOrange = Color(0xFFFF8C32);
  static const Color textGrey = Color(0xFFB0B0B0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A170A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Routine Help',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Paragraph(
                      text:
                          'Routines are reusable and save you time by letting you plan your workout before going to the gym.',
                    ),

                    SizedBox(height: 48), // empty space for screenshots

                    _Paragraph(
                      text:
                          'Input your planned weight & reps for your routine ahead of time, or leave it blank to workout on the go.',
                    ),

                    SizedBox(height: 48), // empty space for screenshots

                    _Paragraph(
                      text:
                          'Add notes per exercise to always have them handy during your workout.',
                    ),

                    SizedBox(height: 48), // empty space for screenshots

                    _Paragraph(
                      text:
                          'Set automatic rest timers to have some rest time between sets.',
                    ),
                  ],
                ),
              ),
            ),

            // BACK BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  color: cardGrey,
                  borderRadius: BorderRadius.circular(28),
                ),
                alignment: Alignment.center,
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

            // BOTTOM NAV SPACER (visual only, matches design)
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;

  const _Paragraph({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: RoutineHelpPage.textGrey,
        fontSize: 15,
        height: 1.6,
      ),
    );
  }
}
