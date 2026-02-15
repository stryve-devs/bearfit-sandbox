import 'package:flutter/material.dart';

class UnitsPage extends StatefulWidget {
  const UnitsPage({super.key});

  @override
  State<UnitsPage> createState() => _UnitsPageState();
}

class _UnitsPageState extends State<UnitsPage> {
  String weightUnit = 'kg';
  String distanceUnit = 'km';
  String bodyUnit = 'cm';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Color(0xFFFF7825)),
        title: const Text(
          'Select Units',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _sectionTitle('Weight'),
            const SizedBox(height: 10),
            _unitRow(
              selected: weightUnit,
              leftLabel: 'kg',
              rightLabel: 'lbs',
              onLeftTap: () => setState(() => weightUnit = 'kg'),
              onRightTap: () => setState(() => weightUnit = 'lbs'),
            ),
            const SizedBox(height: 24),
            _sectionTitle('Distance'),
            const SizedBox(height: 10),
            _unitRow(
              selected: distanceUnit,
              leftLabel: 'kilometers',
              rightLabel: 'miles',
              onLeftTap: () => setState(() => distanceUnit = 'km'),
              onRightTap: () => setState(() => distanceUnit = 'miles'),
            ),
            const SizedBox(height: 24),
            _sectionTitle('Body Measurements'),
            const SizedBox(height: 10),
            _unitRow(
              selected: bodyUnit,
              leftLabel: 'cm',
              rightLabel: 'in',
              onLeftTap: () => setState(() => bodyUnit = 'cm'),
              onRightTap: () => setState(() => bodyUnit = 'in'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _unitRow({
    required String selected,
    required String leftLabel,
    required String rightLabel,
    required VoidCallback onLeftTap,
    required VoidCallback onRightTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: _unitButton(
            label: leftLabel,
            isSelected: selected == leftLabel ||
                (leftLabel == 'kilometers' && selected == 'km'),
            onTap: onLeftTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _unitButton(
            label: rightLabel,
            isSelected: selected == rightLabel,
            onTap: onRightTap,
          ),
        ),
      ],
    );
  }

  Widget _unitButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF7A00) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF7A00) : Colors.white24,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
