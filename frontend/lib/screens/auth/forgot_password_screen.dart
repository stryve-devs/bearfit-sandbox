import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/primary_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
          "Forgot Password",
          style: TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              const AuthTextField(
                label: "Email",
                hint: "example@gmail.com",
              ),

              const SizedBox(height: 16),

              const Text(
                "Enter your email above and if an account exists we will send you an email with a link to recover your password",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                label: "Send Password Recovery",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
