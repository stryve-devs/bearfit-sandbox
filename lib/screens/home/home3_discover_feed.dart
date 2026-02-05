import 'package:flutter/material.dart';
import 'package:flutter_frontend/app/router.dart';
import 'package:flutter_frontend/state/app_state.dart';

import '../../routes/router.dart';
import '../../widgets/athlete_avatar.dart';
import '../../widgets/bf_card.dart';
import '../../data/models/post.dart';
import '../../data/mock/home_mock_data.dart' as mock;

class Home3DiscoverFeed extends StatefulWidget {
  final AppState? appState;

  const Home3DiscoverFeed({
    super.key,
    this.appState,
  });

  @override
  State<Home3DiscoverFeed> createState() => _Home3DiscoverFeedState();
}

class _Home3DiscoverFeedState extends State<Home3DiscoverFeed> {
  final Set<String> likedPostIds = {};
  final Set<String> savedPostIds = {};
  final Set<String> followedAthleteKeys = {};

  // ✅ random images
  final List<String> _randomImages = const [
    'https://picsum.photos/800/800?random=1',
    'https://picsum.photos/800/800?random=2',
    'https://picsum.photos/800/800?random=3',
    'https://picsum.photos/800/800?random=4',
    'https://picsum.photos/800/800?random=5',
    'https://picsum.photos/800/800?random=6',
    'https://picsum.photos/800/800?random=7',
    'https://picsum.photos/800/800?random=8',
  ];

  final Map<String, String> _postImageMap = {};

  String _imageForPost(Post post, int index) {
    return _postImageMap.putIfAbsent(
      post.id,
      () => _randomImages[index % _randomImages.length],
    );
  }

  List<Post> get _posts {
    return mock.posts;
  }

  void _openSearch() {
    showSearch(
      context: context,
      delegate: _PostSearchDelegate(
        posts: _posts,
        onTapPost: (post) =>
            Navigator.pushNamed(context, AppRoutes.home4, arguments: post),
      ),
    );
  }

