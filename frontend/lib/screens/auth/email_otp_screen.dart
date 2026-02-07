import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'dart:async';
import 'widgets/primary_button.dart';
import 'select_units_screen.dart';
// Network calls removed per request: OTP flows are local-only
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_config.dart';

class EmailOtpScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String username;
  const EmailOtpScreen({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<EmailOtpScreen> createState() => _EmailOtpScreenState();
}

class _EmailOtpScreenState extends State<EmailOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(5, (_) => FocusNode());
  Timer? _resendTimer;
  int _resendSecondsRemaining = 60;
  bool _canResend = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    for (final c in _controllers) {
      c.removeListener(_onOtpControllersChanged);
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    for (final c in _controllers) {
      c.addListener(_onOtpControllersChanged);
    }
  }

  void _onOtpControllersChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() {
      _resendSecondsRemaining = 60;
      _canResend = false;
    });
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_resendSecondsRemaining > 0) {
          _resendSecondsRemaining -= 1;
        }
        if (_resendSecondsRemaining <= 0) {
          _canResend = true;
          _resendTimer?.cancel();
        }
      });
    });
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(1, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _onResendPressed() async {
    if (!_canResend) return;
    // Local resend: no backend call — just notify user and restart timer
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP resent (local)')));
    _startResendTimer();
  }

  void _onChanged(String v, int idx) {
    if (v.isNotEmpty) {
      if (idx < _nodes.length - 1) {
        FocusScope.of(context).requestFocus(_nodes[idx + 1]);
      } else {
        _nodes[idx].unfocus();
      }
    }
  }

  String get _otp => _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Verify Email',
          style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text('Enter the 5-digit code sent to', style: TextStyle(color: AppColors.white)),
            const SizedBox(height: 6),
            Text(widget.email, style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (i) {
                return SizedBox(
                  width: 56,
                  child: TextField(
                    controller: _controllers[i],
                    focusNode: _nodes[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(color: AppColors.white, fontSize: 20),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: const Color(0xFF2D2C2C),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                    onChanged: (v) => _onChanged(v, i),
                  ),
                );
              }),
            ),

            const SizedBox(height: 36),
            const SizedBox(height: 12),
            const Text("Didn't receive the code? Request a new one", style: TextStyle(color: AppColors.white, fontSize: 12)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: Container()),
              _canResend
                  ? TextButton(
                      onPressed: _onResendPressed,
                      child: const Text('Resend OTP', style: TextStyle(color: AppColors.orange)),
                    )
                  : Text('Resend in ${_formatDuration(_resendSecondsRemaining)}', style: const TextStyle(color: AppColors.grey, fontSize: 12)),
            ]),
            const Spacer(),

            PrimaryButton(
              label: 'Verify',
              onPressed: _controllers.every((c) => c.text.trim().length == 1) && !_isSubmitting
                  ? () async {
                      setState(() => _isSubmitting = true);
                      try {
                        final uri = Uri.parse('$backendHost/api/auth/register');
                        final resp = await http.post(
                          uri,
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({
                            'name': widget.name,
                            'email': widget.email,
                            'password': widget.password,
                            'username': widget.username,
                          }),
                        );

                        if (resp.statusCode < 200 || resp.statusCode >= 300) {
                          String message = 'Registration failed.';
                          try {
                            final body = jsonDecode(resp.body) as Map<String, dynamic>;
                            if (body['message'] is String) message = body['message'] as String;
                          } catch (_) {}
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          }
                          return;
                        }

                        if (!mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const SelectUnitsScreen()),
                        );
                      } catch (_) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Registration failed. Please try again.')),
                          );
                        }
                      } finally {
                        if (mounted) setState(() => _isSubmitting = false);
                      }
                    }
                  : null,
              backgroundColor: _controllers.every((c) => c.text.trim().length == 1) && !_isSubmitting
                  ? null
                  : const Color(0xFF555555),
              foregroundColor: _controllers.every((c) => c.text.trim().length == 1) && !_isSubmitting
                  ? null
                  : Colors.white,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
