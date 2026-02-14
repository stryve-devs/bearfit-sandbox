import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../app/router.dart';
import '../../widgets/bf_bottom_nav.dart';

class DiscoverFeedScreen extends StatelessWidget {
  final AppState appState;

  const DiscoverFeedScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Discover Feed')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: appState.posts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final post = appState.posts[index];
          return ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(post.athlete.avatarUrl)),
            title: Text(post.athlete.name),
            subtitle: Text(post.caption, maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, AppRoutes.home4, arguments: post),
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
