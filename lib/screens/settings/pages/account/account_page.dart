import 'package:flutter/material.dart';
import 'change_username_page.dart';
import 'change_email_page.dart';
import 'update_password_page.dart';
import 'delete_account_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  static const Color orange = Color(0xFFFF7825);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C120A),
        elevation: 0,
        leading: const BackButton(color: orange),
        title: const Text(
          'Account Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildTile(
            context,
            icon: Icons.person_outline,
            title: 'Change Username',
            page: const ChangeUsernamePage(),
          ),
          _buildTile(
            context,
            icon: Icons.email_outlined,
            title: 'Change Email',
            page: const ChangeEmailPage(),
          ),
          _buildTile(
            context,
            icon: Icons.lock_outline,
            title: 'Update Password',
            page: const UpdatePasswordPage(),
          ),
          _buildTile(
            context,
            icon: Icons.delete_outline,
            title: 'Delete Account',
            page: const DeleteAccountPage(),
            isDelete: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
    bool isDelete = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDelete ? Colors.red : orange,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDelete ? Colors.red : Colors.white,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.white54,
        ),
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
