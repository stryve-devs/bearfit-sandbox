import 'package:flutter/material.dart';
import 'widgets/settings_tile.dart';
import 'widgets/section_header.dart';
import 'pages/profile_page.dart';
import 'pages/account/account_page.dart';
import 'pages/notifications_page.dart';
import 'pages/workout/workout_settings_page.dart';
import 'pages/privacy/privacy_social_page.dart';
import 'pages/units_page.dart';
import 'pages/language_page.dart';
import 'pages/apple_health_page.dart';
import 'pages/themes_page.dart';
import 'pages/exportandimport/export_import_page.dart';
import 'pages/getting_started_page.dart';
import 'pages/routine_help_page.dart';
import 'pages/faq_page.dart';
import 'pages/contactus/contact_us_page.dart';
import 'pages/about_page.dart';
import 'pages/empty_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool isLoggedOut = false;

  static const Color orange = Color(0xFFFF7825);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: const Color(0xFF1C120A),
        elevation: 0,

        // ✅ FIXED BACK BUTTON
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: orange),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [

          /// ACCOUNT
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

          /// PREFERENCES
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

          /// GUIDES
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

          /// HELP
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

          const SizedBox(height: 30),

          const Center(
            child: Text(
              'Follow us @bearfitapp',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(context, Icons.camera_alt, 'Instagram'),
              _socialIcon(context, Icons.play_circle, 'YouTube'),
              _socialIcon(context, Icons.music_note, 'TikTok'),
              _socialIcon(context, Icons.facebook, 'Facebook'),
              _socialIcon(context, Icons.reddit, 'Reddit'),
              _socialIcon(context, Icons.close, 'Twitter'),
            ],
          ),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isLoggedOut = true;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  isLoggedOut ? "Logged Out" : "Logout",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _socialIcon(BuildContext context, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EmptyPage(title: title),
            ),
          );
        },
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
