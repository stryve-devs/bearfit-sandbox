import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Column(
        children: [
          const TextField(decoration: InputDecoration(labelText: 'Name')),
          const TextField(decoration: InputDecoration(labelText: 'Email')),
          const SizedBox(height: 8),
          const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password')),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () {}, child: const Text('Register')),
        ],
      ),
    );
  }
}