  void _openComments(Post post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B0B0B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Comments",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemCount: post.comments.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: Color(0xFF222222), height: 1),
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      post.comments[i],
                      style: const TextStyle(color: Color(0xFFE6E6E6)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Add a comment...",
                        hintStyle: TextStyle(color: Color(0xFF888888)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A1A)),
                    child: const Text("Send"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _onBottomNav(int index) {
    if (index == 0) return;
    if (index == 1) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Workout tapped")));
      return;
    }
    if (index == 2) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Profile tapped")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        titleSpacing: 12,
        title: PopupMenuButton<String>(
          offset: const Offset(0, 44),
          color: const Color(0xFF121212),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (value) {
            if (value == 'home') {
              Navigator.pushNamed(context, AppRoutes.home1);
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'home',
              child: Row(
                children: const [
                  Icon(Icons.home, size: 18, color: Color(0xFFFF7A1A)),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text("Home (Following)",
                          style: TextStyle(color: Colors.white))),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'discover',
              child: Row(
                children: const [
                  Icon(Icons.explore, size: 18, color: Color(0xFFFF7A1A)),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text("Discover",
                          style: TextStyle(color: Colors.white))),
                  Icon(Icons.check, size: 18, color: Color(0xFFFF7A1A)),
                ],
              ),
            ),
          ],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "Discover",
                style: TextStyle(
                  color: Color(0xFFFF7A1A),
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.keyboard_arrow_down, color: Color(0xFFFF7A1A)),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openSearch,
            icon: const Icon(Icons.search, color: Color(0xFFFF7A1A)),
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.notifications),
            icon: const Icon(Icons.notifications_none,
                color: Color(0xFFFF7A1A)),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
        itemCount: _posts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final post = _posts[i];
          final imageUrl = _imageForPost(post, i); // ✅ random image per post

          final isLiked = likedPostIds.contains(post.id);
          final isSaved = savedPostIds.contains(post.id);

          final athleteKey = post.athlete.username;
          final isFollowed = followedAthleteKeys.contains(athleteKey);

          return GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.home4, arguments: post),
            child: BFCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AthleteAvatar(url: post.athlete.avatarUrl),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.athlete.username,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "3 hours ago",
                              style: TextStyle(
                                  color: Color(0xFFB0B0B0), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() {
                          if (isFollowed) {
                            followedAthleteKeys.remove(athleteKey);
                          } else {
                            followedAthleteKeys.add(athleteKey);
                          }
                        }),
                        child: Text(
                          isFollowed ? "Followed" : "+ Follow",
                          style: const TextStyle(
                              color: Color(0xFFFF7A1A),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() {
                          if (isSaved) {
                            savedPostIds.remove(post.id);
                          } else {
                            savedPostIds.add(post.id);
                          }
                        }),
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: const Color(0xFFE6E6E6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(post.caption,
                      style: const TextStyle(color: Color(0xFFE6E6E6))),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      _MiniStat(label: "Time", value: "1h 0min"),
                      SizedBox(width: 16),
                      _MiniStat(label: "Avg bpm", value: "110"),
                      SizedBox(width: 16),
                      _MiniStat(label: "Reps", value: "10"),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ✅ random image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.home5,
                        arguments: imageUrl,
                      ),
                      child: AspectRatio(
                        aspectRatio: 1.25,
                        child: Image.network(imageUrl, fit: BoxFit.cover),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => setState(() {
                          if (isLiked) {
                            likedPostIds.remove(post.id);
                          } else {
                            likedPostIds.add(post.id);
                          }
                        }),
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color:
                              isLiked ? cs.primary : const Color(0xFFE6E6E6),
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Text("120",
                          style: TextStyle(color: Color(0xFFE6E6E6))),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () => _openComments(post),
                        icon: const Icon(Icons.chat_bubble_outline,
                            color: Color(0xFFE6E6E6)),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(post.athlete.avatarUrl),
                        backgroundColor: const Color(0xFF2A2A2A),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Liked by ${post.athlete.username} and others",
                          style: const TextStyle(
                              color: Color(0xFFB0B0B0), fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0B0B0B),
          border: Border(top: BorderSide(color: Color(0xFF222222))),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BottomIcon(
                    icon: Icons.home,
                    label: "Home",
                    active: true,
                    onTap: () => _onBottomNav(0)),
                _BottomIcon(
                    icon: Icons.fitness_center,
                    label: "Workout",
                    active: false,
                    onTap: () => _onBottomNav(1)),
                _BottomIcon(
                    icon: Icons.person_outline,
                    label: "Profile",
                    active: false,
                    onTap: () => _onBottomNav(2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 12)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _BottomIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _BottomIcon({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        active ? const Color(0xFFFF7A1A) : const Color(0xFFB0B0B0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(color: color, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _PostSearchDelegate extends SearchDelegate {
  final List<Post> posts;
  final void Function(Post post) onTapPost;

  _PostSearchDelegate({required this.posts, required this.onTapPost});

  @override
  String get searchFieldLabel => "Search athletes / captions";

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
              onPressed: () => query = '', icon: const Icon(Icons.clear)),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) => _results(context);

  @override
  Widget buildSuggestions(BuildContext context) => _results(context);

  Widget _results(BuildContext context) {
    final q = query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? posts
        : posts.where((p) {
            final athlete =
                '${p.athlete.name} ${p.athlete.username}'.toLowerCase();
            final cap = p.caption.toLowerCase();
            return athlete.contains(q) || cap.contains(q);
          }).toList();

    if (filtered.isEmpty) {
      return const Center(
          child: Text("No athletes found",
              style: TextStyle(color: Colors.white)));
    }

    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) =>
          const Divider(color: Color(0xFF222222), height: 1),
      itemBuilder: (_, i) {
        final post = filtered[i];
        return ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(post.athlete.avatarUrl)),
          title: Text(post.athlete.name,
              style: const TextStyle(color: Colors.white)),
          subtitle: Text(post.athlete.username,
              style: const TextStyle(color: Color(0xFFB0B0B0))),
          onTap: () {
            close(context, null);
            onTapPost(post);
          },
        );
      },
    );
  }
}
