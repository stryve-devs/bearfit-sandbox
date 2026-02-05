import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import '../../data/models.dart';
import '../../app/router.dart';

class PostDetailScreen extends StatelessWidget {
  final AppState appState;
  final Post post;

  const PostDetailScreen({super.key, required this.appState, required this.post});

  @override
  Widget build(BuildContext context) {
    final liked = appState.likedPosts.contains(post.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Post Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(post.athlete.avatarUrl)),
            title: Text(post.athlete.name),
            subtitle: Text(post.athlete.handle),
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile, arguments: post.athlete),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.home5, arguments: post.imageUrl),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(post.imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),
          Text(post.caption),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
                onPressed: () => appState.toggleLike(post.id),
              ),
              Text(liked ? 'Liked' : 'Like'),
            ],
          ),
        ],
      ),
    );
  }
}
