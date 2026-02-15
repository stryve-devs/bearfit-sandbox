import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Column(
        children: [
          TextField(decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 8),
          TextField(obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () {}, child: const Text('Login')),
        ],
      ),
    );
  }
}
