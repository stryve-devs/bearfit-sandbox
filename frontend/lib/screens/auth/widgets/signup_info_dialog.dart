import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

class SignupInfoDialog extends StatelessWidget {
  const SignupInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth * 0.9;
    final dialogWidth = contentWidth < 560.0 ? contentWidth : 560.0;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: dialogWidth,
          constraints: const BoxConstraints(minHeight: 80),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF161515),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Why we ask this?',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w700, fontSize: 20),
              ),
              const SizedBox(height: 8),
              const Text(
                'We use your details only to personalize your fitness experience. '
                'Your data is safe and never shared.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A3A3A),
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Got it'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
