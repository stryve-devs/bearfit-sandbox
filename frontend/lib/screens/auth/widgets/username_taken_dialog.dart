import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

class UsernameTakenDialog extends StatelessWidget {
  const UsernameTakenDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.black,
      title: const Text(
        'Username taken',
        style: TextStyle(color: AppColors.orange),
      ),
      content: const Text(
        'This username is already taken. Please choose another one.',
        style: TextStyle(color: AppColors.white),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK', style: TextStyle(color: AppColors.orange)),
        ),
      ],
    );
  }
}
