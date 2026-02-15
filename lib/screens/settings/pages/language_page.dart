import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String selectedLanguage = 'English';

  final List<String> languages = [
    'English',
    'Español',
    'Deutsch',
    'Français',
    'Italiano',
    'Português',
    'Türkçe',
    '中文',
    'Português (BR)',
    '日本語',
    'Русский',
    '한국어',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1608),
        elevation: 0,
        leading: const BackButton(color: Color(0xFFFF7825)),
        title: const Text(
          'Language',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          final isSelected = language == selectedLanguage;

          return InkWell(
            onTap: () {
              setState(() {
                selectedLanguage = language;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      language,
                      style: const TextStyle(
                        color: Color(0xFFFF7A00),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check,
                      color: Color(0xFFFF7A00),
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
