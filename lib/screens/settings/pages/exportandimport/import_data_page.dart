import 'package:flutter/material.dart';

class ImportDataPage extends StatelessWidget {
  const ImportDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2A1608),
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Import Data',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Importing Workout Data',
              style: TextStyle(
                color: Color(0xFFFF7A00),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'We currently only support importing data from the Strong app.\n\n'
              'Please note you can only do one data import.\n\n'
              'If you have performed a data import and wish to remove imported data, '
              'you will be allowed to revert back and remove imported data.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),
            const Text(
              'Importing Strong Workouts',
              style: TextStyle(
                color: Color(0xFFFF7A00),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '1. Open Strong app\n'
              '2. Go to Settings > Export Strong Data\n'
              '3. Save CSV to device\n'
              '4. Open Bearfit app\n'
              '5. Tap on "Import Strong CSV"\n'
              '6. Select exported CSV file\n'
              '7. Wait while data is imported',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF2E2E2E),
                borderRadius: BorderRadius.circular(22),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Import Strong CSV',
                style: TextStyle(
                  color: Color(0xFFFF7A00),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
