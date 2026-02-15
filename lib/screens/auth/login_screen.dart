import 'package:flutter/material.dart';
import '../../widgets/themed_text.dart';
import '../../widgets/auth/login_form.dart';
import 'widgets/google_sign_in_button.dart';
import 'widgets/apple_sign_in_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ThemedText('Sign in to your account'),
              const SizedBox(height: 16),
              const LoginForm(),
              const SizedBox(height: 16),
              const Text('Or continue with'),
              const SizedBox(height: 12),
              const GoogleSignInButton(),
              const SizedBox(height: 8),
              const AppleSignInButton(),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/auth/register'),
                child: const Text('Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
