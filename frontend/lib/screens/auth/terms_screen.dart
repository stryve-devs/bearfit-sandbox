import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Terms and Conditions",
          style: TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: const Text(
          '''
Terms and Conditions of BearFit

Welcome to BearFit.

By downloading or using this app, you agree to the following terms and conditions.

1. Acceptance of Terms
By accessing BearFit, you agree to be bound by these Terms.

2. Use of the App
You agree to use the app only for lawful and personal fitness-related purposes.

3. User Accounts
You are responsible for maintaining the security of your account.

4. Health Disclaimer
BearFit does not provide medical advice. Always consult a professional.

5. Data & Privacy
Your data is handled according to our Privacy Policy.

6. Limitation of Liability
We are not responsible for any injuries or losses caused by workouts.

7. Termination
We may suspend or terminate accounts that violate these terms.

These terms may be updated periodically.
''',
          style: TextStyle(
            color: Color(0xFFB0B0B0),
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
