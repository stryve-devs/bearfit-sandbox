import 'dart:html' as html;
import 'package:google_sign_in/google_sign_in.dart';

Future<void> writeSignInLog(GoogleSignInAccount account) async {
  try {
    final nowLocal = DateTime.now();
    final buffer = StringBuffer();
    buffer.writeln('--- Google Sign-in Log (web) ---');
    buffer.writeln('Time (local): $nowLocal');
    buffer.writeln('Email: ${account.email}');
    buffer.writeln('DisplayName: ${account.displayName}');
    buffer.writeln('Id: ${account.id}');
    buffer.writeln('\n');

    const key = 'google_signin_log';
    final existing = html.window.localStorage[key] ?? '';
    final combined = existing + buffer.toString();
    html.window.localStorage[key] = combined;
  } catch (_) {
    // no-op
  }
}
