import 'package:flutter/material.dart';
import '../../widgets/themed_text.dart';
import '../../widgets/auth/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ThemedText('Create an account'),
            SizedBox(height: 16),
            RegisterForm(),
          ],
        ),
      ),
    );
  }
}
