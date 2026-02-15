import 'package:flutter/material.dart';

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          // TODO: wire Apple sign-in
        },
        icon: const Icon(Icons.apple),
        label: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text('Sign in with Apple'),
        ),
      ),
    );
  }
}
