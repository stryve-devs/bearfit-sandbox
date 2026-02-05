import 'package:flutter/material.dart';

import '../../state/app_state.dart';

class ContactsScreen extends StatelessWidget {
  final AppState appState;
  const ContactsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final contacts = appState.contacts;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Contacts'),
      ),
      body: contacts.isEmpty
          ? const Center(
              child: Text('No contacts found', style: TextStyle(color: Colors.white70)),
            )
          : ListView.separated(
              itemCount: contacts.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFF222222)),
              itemBuilder: (context, i) {
                final c = contacts[i];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF2A2A2A),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(c.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  subtitle: Text(c.phone, style: const TextStyle(color: Colors.white60)),
                  trailing: TextButton(
                    onPressed: () {},
                    child: const Text('Invite', style: TextStyle(color: Color(0xFFFF7A00))),
                  ),
                );
              },
            ),
    );
  }
}
