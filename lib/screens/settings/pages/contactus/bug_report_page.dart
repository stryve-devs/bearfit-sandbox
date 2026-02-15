import 'package:flutter/material.dart';

class BugReportPage extends StatelessWidget {
  const BugReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1A0F),
        elevation: 0,
        leading: const BackButton(color: Color(0xFFFF7825)),
        title: const Text('Bug Report'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Send',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: TextField(
          maxLines: null,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Report any bugs you have found...',
            hintStyle: TextStyle(color: Colors.orange),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
            ),
          ),
        ),
      ),
    );
  }
}
