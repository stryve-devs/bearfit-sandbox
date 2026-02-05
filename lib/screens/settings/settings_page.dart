import 'package:flutter/material.dart';              // ✅ Flutter core
import 'widgets/settings_tile.dart';                 // ✅ Custom widget
import 'widgets/section_header.dart';                // ✅ Custom widget
import 'pages/profile_page.dart';                    // ✅ Settings sub-page
import 'pages/account/account_page.dart';            // ✅ Settings sub-page
import 'pages/notifications_page.dart';              // ✅ Settings sub-page
import 'pages/workout/workout_settings_page.dart';   // ✅ Settings sub-page
import 'pages/privacy/privacy_social_page.dart';     // ✅ Settings sub-page
import 'pages/units_page.dart';                      // ✅ Settings sub-page
import 'pages/language_page.dart';                   // ✅ Settings sub-page
import 'pages/apple_health_page.dart';               // ✅ Settings sub-page
import 'pages/themes_page.dart';                     // ✅ Settings sub-page
import 'pages/exportandimport/export_import_page.dart'; // ✅ Settings sub-page
import 'pages/getting_started_page.dart';            // ✅ Guide page
import 'pages/routine_help_page.dart';               // ✅ Guide page
import 'pages/faq_page.dart';                        // ✅ Help page
import 'pages/contactus/contact_us_page.dart';       // ✅ Help page
import 'pages/about_page.dart';                      // ✅ Help page

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C120A),
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          // ACCOUNT
          const SectionHeader(title: 'Account'),
          SettingsTile(
            icon: Icons.person,
            title: 'Profile',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
          ),
          SettingsTile(
            icon: Icons.lock,
            title: 'Account',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AccountPage()),
            ),
          ),
          SettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsPage()),
            ),
          ),

          // PREFERENCES
          const SectionHeader(title: 'Preferences'),
          SettingsTile(
            icon: Icons.fitness_center,
            title: 'Workouts',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WorkoutSettingsPage()),
            ),
          ),
          SettingsTile(
            icon: Icons.lock_outline,
            title: 'Privacy & Social',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacySocialPage()),
            ),
          ),
          SettingsTile(
            icon: Icons.straighten,
            title: 'Units',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UnitsPage()),
            ),
          ),
          SettingsTile(
            icon: Icons.language,
            title: 'Language',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LanguagePage()),
            ),
          ),
          SettingsTile(
            icon: Icons.favorite_border,
            title: 'Apple Health',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AppleHealthPage()),
            ),
          ),
          SettingsTile(
            icon: Icons.palette_outlined,
            title: 'Themes',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ThemesPage()),
            ),
          ),
          SettingsTile(
            icon: Icons.import_export,
            title: 'Export & Import Data',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExportImportPage()),
            ),
          ),

          // GUIDES
          const SectionHeader(title: 'Guides'),
          SettingsTile(
            icon: Icons.info_outline,
            title: 'Getting Started Guide',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GettingStartedPage()),
            ),
          ),
          SettingsTile(
            icon: Icons.help_outline,
            title: 'Routine Help',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RoutineHelpPage()),
            ),
          ),

          // HELP
          const SectionHeader(title: 'Help'),
          SettingsTile(
            icon: Icons.question_mark,
            title: 'Frequently Asked Questions',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FaqPage()),
            ),
          ),
          SettingsTile(
            icon: Icons.mail_outline,
            title: 'Contact Us',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ContactUsPage()),
            ),
          ),
          SettingsTile(
            icon: Icons.info,
            title: 'About',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutPage()),
            ),
          ),

          const SizedBox(height: 24),

          // SOCIAL
          const Column(
            children: [
              Text(
                'Follow us @bearfitapp',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: Colors.white),
                  SizedBox(width: 18),
                  Icon(Icons.play_circle, color: Colors.white),
                  SizedBox(width: 18),
                  Icon(Icons.music_note, color: Colors.white),
                  SizedBox(width: 18),
                  Icon(Icons.facebook, color: Colors.white),
                  SizedBox(width: 18),
                  Icon(Icons.reddit, color: Colors.white),
                  SizedBox(width: 18),
                  Icon(Icons.close, color: Colors.white),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // LOGOUT
          GestureDetector(
            onTap: () {
              // Show logout confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  backgroundColor: const Color(0xFF1C120A),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Implement logout functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logged out successfully')),
                        );
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
