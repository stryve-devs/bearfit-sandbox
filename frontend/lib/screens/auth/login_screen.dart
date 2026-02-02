import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

import 'package:frontend/screens/auth/widgets/login_form.dart';
import 'package:frontend/screens/auth/widgets/google_sign_in_button.dart';
import 'package:frontend/screens/auth/widgets/apple_sign_in_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Login',
          style: TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sign in to your account',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),
              const LoginForm(),

              const SizedBox(height: 16),
              const Text(
                'Or continue with',
                style: TextStyle(color: AppColors.grey),
              ),

              const SizedBox(height: 12),
              const GoogleSignInButton(),
              const SizedBox(height: 8),
              const AppleSignInButton(),

              const SizedBox(height: 16),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/register'),
                child: const Text(
                  'Create an account',
                  style: TextStyle(color: AppColors.orange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
