import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/screens/auth/widgets/primary_button.dart';

import 'how_did_you_hear_screen.dart';

class SpamScreen extends StatelessWidget {
  const SpamScreen({super.key});

  void _goNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HowDidYouHearScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),

            const Icon(
              Icons.mail_outline,
              color: AppColors.orange,
              size: 60,
            ),

            const SizedBox(height: 20),

            const Text(
              "Can we send you emails?\nNo spam, promise. We hate it too.",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            const Text(
              "• Tips for getting the most out of BearFit\n"
              "• New feature announcements\n"
              "• Promotion offers\n"
              "• Opt out anytime",
              style: TextStyle(
                color: Color(0xFFBDBDBD),
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            PrimaryButton(
              label: "Sure",
              onPressed: () => _goNext(context),
            ),

            const SizedBox(height: 12),

            GestureDetector(
              onTap: () => _goNext(context),
              child: const Text(
                "No, thanks",
                style: TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
