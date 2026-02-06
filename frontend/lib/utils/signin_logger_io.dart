import 'dart:io';
import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/screens/auth/auth_config.dart';

Future<void> writeSignInLog(GoogleSignInAccount account) async {
  try {
    final auth = await account.authentication;
    final nowLocal = DateTime.now();
    final nowUtc = nowLocal.toUtc();

    final payload = {
      'timeLocal': nowLocal.toString(),
      'timeUtc': nowUtc.toIso8601String(),
      'timezone': nowLocal.timeZoneName,
      'locale': Platform.localeName,
      'email': account.email,
      'displayName': account.displayName,
      'id': account.id,
      'photoUrl': account.photoUrl,
      'accessToken': auth.accessToken,
      'idToken': auth.idToken,
    };

    // Use configured backend host (set in auth_config.dart). For Android emulator the
    // host should be reachable; when testing on a real device set this to your machine IP.
    final uri = Uri.parse('$backendHost/api/logs/google-signin');

    try {
      await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
    } catch (_) {
      // network/logging failure - ignore to avoid breaking sign-in flow
    }
  } catch (_) {
    // ignore errors to avoid crashing the sign-in flow
  }
}
