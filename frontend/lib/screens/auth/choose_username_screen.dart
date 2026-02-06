import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

import 'widgets/auth_text_field.dart';
import 'widgets/primary_button.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'select_units_screen.dart';
import 'auth_config.dart';

class ChooseUsernameScreen extends StatefulWidget {
  const ChooseUsernameScreen({super.key});

  @override
  State<ChooseUsernameScreen> createState() => _ChooseUsernameScreenState();
}

class _ChooseUsernameScreenState extends State<ChooseUsernameScreen> {
  final TextEditingController controller = TextEditingController();
  String? errorText;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Choose username",
          style: TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

                  AuthTextField(
                    label: "Username",
                    hint: "",
                    controller: controller,
                    errorText: errorText,
                  ),

              const SizedBox(height: 24),

              PrimaryButton(
                label: "Continue",
                onPressed: () async {
                  setState(() => errorText = null);
                  final username = controller.text.trim();
                  if (username.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a username')),
                    );
                    return;
                  }

                  bool exists = false;
                  try {
                    final uri = Uri.parse('$backendHost/api/username/exists?username=${Uri.encodeComponent(username)}');
                    final resp = await http.get(uri, headers: {'Content-Type': 'application/json'});
                    if (resp.statusCode == 200) {
                      final body = jsonDecode(resp.body) as Map<String, dynamic>;
                      exists = body['exists'] == true;
                    }
                  } catch (_) {}

                  if (exists) {
                    setState(() => errorText = 'A user with that username already exists.');
                    return;
                  }

                  // proceed to next screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SelectUnitsScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
