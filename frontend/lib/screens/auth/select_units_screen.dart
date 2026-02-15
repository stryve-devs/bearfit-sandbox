import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/screens/auth/widgets/primary_button.dart';

import 'apple_health_screen.dart';

class SelectUnitsScreen extends StatefulWidget {
  const SelectUnitsScreen({super.key});

  @override
  State<SelectUnitsScreen> createState() => _SelectUnitsScreenState();
}

class _SelectUnitsScreenState extends State<SelectUnitsScreen> {
  String weightUnit = 'kg';
  String distanceUnit = 'km';
  String bodyUnit = 'cm';

  Widget unitButton(String text, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.orange : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: selected ? AppColors.orange : AppColors.grey,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.black : AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
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
          "Select units",
          style: TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Weight",
              style: TextStyle(color: AppColors.white),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                unitButton("kg", weightUnit == 'kg', () {
                  setState(() => weightUnit = 'kg');
                }),
                const SizedBox(width: 12),
                unitButton("lb", weightUnit == 'lb', () {
                  setState(() => weightUnit = 'lb');
                }),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Distance",
              style: TextStyle(color: AppColors.white),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                unitButton("kilometers", distanceUnit == 'km', () {
                  setState(() => distanceUnit = 'km');
                }),
                const SizedBox(width: 12),
                unitButton("miles", distanceUnit == 'mi', () {
                  setState(() => distanceUnit = 'mi');
                }),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Body Measurements",
              style: TextStyle(color: AppColors.white),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                unitButton("centimeters", bodyUnit == 'cm', () {
                  setState(() => bodyUnit = 'cm');
                }),
                const SizedBox(width: 12),
                unitButton("inches", bodyUnit == 'in', () {
                  setState(() => bodyUnit = 'in');
                }),
              ],
            ),

            const Spacer(),

            PrimaryButton(
              label: "Continue",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AppleHealthScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
