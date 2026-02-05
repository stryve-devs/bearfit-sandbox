import 'package:flutter/material.dart';

class ChangePictureSheet extends StatelessWidget {
  const ChangePictureSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          _item(Icons.camera_alt, 'Take Photo', Colors.orange),
          _item(Icons.photo_library, 'Select Library Photo', Colors.orange),
          _item(Icons.delete, 'Delete Profile Picture', Colors.red),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(color: color, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
