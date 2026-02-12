import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:frontend/constants/colors.dart';
import '../../services/api_client.dart';

class ProtectedTestScreen extends StatefulWidget {
  const ProtectedTestScreen({super.key});

  @override
  State<ProtectedTestScreen> createState() => _ProtectedTestScreenState();
}

class _ProtectedTestScreenState extends State<ProtectedTestScreen> {
  String _result = 'No request made yet';
  bool _loading = false;

  Future<void> _callProtected() async {
    // Do not change button state or text so the button can be spammed repeatedly.
    // Only update the visible result area.
    try {
      final resp = await ApiClient.getWithAuth(context, '/api/me');
      if (resp == null) {
        setState(() {
          _result = 'No response (likely logged out)';
        });
      } else if (resp.statusCode == 200) {
        setState(() {
          _result = resp.body.isNotEmpty ? resp.body : 'OK (empty body)';
        });
      } else {
        setState(() {
          _result = 'Error ${resp.statusCode}: ${resp.body}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Request failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        title: const Text('Protected Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _callProtected,
              child: const Text('Call GET /api/me'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_result, style: const TextStyle(color: AppColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
