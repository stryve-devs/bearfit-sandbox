import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.grey),
        ),
        onPressed: () {
          // TODO: wire Google sign-in
        },
        icon: Image.network(
          'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
          width: 20,
          height: 20,
        ),
        label: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
