import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'widgets/primary_button.dart';
import 'workout_screen.dart';

class HowDidYouHearScreen extends StatefulWidget {
  const HowDidYouHearScreen({super.key});

  @override
  State<HowDidYouHearScreen> createState() => _HowDidYouHearScreenState();
}

class _HowDidYouHearScreenState extends State<HowDidYouHearScreen> {
  final List<String> options = [
    "Strava",
    "TikTok",
    "Influencer",
    "ChatGPT or AI Search",
    "Friends or Family",
    "App Store",
    "Google Search or Web Article",
    "Instagram",
    "Other",
  ];

  final Set<String> selectedOptions = {};

  void toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  Widget optionTile(String text) {
    final bool isSelected = selectedOptions.contains(text);

    return GestureDetector(
      onTap: () => toggleOption(text),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orange : const Color(0xFF2D2C2C),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.black : AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _goNext() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WorkoutScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canContinue = selectedOptions.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _goNext,
            child: const Text(
              "Skip",
              style: TextStyle(color: AppColors.orange),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How did you hear about BearFit?",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: options.map(optionTile).toList(),
              ),
            ),

            PrimaryButton(
              label: "Continue",
              onPressed: canContinue ? _goNext : () {},
            ),
          ],
        ),
      ),
    );
  }
}
