import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

import 'auth_text_field.dart';
import 'primary_button.dart';
import '../forgot_password_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login pressed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          label: 'Email',
          hint: '',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          compact: true,
          useFloatingLabel: true,
        ),

        const SizedBox(height: 12),

        AuthTextField(
          label: 'Password',
          hint: '',
          controller: _passwordController,
          compact: true,
          obscureText: _obscurePassword,
          useFloatingLabel: true,
          suffix: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: AppColors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),

        const SizedBox(height: 2),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
              );
            },
            child: const Text(
              'Forgot password?',
              style: TextStyle(
                color: AppColors.orange,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: PrimaryButton(
            label: 'Login',
            onPressed: _onLogin,
          ),
        ),
      ],
    );
  }
}
