import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/constants/colors.dart';

import 'widgets/auth_text_field.dart';
import 'widgets/primary_button.dart';

import 'terms_screen.dart';
import 'select_units_screen.dart';
import 'email_otp_screen.dart';
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
  final TextEditingController nameController = TextEditingController();
  String? nameError;
  bool nameTouched = false;
  late FocusNode nameFocusNode;
  bool showNameCriteria = false;
  final TextEditingController usernameController = TextEditingController();
  String? usernameError;
  late FocusNode usernameFocusNode;
  bool showUsernameCriteria = false;
  bool? usernameAvailable;
  Timer? _usernameDebounce;
  final TextEditingController emailController = TextEditingController();
  String? emailError;
  bool emailTouched = false;
  bool? emailAvailable;
  Timer? _emailDebounce;
  bool emailCheckFailed = false;
  final TextEditingController passwordController = TextEditingController();
  String? passwordError;
  bool passwordTouched = false;
  late FocusNode passwordFocusNode;
  bool _obscurePassword = true;
  bool showPasswordCriteria = false;
  bool usernameTouched = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_onNameChanged);
    nameFocusNode = FocusNode();
    nameFocusNode.addListener(() { if (mounted) setState(() {}); });
    emailController.addListener(_onEmailChanged);
    passwordController.addListener(_onPasswordChanged);
    passwordFocusNode = FocusNode();
    passwordFocusNode.addListener(() { if (mounted) setState(() {}); });
    usernameFocusNode = FocusNode();
    usernameFocusNode.addListener(() { if (mounted) setState(() {}); });
    usernameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    nameController.removeListener(_onNameChanged);
    nameController.dispose();
    nameFocusNode.removeListener(() { if (mounted) setState(() {}); });
    nameFocusNode.dispose();
    emailController.removeListener(_onEmailChanged);
    emailController.dispose();
    _emailDebounce?.cancel();
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

  void _onNameChanged() {
    if (!mounted) return;
    nameTouched = nameController.text.trim().isNotEmpty;
    if (nameError != null) nameError = null;
    if (showNameCriteria) showNameCriteria = false;
    setState(() {});
  }

  void _onEmailChanged() {
    if (!mounted) return;
    final email = emailController.text.trim();
    emailTouched = email.isNotEmpty;
    emailAvailable = null;
    emailCheckFailed = false;
    // Only auto-clear the inline error once the email becomes valid.
    if (emailError != null) {
      final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
      if (email.isNotEmpty && emailRegex.hasMatch(email)) {
        emailError = null;
      }
    }
    setState(() {});

    _emailDebounce?.cancel();
    _emailDebounce = Timer(const Duration(milliseconds: 700), () async {
      final value = emailController.text.trim();
      final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
      if (!value.isNotEmpty || !emailRegex.hasMatch(value)) {
        if (mounted) setState(() => emailCheckFailed = false);
        return;
      }
      try {
        final uri = Uri.parse('$backendHost/api/auth/exists?email=${Uri.encodeComponent(value)}');
        final resp = await http
            .get(uri, headers: {'Content-Type': 'application/json'})
            .timeout(const Duration(seconds: 5));
        if (resp.statusCode == 200) {
          final body = jsonDecode(resp.body) as Map<String, dynamic>;
          if (mounted) setState(() => emailAvailable = !(body['exists'] == true));
        } else {
          if (mounted) setState(() => emailCheckFailed = true);
        }
      } catch (_) {
        if (mounted) setState(() => emailCheckFailed = true);
      }
    });
  }

  void _onPasswordChanged() {
    if (mounted) {
      passwordTouched = passwordController.text.isNotEmpty;
      // clear the inline error when user starts editing
      if (passwordError != null) passwordError = null;
      if (showPasswordCriteria) showPasswordCriteria = false;
      setState(() {});
    }
  }

  void _onUsernameChanged() {
    if (mounted) {
      usernameTouched = usernameController.text.trim().isNotEmpty;
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
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text;

    final nameRegex = RegExp(r"^[\p{L}\s'-]+$", unicode: true);
    final nameOk = name.isNotEmpty && nameRegex.hasMatch(name);

    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    final emailOk = email.isNotEmpty && emailRegex.hasMatch(email);

    final pwdLengthOk = password.length >= 8 && password.length <= 32;
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
    final invalidPwdChars = <String>{};
    for (final r in password.runes) {
      final ch = String.fromCharCode(r);
      final isAlnum = RegExp(r'[A-Za-z0-9]').hasMatch(ch);
      if (isAlnum) continue;
      if (allowedSpecials.contains(ch)) continue;
      invalidPwdChars.add(ch);
    }
    final passwordOk = pwdLengthOk && hasUpper && hasLower && hasDigit && hasAllowedSpecial && invalidPwdChars.isEmpty;

    final usernameLengthOk = username.length >= 6 && username.length <= 15;
    final allowedUsername = RegExp(r'^[A-Za-z0-9_.-]+$');
    final usernameCharsOk = username.isNotEmpty && allowedUsername.hasMatch(username);
    final isCheckingUsername = username.isNotEmpty && usernameLengthOk && usernameCharsOk && usernameAvailable == null;
    final usernameOk = usernameLengthOk && usernameCharsOk && usernameAvailable == true;

    final isCheckingEmail = emailOk && emailAvailable == null && !emailCheckFailed;
    final isFormReady = nameOk && emailOk && emailAvailable == true && passwordOk && usernameOk;

    final String? nameBorderError = nameError ?? ((nameTouched && !nameOk) ? '' : null);
    final String? emailBorderError = emailError ?? ((emailTouched && (!emailOk || emailAvailable == false)) ? '' : null);
    final String? passwordBorderError = passwordError ?? ((passwordTouched && !passwordOk) ? '' : null);
    final bool usernameInvalid = !usernameLengthOk || !usernameCharsOk || usernameAvailable == false;
    final String? usernameBorderError = usernameError ?? ((usernameTouched && usernameInvalid) ? '' : null);

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
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const SignupInfoDialog(),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTextField(
                label: "Name",
                hint: "",
                controller: nameController,
                focusNode: nameFocusNode,
                compact: true,
                useFloatingLabel: true,
                errorText: nameBorderError,
              ),

              Builder(builder: (context) {
                final showCriteria = nameFocusNode.hasFocus || nameError != null || showNameCriteria;
                if (!showCriteria) return const SizedBox.shrink();

                final invalidChars = <String>{};
                for (final r in name.runes) {
                  final ch = String.fromCharCode(r);
                  if (RegExp(r"[\p{L}\s'-]", unicode: true).hasMatch(ch)) continue;
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
                    row(nameOk, 'Only letters'),
                  ]),
                );
              }),

              AuthTextField(
                label: "Email",
                hint: "",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                compact: true,
                useFloatingLabel: true,
                errorText: emailBorderError,
                suffix: emailOk
                    ? Transform.translate(
                        offset: const Offset(-4, 0),
                        child: (isCheckingEmail
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: Center(
                                  child: CupertinoActivityIndicator(
                                    radius: 7,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : (emailCheckFailed
                                ? const Icon(Icons.error_outline, color: AppColors.grey, size: 18)
                                : (emailAvailable == true
                                    ? const Icon(Icons.check_circle, color: Colors.green, size: 18)
                                    : (emailAvailable == false
                                        ? const Icon(Icons.cancel, color: Color(0xFFD22B2B), size: 18)
                                        : const SizedBox.shrink())))),
                      )
                    : null,
              ),

              AuthTextField(
                label: "Password",
                hint: "",
                controller: passwordController,
                focusNode: passwordFocusNode,
                compact: true,
                obscureText: _obscurePassword,
                useFloatingLabel: true,
                errorText: passwordBorderError,
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
                errorText: usernameBorderError,
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
                    return const Row(children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Center(
                          child: CupertinoActivityIndicator(
                            radius: 7,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: AppColors.white, fontSize: 12),
                      children: [
                        const TextSpan(text: 'By continuing you agree to our '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: GestureDetector(
                            onTap: () {
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                label: "Continue",
                onPressed: isFormReady
                    ? () async {
                  setState(() {
                    usernameError = null;
                    emailError = null;
                    passwordError = null;
                    nameError = null;
                  });
                  final name = nameController.text.trim();
                  final email = emailController.text.trim();
                  final username = usernameController.text.trim();
                  final password = passwordController.text;

                  if (name.isEmpty || !nameRegex.hasMatch(name)) {
                    setState(() {
                      showNameCriteria = true;
                      nameError = 'Name must contain only letters.';
                    });
                    return;
                  }

                  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                  if (email.isEmpty || !emailRegex.hasMatch(email)) {
                    setState(() => emailError = 'Please enter a valid email address.');
                    return;
                  }

                  if (emailAvailable != true) {
                    try {
                      final uri = Uri.parse('$backendHost/api/auth/exists?email=${Uri.encodeComponent(email)}');
                      final resp = await http.get(uri, headers: {'Content-Type': 'application/json'});
                      if (resp.statusCode == 200) {
                        final body = jsonDecode(resp.body) as Map<String, dynamic>;
                        emailAvailable = !(body['exists'] == true);
                      }
                    } catch (_) {}

                    if (emailAvailable != true) {
                      setState(() => emailError = 'Email already registered.');
                      return;
                    }
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
                      builder: (_) => EmailOtpScreen(
                        email: email,
                        name: name,
                        username: username,
                        password: password,
                      ),
                    ),
                  );
                }
                    : null,
              ),


              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
