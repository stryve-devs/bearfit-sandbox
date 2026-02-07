import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _canSend = false;
  bool _isSent = false;
  bool _showSentView = false;
  Timer? _resendTimer;
  int _secondsRemaining = 60;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _emailController.removeListener(_onEmailChanged);
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    final email = _emailController.text.trim();
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    final ok = email.isNotEmpty && emailRegex.hasMatch(email);
    if (ok != _canSend) {
      setState(() => _canSend = ok);
    }
  }

  void _onSend() {
    if (!_canSend) return;
    setState(() {
      _isSent = true;
      _showSentView = true;
      _secondsRemaining = 60;
    });

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining -= 1;
        }
        if (_secondsRemaining <= 0) {
          _resendTimer?.cancel();
          _showSentView = false;
          _isSent = false; // re-enable send
        }
      });
    });

    // No popup shown on send (UI shows the centered "Check your inbox" view)
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
          "Forgot Password",
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
                label: "Email",
                hint: "",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                compact: true,
                useFloatingLabel: true,
              ),

              const SizedBox(height: 16),

              const Text(
                "We’ll send password reset instructions to your email if an account exists.",
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              // If sent, show the inbox view; otherwise show the Send button
              if (_showSentView) ...[
                const SizedBox(height: 30),
                Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Icon(Icons.check, color: Colors.black, size: 28)),
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: Text(
                    'Check your inbox',
                    style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'We sent instructions to ${""}${_emailController.text.trim()}. If you don\'t see it, check your spam folder.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 13),
                  ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: GestureDetector(
                    onTap: _secondsRemaining == 0 ? () {
                      // allow user to resend by showing send button again
                      setState(() {
                        _showSentView = false;
                        _isSent = false;
                      });
                    } : null,
                    child: Text(
                      _secondsRemaining > 0 ? "Didn't get the email? Resend in ${_secondsRemaining}s" : "Didn't get the email? Resend",
                      style: const TextStyle(color: AppColors.orange, decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ] else ...[
                PrimaryButton(
                  label: _isSent ? 'Sent' : 'Send Password Recovery',
                  onPressed: (_canSend && !_isSent) ? _onSend : null,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
