import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

import 'widgets/auth_text_field.dart';
import 'widgets/primary_button.dart';

import 'terms_screen.dart';
import 'select_units_screen.dart';
import 'widgets/signup_info_dialog.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'auth_config.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController usernameController = TextEditingController();
  String? usernameError;
  late FocusNode usernameFocusNode;
  bool showUsernameCriteria = false;
  bool? usernameAvailable;
  Timer? _usernameDebounce;
  final TextEditingController emailController = TextEditingController();
  String? emailError;
  final TextEditingController passwordController = TextEditingController();
  String? passwordError;
  late FocusNode passwordFocusNode;
  bool _obscurePassword = true;
  bool showPasswordCriteria = false;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(_onPasswordChanged);
    passwordFocusNode = FocusNode();
    passwordFocusNode.addListener(() { if (mounted) setState(() {}); });
    usernameFocusNode = FocusNode();
    usernameFocusNode.addListener(() { if (mounted) setState(() {}); });
    usernameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.removeListener(_onPasswordChanged);
    passwordController.dispose();
    passwordFocusNode.removeListener(() { if (mounted) setState(() {}); });
    passwordFocusNode.dispose();
    usernameController.removeListener(_onUsernameChanged);
    usernameFocusNode.removeListener(() { if (mounted) setState(() {}); });
    usernameFocusNode.dispose();
    _usernameDebounce?.cancel();
    usernameController.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    if (mounted) {
      // clear the inline error when user starts editing
      if (passwordError != null) passwordError = null;
      if (showPasswordCriteria) showPasswordCriteria = false;
      setState(() {});
    }
  }

  void _onUsernameChanged() {
    if (mounted) {
      if (usernameError != null) usernameError = null;
      usernameAvailable = null;
      // hide criteria when typing unless explicitly shown
      if (showUsernameCriteria) showUsernameCriteria = false;
      setState(() {});
    }

    _usernameDebounce?.cancel();
    _usernameDebounce = Timer(const Duration(milliseconds: 700), () async {
      final value = usernameController.text.trim();
      // basic validation before hitting backend
      final allowed = RegExp(r'^[A-Za-z0-9_.-]+$');
      if (value.length >= 6 && value.length <= 15 && allowed.hasMatch(value)) {
        try {
          final uri = Uri.parse('$backendHost/api/username/exists?username=${Uri.encodeComponent(value)}');
          final resp = await http.get(uri, headers: {'Content-Type': 'application/json'});
          if (resp.statusCode == 200) {
            final body = jsonDecode(resp.body) as Map<String, dynamic>;
            if (mounted) setState(() => usernameAvailable = !(body['exists'] == true));
          }
        } catch (_) {}
      }
    });
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
          "Sign Up",
          style: TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
            IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.white),
            onPressed: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: 'SignupInfo',
                barrierColor: Colors.black54,
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (ctx, anim1, anim2) => const SignupInfoDialog(),
              );
            },
          ),
        ],
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
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                compact: true,
                useFloatingLabel: true,
                errorText: emailError,
              ),

              AuthTextField(
                label: "Password",
                hint: "",
                controller: passwordController,
                focusNode: passwordFocusNode,
                compact: true,
                obscureText: _obscurePassword,
                useFloatingLabel: true,
                errorText: passwordError,
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.grey,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),

              // Live password criteria checklist (visible when field focused or when there is a password error)
              Builder(builder: (context) {
                final pwd = passwordController.text;
                final showCriteria = passwordFocusNode.hasFocus || passwordError != null || showPasswordCriteria;
                if (!showCriteria) return const SizedBox.shrink();
                final lengthOk = pwd.length >= 8 && pwd.length <= 32;
                final hasUpper = RegExp(r'[A-Z]').hasMatch(pwd);
                final hasLower = RegExp(r'[a-z]').hasMatch(pwd);
                final hasDigit = RegExp(r'\d').hasMatch(pwd);
                final allowedSpecials = <String>{
                  '!', '@', '#', r'$', '%', '^', '&', '*', '(', ')', '_', '+', '-', '=', '[', ']', '{', '}',
                  ';', ':', "'", '"', ',', '.', '<', '>', '?', '/',
                };
                final hasAllowedSpecial = pwd.runes
                    .map((r) => String.fromCharCode(r))
                    .any((ch) => allowedSpecials.contains(ch));
                final invalidChars = <String>{};
                for (final r in pwd.runes) {
                  final ch = String.fromCharCode(r);
                  final isAlnum = RegExp(r'[A-Za-z0-9]').hasMatch(ch);
                  if (isAlnum) continue;
                  if (allowedSpecials.contains(ch)) continue;
                  invalidChars.add(ch);
                }

                Widget row(bool ok, String text) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(ok ? Icons.check_circle : Icons.cancel,
                            size: 16, color: ok ? Colors.green : Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            text,
                            softWrap: true,
                            style: TextStyle(
                                color: ok ? Colors.green : Colors.red,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    );

                return Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (invalidChars.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(Icons.cancel, size: 16, color: Colors.red),
                            const SizedBox(width: 8),
                            Text('Invalid character(s): ${invalidChars.join(' ')}',
                                style: const TextStyle(color: Colors.red, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      row(lengthOk, '8–32 characters'),
                      const SizedBox(height: 4),
                      row(hasUpper, 'At least 1 uppercase letter (A–Z)'),
                      const SizedBox(height: 4),
                      row(hasLower, 'At least 1 lowercase letter (a–z)'),
                      const SizedBox(height: 4),
                      row(hasDigit, 'At least 1 number (0–9)'),
                      const SizedBox(height: 4),
                      row(hasAllowedSpecial, 'At least 1 special character (!@#...)'),
                    ],
                  ),
                );
              }),

              AuthTextField(
                label: "Username",
                hint: "",
                controller: usernameController,
                focusNode: usernameFocusNode,
                errorText: usernameError,
                compact: true,
                useFloatingLabel: true,
              ),
              // Live username criteria checklist (visible when focused or after failed Continue)
              Builder(builder: (context) {
                final uname = usernameController.text.trim();
                final showUCriteria = usernameFocusNode.hasFocus || showUsernameCriteria;
                if (!showUCriteria) return const SizedBox.shrink();

                final lengthOk = uname.length >= 6 && uname.length <= 15;
                final allowed = RegExp(r'^[A-Za-z0-9_.-]+$');
                final charsOk = uname.isNotEmpty && allowed.hasMatch(uname);
                final invalidChars = <String>{};
                for (final r in uname.runes) {
                  final ch = String.fromCharCode(r);
                  if (RegExp(r'[A-Za-z0-9_.-]').hasMatch(ch)) continue;
                  invalidChars.add(ch);
                }

                Widget row(bool ok, String text) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(ok ? Icons.check_circle : Icons.cancel,
                            size: 16, color: ok ? Colors.green : Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            text,
                            softWrap: true,
                            style: TextStyle(
                                color: ok ? Colors.green : Colors.red,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    );

                Widget availabilityRow() {
                  if (uname.isEmpty) return const SizedBox.shrink();
                  if (usernameAvailable == null) {
                    // checking
                    return Row(children: const [
                      SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 8),
                      Text('Checking availability...', style: TextStyle(color: AppColors.grey, fontSize: 12)),
                    ]);
                  }
                  return row(usernameAvailable == true, usernameAvailable == true ? 'Username available' : 'Username taken');
                }

                return Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    if (invalidChars.isNotEmpty) ...[
                      Row(children: [
                        const Icon(Icons.cancel, size: 16, color: Colors.red),
                        const SizedBox(width: 8),
                        Text('Invalid character(s): ${invalidChars.join(' ')}',
                            style: const TextStyle(color: Colors.red, fontSize: 12)),
                      ]),
                      const SizedBox(height: 8),
                    ],
                    row(lengthOk, '6–15 characters'),
                    const SizedBox(height: 4),
                    row(charsOk, 'Allowed: letters, numbers, _ . -'),
                    const SizedBox(height: 4),
                    availabilityRow(),
                  ]),
                );
              }),
              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  children: [
                    const Text(
                      'By continuing you agree to our',
                      style: TextStyle(color: AppColors.white, fontSize: 12),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TermsScreen()),
                        );
                      },
                      child: const Text(
                        'Terms of Service',
                        style: TextStyle(
                          color: AppColors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                label: "Continue",
                onPressed: () async {
                  setState(() {
                    usernameError = null;
                    emailError = null;
                    passwordError = null;
                  });
                  final email = emailController.text.trim();
                  final username = usernameController.text.trim();
                  final password = passwordController.text;

                  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                  if (email.isEmpty || !emailRegex.hasMatch(email)) {
                    setState(() => emailError = 'Please enter a valid email address.');
                    return;
                  }

                  // Password validations (show checklist rather than repeating explicit errors)
                  if (password.isEmpty) {
                    setState(() {
                      showPasswordCriteria = true;
                      passwordError = null;
                    });
                    return;
                  }
                  if (password.length < 8 || password.length > 32) {
                    setState(() {
                      showPasswordCriteria = true;
                      passwordError = null;
                    });
                    return;
                  }

                  final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
                  final hasLower = RegExp(r'[a-z]').hasMatch(password);
                  final hasDigit = RegExp(r'\d').hasMatch(password);
                  final allowedSpecials = <String>{
                    '!', '@', '#', r'$', '%', '^', '&', '*', '(', ')', '_', '+', '-', '=', '[', ']', '{', '}',
                    ';', ':', "'", '"', ',', '.', '<', '>', '?', '/',
                  };
                  final hasAllowedSpecial = password.runes
                      .map((r) => String.fromCharCode(r))
                      .any((ch) => allowedSpecials.contains(ch));

                  if (!hasUpper || !hasLower || !hasDigit || !hasAllowedSpecial) {
                    setState(() {
                      showPasswordCriteria = true;
                      passwordError = null;
                    });
                    return;
                  }

                  // Detect invalid special characters
                  final invalidChars = <String>{};
                  for (final r in password.runes) {
                    final ch = String.fromCharCode(r);
                    final isAlnum = RegExp(r'[A-Za-z0-9]').hasMatch(ch);
                    if (isAlnum) continue;
                    if (allowedSpecials.contains(ch)) continue;
                    invalidChars.add(ch);
                  }
                  if (invalidChars.isNotEmpty) {
                    setState(() {
                      showPasswordCriteria = true;
                      passwordError = null;
                    });
                    return;
                  }

                  // clear criteria display when password passed
                  if (password.isNotEmpty) showPasswordCriteria = false;

                  if (username.length < 6 || username.length > 15) {
                    setState(() => usernameError = 'Username must be 6 to 15 characters.');
                    return;
                  }

                  if (username.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a username')),
                    );
                    return;
                  }

                  // Username allowed characters check
                  final allowedUsername = RegExp(r'^[A-Za-z0-9_.-]+$');
                  if (!allowedUsername.hasMatch(username)) {
                    setState(() {
                      showUsernameCriteria = true;
                      usernameError = null;
                    });
                    return;
                  }

                  // If availability unknown, check now
                  if (usernameAvailable != true) {
                    try {
                      final uri = Uri.parse('$backendHost/api/username/exists?username=${Uri.encodeComponent(username)}');
                      final resp = await http.get(uri, headers: {'Content-Type': 'application/json'});
                      if (resp.statusCode == 200) {
                        final body = jsonDecode(resp.body) as Map<String, dynamic>;
                        usernameAvailable = !(body['exists'] == true);
                      }
                    } catch (_) {}
                    if (usernameAvailable != true) {
                      setState(() {
                        showUsernameCriteria = true;
                        usernameError = null;
                      });
                      return;
                    }
                  }

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
