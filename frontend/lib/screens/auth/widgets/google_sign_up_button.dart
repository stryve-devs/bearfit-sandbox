import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../utils/signin_logger_io.dart' if (dart.library.html) '../../../utils/signin_logger_web.dart' as signin_logger;
import '../choose_username_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth_config.dart';
import '../workout_screen.dart';

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

            if (exists) {
              // If the email already exists, send user straight to the workout screen.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const WorkoutScreen()),
              );
              return;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Signed in as ${account.email}')),
            );

            // retrieve idToken so backend can verify / register with username later
            String? idToken;
            try {
              final auth = await account.authentication;
              idToken = auth.idToken;
            } catch (_) {}

            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChooseUsernameScreen(
                initialEmail: account.email,
                initialName: account.displayName,
                idToken: idToken,
              )),
            );
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
