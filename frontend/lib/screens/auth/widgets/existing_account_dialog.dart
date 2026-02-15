import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import '../login_screen.dart';

class ExistingAccountDialog extends StatelessWidget {
  const ExistingAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.black,
      title: const Text(
        "Account already exists",
        style: TextStyle(color: AppColors.orange),
      ),
      content: const Text(
        "An account with this email already exists. Please sign in instead.",
        style: TextStyle(color: AppColors.white),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: AppColors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
          child: const Text(
            "Sign in",
            style: TextStyle(color: AppColors.orange),
          ),
        ),
      ],
    );
  }
}
