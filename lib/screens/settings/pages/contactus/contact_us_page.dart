import 'package:flutter/material.dart';
import 'feature_request_page.dart';
import 'bug_report_page.dart';
import 'get_help_page.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1A0F),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text('Contact Us'),
      ),
      body: Column(
        children: [
          _item(
            context,
            icon: Icons.lightbulb_outline,
            title: 'Feature Request',
            page: const FeatureRequestPage(),
          ),
          _item(
            context,
            icon: Icons.bug_report_outlined,
            title: 'Bug Report',
            page: const BugReportPage(),
          ),
          _item(
            context,
            icon: Icons.help_outline,
            title: 'Get Help',
            page: const GetHelpPage(),
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: const BoxDecoration(
          color: Color(0xFF2E2E2E),
          border: Border(bottom: BorderSide(color: Colors.black)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
