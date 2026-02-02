import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

import 'spam_screen.dart';
import 'widgets/primary_button.dart';

class AppleHealthScreen extends StatelessWidget {
  const AppleHealthScreen({super.key});

  void _goToSpam(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SpamScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Apple Health",
          style: TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),

            const Text(
              "Enable permissions in Apple Health so BearFit can read and report data about your workouts and measurements.",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            PrimaryButton(
              label: "Enable Apple Health",
              onPressed: () => _goToSpam(context),
            ),

            const SizedBox(height: 12),

            GestureDetector(
              onTap: () => _goToSpam(context),
              child: const Text(
                "Not now",
                style: TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
