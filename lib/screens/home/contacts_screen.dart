import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import '../../widgets/bf_bottom_nav.dart';

class ContactsScreen extends StatefulWidget {
  final AppState appState;
  const ContactsScreen({super.key, required this.appState});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  // ✅ Track invited contacts (use a stable key)
  final Set<String> invitedKeys = {};

  String _nameOf(dynamic c) {
    try {
      if (c is Map) return (c['name'] ?? '').toString();
      return (c.name ?? '').toString();
    } catch (_) {
      return '';
    }
  }

  String _phoneOf(dynamic c) {
    try {
      if (c is Map) return (c['phone'] ?? '').toString();
      return (c.phone ?? '').toString();
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Keep your real contacts + add more fake ones (no touching AppState)
    final contacts = <dynamic>[
      ...widget.appState.contacts,
      ...List.generate(
        15,
        (i) => _DemoContact(
          name: "Demo Person ${i + 1}",
          phone: "05000000${(i + 1).toString().padLeft(2, '0')}",
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Contacts'),
      ),
      body: contacts.isEmpty
          ? const Center(
              child: Text(
                'No contacts found',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.separated(
              itemCount: contacts.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Color(0xFF222222)),
              itemBuilder: (context, i) {
                final c = contacts[i];

                final name = _nameOf(c);
                final phone = _phoneOf(c);

                // ✅ stable unique key even if phone/name empty
                final key = '${name.isEmpty ? "Unknown" : name}|${phone.isEmpty ? "NA" : phone}|$i';
                final isInvited = invitedKeys.contains(key);

                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF2A2A2A),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    name.isEmpty ? 'Unknown' : name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    phone.isEmpty ? '—' : phone,
                    style: const TextStyle(color: Colors.white60),
                  ),
                  trailing: TextButton(
                    onPressed: isInvited
                        ? null
                        : () {
                            setState(() {
                              invitedKeys.add(key);
                            });
                          },
                    child: Text(
                      isInvited ? 'Invited' : 'Invite',
                      style: TextStyle(
                        color: isInvited
                            ? const Color(0xFF777777)
                            : const Color(0xFFFF7A00),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BfBottomNav(
        currentIndex: 0, // ✅ Home will be orange
        onTap: (i) {},
      ),
    );
  }
}

// ✅ Local demo contact (safe non-null fields)
class _DemoContact {
  final String name;
  final String phone;
  _DemoContact({required this.name, required this.phone});
}
