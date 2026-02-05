import 'package:flutter/material.dart';
import '../widgets/change_picture_sheet.dart';
import '../widgets/select_option_sheet.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _openSheet(BuildContext context, Widget sheet) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => sheet,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C120A),
        elevation: 0,
        leading: const BackButton(color: Colors.orange),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.orange, fontSize: 15),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Done',
                style: TextStyle(color: Colors.orange, fontSize: 13),
              ),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white24,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _openSheet(
                  context,
                  const ChangePictureSheet(),
                ),
                child: const Text(
                  'Change Picture',
                  style: TextStyle(color: Colors.blue, fontSize: 13),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _section('Public profile data'),
          _input('Name', 'Your full name'),
          _input('Bio', 'Describe yourself'),
          _input('Link', 'https://example.com'),

          const SizedBox(height: 24),

          _section('Private data'),
          _select(
            context,
            'Sex',
            () => _openSheet(
              context,
              const SelectOptionSheet(
                title: 'Select your gender',
                options: ['Male', 'Female', 'Rather not say'],
              ),
            ),
          ),
          _select(
            context,
            'Birthday',
            () => _openSheet(
              context,
              const SelectOptionSheet(
                title: 'Enter your birthday',
                options: ['Submit'],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _input(String label, String hint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white24)),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _select(BuildContext context, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white24)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Select', style: TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
