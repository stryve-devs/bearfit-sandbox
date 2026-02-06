import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

import 'widgets/auth_text_field.dart';
import 'widgets/primary_button.dart';

import 'terms_screen.dart';
import 'select_units_screen.dart';
import 'widgets/signup_info_dialog.dart';
import 'widgets/google_sign_up_button.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'auth_config.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController usernameController = TextEditingController();
  String? usernameError;

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

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
          "Sign Up",
          style: TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const SignupInfoDialog(),
              );
            },
          ),
        ],
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

              const AuthTextField(
                label: "Password",
                hint: "minimum 6 characters",
                obscureText: true,
              ),

              AuthTextField(
                label: "Username",
                hint: "username",
                controller: usernameController,
                errorText: usernameError,
              ),

              const SizedBox(height: 10),

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text(
                      "By clicking continue, you agree to our ",
                      style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TermsScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Terms of Service",
                        style: TextStyle(
                          color: AppColors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                label: "Continue",
                onPressed: () async {
                  setState(() => usernameError = null);
                  final username = usernameController.text.trim();
                  if (username.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a username')),
                    );
                    return;
                  }

                  bool exists = false;
                  try {
                    final uri = Uri.parse('$backendHost/api/username/exists?username=${Uri.encodeComponent(username)}');
                    final resp = await http.get(uri, headers: {'Content-Type': 'application/json'});
                    if (resp.statusCode == 200) {
                      final body = jsonDecode(resp.body) as Map<String, dynamic>;
                      exists = body['exists'] == true;
                    }
                  } catch (_) {}

                  if (exists) {
                    setState(() => usernameError = 'A user with that username already exists.');
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SelectUnitsScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
              // Google sign-up button (kept as original)
              const GoogleSignUpButton(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
