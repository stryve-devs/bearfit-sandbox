import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

class SignupInfoDialog extends StatelessWidget {
  const SignupInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.black,
      title: const Text(
        "Why we ask this?",
        style: TextStyle(color: AppColors.orange),
      ),
      content: const Text(
        "We use your details only to personalize your fitness experience. "
        "Your data is safe and never shared.",
        style: TextStyle(color: AppColors.white),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Got it",
            style: TextStyle(color: AppColors.orange),
          ),
        ),
      ],
    );
  }
}
