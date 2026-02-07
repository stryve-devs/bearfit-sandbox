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
  const ChooseUsernameScreen({super.key});

  @override
  State<ChooseUsernameScreen> createState() => _ChooseUsernameScreenState();
}

class _ChooseUsernameScreenState extends State<ChooseUsernameScreen> {
  final TextEditingController controller = TextEditingController();
  String? errorText;
  late FocusNode usernameFocusNode;
  bool showUsernameCriteria = false;
  bool? usernameAvailable;
  Timer? _usernameDebounce;
  bool usernameTouched = false;

  @override
  void dispose() {
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
    usernameFocusNode = FocusNode();
    usernameFocusNode.addListener(() { if (mounted) setState(() {}); });
    controller.addListener(_onUsernameChanged);
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
    final lengthOk = uname.length >= 6 && uname.length <= 15;
    final allowed = RegExp(r'^[A-Za-z0-9_.-]+$');
    final charsOk = uname.isNotEmpty && allowed.hasMatch(uname);
    final isUsernameReady = lengthOk && charsOk && usernameAvailable == true;
    final bool usernameInvalid = !lengthOk || !charsOk || usernameAvailable == false;
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
                label: "Continue",
                onPressed: isUsernameReady
                    ? () async {
                  setState(() => errorText = null);
                  final username = controller.text.trim();
                  if (username.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a username')),
                    );
                    return;
                  }

                  if (username.length < 6 || username.length > 15) {
                    setState(() {
                      showUsernameCriteria = true;
                      errorText = null;
                    });
                    return;
                  }

                  final allowedUsername = RegExp(r'^[A-Za-z0-9_.-]+$');
                  if (!allowedUsername.hasMatch(username)) {
                    setState(() {
                      showUsernameCriteria = true;
                      errorText = null;
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
                      });
                      return;
                    }
                  }

                  // proceed to next screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SelectUnitsScreen(),
                    ),
                  );
                }
                    : null,
              ),

              if (!isUsernameReady && uname.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    isCheckingUsername
                        ? 'Checking username availability...'
                        : 'Complete all fields to continue.',
                    style: const TextStyle(color: AppColors.grey, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
