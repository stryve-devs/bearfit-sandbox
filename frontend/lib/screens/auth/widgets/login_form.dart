import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth/auth_config.dart';
import '../../workout/workout_screen.dart';
import '../../../services/auth/token_service.dart';

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

  Future<void> _onLogin() async {
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter email and password')));
      return;
    }

    try {
      // 1) Check email exists
      final existsUri = Uri.parse('$backendHost/api/auth/exists?email=${Uri.encodeComponent(email)}');
      final existsResp = await http.get(existsUri, headers: {'Content-Type': 'application/json'});
      if (existsResp.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to check email')));
        return;
      }
      final existsBody = jsonDecode(existsResp.body) as Map<String, dynamic>;
      final exists = existsBody['exists'] == true;
      if (!exists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email does not exist')));
        return;
      }

      // 2) Attempt login
      final loginUri = Uri.parse('$backendHost/api/auth/login');
      final loginResp = await http.post(
        loginUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (loginResp.statusCode == 200) {
        // Save tokens then navigate to WorkoutScreen
        final body = jsonDecode(loginResp.body) as Map<String, dynamic>;
        final access = body['accessToken'] as String?;
        final refresh = body['refreshToken'] as String?;
        if (access != null && refresh != null) {
          TokenService.setTokens(accessToken: access, refreshToken: refresh);
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WorkoutScreen()),
        );
        return;
      }

      // Handle known errors
      if (loginResp.statusCode == 401) {
        final body = (loginResp.body.isNotEmpty) ? jsonDecode(loginResp.body) : null;
        final msg = body != null && body['message'] != null ? body['message'] : 'Wrong password';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        return;
      }

      // Other failures
      final body = (loginResp.body.isNotEmpty) ? jsonDecode(loginResp.body) : null;
      final msg = body != null && body['message'] != null ? body['message'] : 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error')));
    }
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
