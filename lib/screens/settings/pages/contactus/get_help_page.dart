import 'package:flutter/material.dart';

class GetHelpPage extends StatelessWidget {
  const GetHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1A0F),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text('Get Help'),
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
            hintText:
                'Tell us about any issues you are facing. The more details, the better!',
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
