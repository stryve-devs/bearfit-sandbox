import 'package:flutter/material.dart';

class AppleHealthPage extends StatefulWidget {
  const AppleHealthPage({super.key});

  @override
  State<AppleHealthPage> createState() => _AppleHealthPageState();
}

class _AppleHealthPageState extends State<AppleHealthPage> {
  bool _isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2A1608),
        leading: const BackButton(color: Color(0xFFFF7825)),
        title: const Text(
          'Apple Health',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF2E2E2E),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Apple Health',
                              style: TextStyle(
                                color: Color(0xFFFF7A00),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isConnected = !_isConnected;
                              });
                            },
                            child: Text(
                              _isConnected ? 'Connected' : 'Connect',
                              style: TextStyle(
                                color: _isConnected
                                    ? Colors.green
                                    : Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'By linking Bearfit to Apple Health, you can enable '
                        'Bearfit workouts to automatically be logged to Apple Health. '
                        'Additionally, you can allow Bearfit to read and update your '
                        'body measurements, heart rate, and calorie data in Apple Health.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
