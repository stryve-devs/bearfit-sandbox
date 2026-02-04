import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/screens/auth/widgets/primary_button.dart';
import 'widgets/google_sign_in_button.dart';
import 'signup_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const GoogleSignInButton(),
              const SizedBox(height: 12),

              PrimaryButton(
                label: "Sign up with Apple",
                backgroundColor: AppColors.grey,
                foregroundColor: AppColors.white,
                onPressed: () {},
              ),
              const SizedBox(height: 12),

              PrimaryButton(
                label: "Sign up with Email",
                backgroundColor: AppColors.grey,
                foregroundColor: AppColors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignupScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    text: "Already have an account?\n",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: "Log in",
                        style: TextStyle(
                          color: AppColors.orange,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
