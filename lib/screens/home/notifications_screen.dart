import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import '../../widgets/bf_bottom_nav.dart';

class NotificationsScreen extends StatelessWidget {
  final AppState appState;
  const NotificationsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final items = appState.notifications;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Notifications'),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text('No notifications', style: TextStyle(color: Colors.white70)),
            )
          : ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFF222222)),
              itemBuilder: (context, i) {
                final n = items[i];
                return ListTile(
                  leading: const Icon(Icons.notifications_none_rounded, color: Color(0xFFFF7A00)),
                  title: Text(n.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  subtitle: Text(n.body, style: const TextStyle(color: Colors.white60)),
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
