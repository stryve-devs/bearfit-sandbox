import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const Color bgBlack = Colors.black;
  static const Color orange = Colors.orange;
  static const Color appBarBrown = Color(0xFF2B1A0F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      appBar: AppBar(
        backgroundColor: appBarBrown,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text('About'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),

          // 🐻 BEAR ICON
          const Icon(
            Icons.pets,
            size: 70,
            color: orange,
          ),

          const SizedBox(height: 30),

          _sectionTitle('Social'),
          _linkText('Instagram'),
          _linkText('Facebook'),
          _linkText('Twitter'),

          const SizedBox(height: 24),

          _sectionTitle('Contact'),
          _underlineLink('hello@bearfit.com'),

          const SizedBox(height: 24),

          _sectionTitle('Policies'),
          _linkText('Privacy Policy'),
          _linkText('Terms & Conditions'),

          const SizedBox(height: 24),

          _linkText('Acknowledgements'),

          const SizedBox(height: 16),

          const Text(
            'Version: 2.5.10 - (1880052)',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _linkText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _underlineLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 16,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
