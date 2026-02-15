import 'package:flutter/material.dart';

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D2C2C),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          )
        ),
        onPressed: () {
          // TODO: wire Apple sign-in
        },
        icon: const Icon(Icons.apple, size: 35),
        label: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text('Sign in with Apple'),
        ),
      ),
    );
  }
}
