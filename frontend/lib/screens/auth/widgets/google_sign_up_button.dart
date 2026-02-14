import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../utils/auth/signin_logger_io.dart' if (dart.library.html) '../../../utils/auth/signin_logger_web.dart' as signin_logger;
import '../choose_username_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../services/auth/token_service.dart';
import '../auth_config.dart';
import '../../workout/workout_screen.dart';

class GoogleSignUpButton extends StatelessWidget {
  const GoogleSignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D2C2C),
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFF2D2C2C)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 0,
        ),
        onPressed: () async {
          final googleSignIn = kIsWeb
              ? GoogleSignIn(clientId: googleAndroidClientId, scopes: ['email'])
              : GoogleSignIn(scopes: ['email']);
          try {
            // Ensure account chooser shows each time for sign-up by signing out first
            try {
              await googleSignIn.signOut();
            } catch (_) {}
            final account = await googleSignIn.signIn();
            if (account == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Google sign-in cancelled')),
              );
              return;
            }
            // Attempt to log account details (platform-specific implementation)
            try {
              await signin_logger.writeSignInLog(account);
            } catch (_) {}

            // Check with backend if email already exists
            bool exists = false;
            try {
              final uri = Uri.parse('$backendHost/api/auth/exists?email=${Uri.encodeComponent(account.email)}');
              final resp = await http.get(uri, headers: {'Content-Type': 'application/json'});
              if (resp.statusCode == 200) {
                final body = jsonDecode(resp.body) as Map<String, dynamic>;
                exists = body['exists'] == true;
              }
            } catch (_) {}

            // Try to exchange idToken for backend tokens (preferred). If idToken isn't available,
            // use the email fallback to request tokens from the backend (development convenience).
            String? idToken;
            try {
              final auth = await account.authentication;
              idToken = auth.idToken;
            } catch (_) {}

            // Temporary debug: log idToken preview, email and exists flag
            try {
              final idPreview = idToken != null && idToken.length > 20 ? '${idToken.substring(0,20)}...' : (idToken ?? '<null>');
              // ignore: avoid_print
              print('DEBUG GoogleSignUpButton: email=${account.email} idTokenPreview=$idPreview exists=$exists');
            } catch (_) {}

            Future<bool> tryExchange(Map<String, dynamic> payload) async {
              try {
                final uri = Uri.parse('$backendHost/api/auth/google');
                final resp = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(payload));
                // Temporary debug: log exchange response
                try {
                  // ignore: avoid_print
                  print('DEBUG GoogleSignUpButton tryExchange: status=${resp.statusCode} body=${resp.body}');
                } catch (_) {}

                if (resp.statusCode == 200) {
                  final body = jsonDecode(resp.body) as Map<String, dynamic>;
                  final access = body['accessToken'] as String?;
                  final refresh = body['refreshToken'] as String?;
                  if (access != null && refresh != null) {
                    TokenService.setTokens(accessToken: access, refreshToken: refresh);
                    return true;
                  }
                }
              } catch (_) {}
              return false;
            }

            bool exchanged = false;
            if (idToken != null) {
              exchanged = await tryExchange({'idToken': idToken});
            }

            if (!exchanged && exists) {
              // Try email fallback
              exchanged = await tryExchange({'email': account.email});
            }

            if (exchanged) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const WorkoutScreen()),
              );
              return;
            }

            // If exchange failed but we have an idToken, this likely means the user
            // doesn't exist yet — navigate to username selection so they can register.
            // New user -> continue to choose username (pass idToken if available)
            try {
              // ignore: avoid_print
              print('DEBUG GoogleSignUpButton: navigating to ChooseUsernameScreen for ${account.email} (idTokenPreview=${idToken != null ? (idToken.length>20 ? idToken.substring(0,20)+'...' : idToken) : '<null>'})');
            } catch (_) {}

            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChooseUsernameScreen(
                initialEmail: account.email,
                initialName: account.displayName,
                idToken: idToken,
              )),
            );
            return;
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Google sign-in failed: $e')),
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Image.network(
                'https://www.gstatic.com/images/branding/googleg/1x/googleg_standard_color_128dp.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Sign up with Google',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
