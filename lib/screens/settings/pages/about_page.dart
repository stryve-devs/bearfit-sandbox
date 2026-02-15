import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const Color orange = Color(0xFFFF7825);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: const Color(0xFF1C120A),
        elevation: 0,
        leading: const BackButton(color: orange),
        centerTitle: true,
        title: const Text(
          'About',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500, // ✅ Not thick
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                /// LOGO ICON
                const Icon(
                  Icons.pets,
                  color: orange,
                  size: 80,
                ),

                const SizedBox(height: 30),

                /// SOCIAL
                const Text(
                  "Social",
                  style: TextStyle(
                    color: orange,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                const Text("Instagram",
                    style: TextStyle(color: orange, fontSize: 18)),

                const SizedBox(height: 12),

                const Text("Facebook",
                    style: TextStyle(color: orange, fontSize: 18)),

                const SizedBox(height: 12),

                const Text("Twitter",
                    style: TextStyle(color: orange, fontSize: 18)),

                const SizedBox(height: 40),

                /// CONTACT
                const Text(
                  "Contact",
                  style: TextStyle(
                    color: orange,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "hello@bearfit.com",
                  style: TextStyle(
                    color: orange,
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                  ),
                ),

                const SizedBox(height: 40),

                /// POLICIES
                const Text(
                  "Policies",
                  style: TextStyle(
                    color: orange,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Privacy Policy",
                  style: TextStyle(color: orange, fontSize: 18),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Terms & Conditions",
                  style: TextStyle(color: orange, fontSize: 18),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Acknowledgements",
                  style: TextStyle(color: orange, fontSize: 18),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Version: 2.5.10 - (1880052)",
                  style: TextStyle(color: orange, fontSize: 16),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
