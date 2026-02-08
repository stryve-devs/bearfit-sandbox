import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/constants/colors.dart';

import 'widgets/auth_text_field.dart';
import 'widgets/primary_button.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'select_units_screen.dart';
import 'auth_config.dart';

class ChooseUsernameScreen extends StatefulWidget {
  final String? initialEmail;
  final String? initialName;
  final String? idToken;

  const ChooseUsernameScreen({super.key, this.initialEmail, this.initialName, this.idToken});

  @override
  State<ChooseUsernameScreen> createState() => _ChooseUsernameScreenState();
}

class _ChooseUsernameScreenState extends State<ChooseUsernameScreen> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String? nameError;
  bool nameTouched = false;
  late FocusNode nameFocusNode;
  bool showNameCriteria = false;
  String? errorText;
  late FocusNode usernameFocusNode;
  bool showUsernameCriteria = false;
  bool? usernameAvailable;
  Timer? _usernameDebounce;
  bool usernameTouched = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    nameController.removeListener(_onNameChanged);
    nameController.dispose();
    nameFocusNode.removeListener(() { if (mounted) setState(() {}); });
    nameFocusNode.dispose();
    controller.removeListener(_onUsernameChanged);
    usernameFocusNode.removeListener(() { if (mounted) setState(() {}); });
    usernameFocusNode.dispose();
    _usernameDebounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController.addListener(_onNameChanged);
    nameFocusNode = FocusNode();
    nameFocusNode.addListener(() { if (mounted) setState(() {}); });
    usernameFocusNode = FocusNode();
    usernameFocusNode.addListener(() { if (mounted) setState(() {}); });
    controller.addListener(_onUsernameChanged);
  }

  void _onNameChanged() {
    if (!mounted) return;
    nameTouched = nameController.text.trim().isNotEmpty;
    if (nameError != null) nameError = null;
    if (showNameCriteria) showNameCriteria = false;
    setState(() {});
  }

  void _onUsernameChanged() {
    if (mounted) {
      usernameTouched = controller.text.trim().isNotEmpty;
      if (errorText != null) errorText = null;
      usernameAvailable = null;
      if (showUsernameCriteria) showUsernameCriteria = false;
      setState(() {});
    }

    _usernameDebounce?.cancel();
    _usernameDebounce = Timer(const Duration(milliseconds: 700), () async {
      final value = controller.text.trim();
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
    final uname = controller.text.trim();
    final name = nameController.text.trim();
    final nameRegex = RegExp(r"^[\p{L}\s'-]+$", unicode: true);
    final nameOk = name.isNotEmpty && nameRegex.hasMatch(name);
    final lengthOk = uname.length >= 6 && uname.length <= 15;
    final allowed = RegExp(r'^[A-Za-z0-9_.-]+$');
    final charsOk = uname.isNotEmpty && allowed.hasMatch(uname);
    final bool usernameInvalid = !lengthOk || !charsOk || usernameAvailable == false;
    final bool isFormReady = nameOk && (lengthOk && charsOk && usernameAvailable == true);
    final String? nameBorderError = nameError ?? ((nameTouched && !nameOk) ? '' : null);
    final String? usernameBorderError = errorText ?? ((usernameTouched && usernameInvalid) ? '' : null);
    final bool isCheckingUsername = uname.isNotEmpty && lengthOk && charsOk && usernameAvailable == null;

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
          "Almost there",
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
                label: "Name",
                hint: "",
                controller: nameController,
                focusNode: nameFocusNode,
                errorText: nameBorderError,
                compact: true,
                useFloatingLabel: true,
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

              const SizedBox(height: 12),

              AuthTextField(
                label: "Username",
                hint: "",
                controller: controller,
                focusNode: usernameFocusNode,
                errorText: usernameBorderError,
                compact: true,
                useFloatingLabel: true,
              ),

              Builder(builder: (context) {
                final showUCriteria = usernameFocusNode.hasFocus || showUsernameCriteria;
                if (!showUCriteria) return const SizedBox.shrink();

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
                  return row(usernameAvailable == true,
                      usernameAvailable == true ? 'Username available' : 'Username taken');
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
                    row(lengthOk, '6-15 characters'),
                    const SizedBox(height: 4),
                    row(charsOk, 'Allowed: letters, numbers, _ . -'),
                    const SizedBox(height: 4),
                    availabilityRow(),
                  ]),
                );
              }),

              const SizedBox(height: 8),

              PrimaryButton(
                label: _isSubmitting ? 'Continuing...' : 'Continue',
                onPressed: (isFormReady && !_isSubmitting)
                    ? () async {
                  setState(() => _isSubmitting = true);
                  setState(() => errorText = null);
                  final username = controller.text.trim();
                  if (username.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a username')),
                    );
                    setState(() => _isSubmitting = false);
                    return;
                  }

                  if (username.length < 6 || username.length > 15) {
                    setState(() {
                      showUsernameCriteria = true;
                      errorText = null;
                      _isSubmitting = false;
                    });
                    return;
                  }

                  final allowedUsername = RegExp(r'^[A-Za-z0-9_.-]+$');
                  if (!allowedUsername.hasMatch(username)) {
                    setState(() {
                      showUsernameCriteria = true;
                      errorText = null;
                      _isSubmitting = false;
                    });
                    return;
                  }

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
                        errorText = null;
                        _isSubmitting = false;
                      });
                      return;
                    }
                  }

                  // If we have an idToken from Google sign-in, register via Google endpoint
                  if (widget.idToken != null) {
                    try {
                      final uri = Uri.parse('$backendHost/api/auth/register-google');
                      final resp = await http.post(
                        uri,
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({
                          'idToken': widget.idToken,
                          'username': username,
                          'name': nameController.text.trim(),
                        }),
                      );
                      if (resp.statusCode == 200) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const SelectUnitsScreen()),
                        );
                        return;
                      } else {
                        final msg = (resp.body.isNotEmpty) ? jsonDecode(resp.body)['message'] ?? 'Registration failed' : 'Registration failed';
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                        setState(() => _isSubmitting = false);
                        return;
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error')));
                      setState(() => _isSubmitting = false);
                      return;
                    }
                  }

                  // Fallback when idToken wasn't provided but we do have an initial email from Google
                  if (widget.initialEmail != null) {
                    try {
                      final uri = Uri.parse('$backendHost/api/auth/google');
                      final resp = await http.post(
                        uri,
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({
                          'email': widget.initialEmail,
                          'username': username,
                          'name': nameController.text.trim(),
                        }),
                      );
                      if (resp.statusCode == 200) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const SelectUnitsScreen()),
                        );
                        return;
                      } else {
                        final msg = (resp.body.isNotEmpty) ? jsonDecode(resp.body)['message'] ?? 'Registration failed' : 'Registration failed';
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                        setState(() => _isSubmitting = false);
                        return;
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error')));
                      setState(() => _isSubmitting = false);
                      return;
                    }
                  }


                  // proceed to next screen (non-Google flow)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SelectUnitsScreen(),
                    ),
                  );
                }
                    : null,
                backgroundColor: (isFormReady && !_isSubmitting) ? null : const Color(0xFF555555),
                foregroundColor: (isFormReady && !_isSubmitting) ? null : Colors.white,
              ),

              if (!isFormReady && (uname.isNotEmpty || name.isNotEmpty))
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    isCheckingUsername
                        ? 'Checking username availability...'
                        : 'Complete all fields to continue.',
                    style: const TextStyle(color: AppColors.grey, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
