import 'package:flutter/material.dart';
import 'change_username_page.dart';
import 'change_email_page.dart';
import 'update_password_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  static const Color accent = Color(0xFFFF7A00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Account Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          _tile(
            context,
            icon: Icons.person_outline,
            title: 'Change Username',
            page: const ChangeUsernamePage(),
          ),
          _tile(
            context,
            icon: Icons.email_outlined,
            title: 'Change Email',
            page: const ChangeEmailPage(),
          ),
          _tile(
            context,
            icon: Icons.lock_outline,
            title: 'Update Password',
            page: const UpdatePasswordPage(),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: accent),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      ),
    );
  }
}
