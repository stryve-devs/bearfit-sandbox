import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/app/router.dart';
import 'package:flutter_frontend/state/app_state.dart';
import '../../routes/router.dart';
import '../../data/models/athlete.dart';
import '../../data/models/post.dart';

class ProfileScreen extends StatefulWidget {
  final AppState appState;
  final Athlete athlete;

  const ProfileScreen({
    super.key,
    required this.appState,
    required this.athlete,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isFollowed = false;

  // for demo likes per post
  final Set<String> likedPostIds = {};
  final Random _rng = Random();

  // graph data (hours)
  final List<double> _hours = [11, 5, 16, 13, 14, 3, 15, 8, 12, 6, 17, 10];
  final List<String> _labels = [
    "Aug15",
    "Aug30",
    "Sep15",
    "Sep30",
    "Oct15",
    "Oct30",
    "Nov15",
    "Nov30",
    "Dec15",
    "Dec30",
    "Jan15",
    "Jan30"
  ];

  void _shareProfile() async {
    final text = "Check out @${widget.athlete.username} on BearFit";
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied share text ✅")),
    );
  }

  void _openTab1MoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B0B0B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                const SizedBox(height: 12),
                _tab1Item("Workout Notifications", () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Workout notifications (demo)")),
                  );
                }),
                const SizedBox(height: 10),
                _tab1Item("Report User", () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Reported (demo) ✅")),
                  );
                }),
                const SizedBox(height: 10),
                _tab1Item("Block User", () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Blocked (demo) ✅")),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _tab1Item(String title, VoidCallback onTap) {
    return Material(
      color: const Color(0xFF7A7A7A),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }

  void _openZoomAvatar() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (_) {
        return Stack(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(widget.athlete.avatarUrl),
                      backgroundColor: const Color(0xFF2A2A2A),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.athlete.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 18,
              right: 18,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openListPopup(String title) {
    final items = List.generate(18, (i) => "$title ${i + 1} • @user${100 + i}");
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B0B0B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Color(0xFF1A1A1A), height: 1),
                    itemBuilder: (_, i) {
                      return ListTile(
                        leading:
                            const CircleAvatar(backgroundColor: Color(0xFF2A2A2A)),
                        title: Text(items[i],
                            style: const TextStyle(color: Colors.white)),
                        trailing: TextButton(
                          onPressed: () {},
                          child: const Text("View",
                              style: TextStyle(color: Color(0xFFFF7A1A))),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onBarTap(int i) {
    final h = _hours[i];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${_labels[i]} • ${h.toStringAsFixed(0)} hrs")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final athlete = widget.athlete;

    // Try to use real posts if you have them:
    final List<Post> posts = (widget.appState.posts)
        .where((p) => p.athlete.username == athlete.username)
        .toList();

    // ✅ CHANGE ONLY HERE: always show at least 3 posts
    final List<Post> demoPosts =
        posts.isNotEmpty ? List<Post>.from(posts) : <Post>[];

    if (demoPosts.length < 3) {
      final need = 3 - demoPosts.length;
      final start = demoPosts.length;
      demoPosts.addAll(List.generate(need, (k) {
        final i = start + k; // continue indexes
        final img =
            "https://picsum.photos/seed/${athlete.username}_${i + 1}/900/900";
        return Post(
          id: "${athlete.username}_p$i",
          athlete: athlete,
          caption: i == 0
              ? "Back + Stuff"
              : (i == 1 ? "leg day , lets goo" : "Loose belly fat"),
          imageUrl: img,
          comments: const ["Nice!", "Good work!", "🔥🔥"],
          exercises: const [
            "Bent Over Row (Barbell)",
            "Lat Pulldown (Cable)",
            "Rear Delt Reverse Fly (Cable)"
          ],
        );
      }));
    }

    final feed = demoPosts;

    final totalHours = _hours.reduce((a, b) => a + b).toStringAsFixed(0);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(athlete.username),
        actions: [
          IconButton(
            onPressed: _shareProfile,
            icon: const Icon(Icons.ios_share),
          ),
          IconButton(
            onPressed: _openTab1MoreMenu,
            icon: const Icon(Icons.more_horiz),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
        children: [
          // top photos row (go to Home17)
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final url =
                    "https://picsum.photos/seed/${athlete.username}_top_$i/300/200";
                return GestureDetector(
                  // ✅ FIXED: send Athlete (Home17 needs Athlete)
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.profileMedia,
                    arguments: athlete,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                        Image.network(url, width: 110, height: 72, fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // profile header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _openZoomAvatar,
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(athlete.avatarUrl),
                  backgroundColor: const Color(0xFF2A2A2A),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      athlete.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _miniCount(
                          label: "Workouts",
                          value: "200",
                          onTap: () => _openListPopup("Workout"),
                        ),
                        const SizedBox(width: 14),
                        _miniCount(
                          label: "Followers",
                          value: "1000",
                          onTap: () => _openListPopup("Follower"),
                        ),
                        const SizedBox(width: 14),
                        _miniCount(
                          label: "Following",
                          value: "30",
                          onTap: () => _openListPopup("Following"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Text(
            "Motivation gets you started, discipline\nkeeps you going.",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            "23 | 170cm | 55kg",
            style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 42,
            child: FilledButton(
              onPressed: () => setState(() => isFollowed = !isFollowed),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF7A1A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(isFollowed ? "Following" : "Follow"),
            ),
          ),

          const SizedBox(height: 14),

          // graph header
          Row(
            children: [
              Text(
                "$totalHours hours",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 8),
              const Text("2 weeks ago", style: TextStyle(color: Color(0xFFB0B0B0))),
            ],
          ),
          const SizedBox(height: 8),

          // bar graph
          SizedBox(
            height: 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_hours.length, (i) {
                final h = _hours[i];
                final pct = (h / 18.0).clamp(0.0, 1.0);
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onBarTap(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 140 * pct,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF7A1A),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _labels[i],
                            style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 9),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 14),

          const Text("Routines",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _routineCard(
                  title: "Upper Body +\nCardio",
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.home21,
                    arguments: athlete,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _routineCard(
                  title: "Lower Body +\nAbs #1",
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.home21,
                    arguments: athlete,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text("Recent Workouts",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),

          ...feed.map((post) => _postCard(post)).toList(),
        ],
      ),
    );
  }

  Widget _miniCount({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _routineCard({required String title, required VoidCallback onTap}) {
    return Material(
      color: const Color(0xFF2A2A2A),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 74,
          padding: const EdgeInsets.all(12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _postCard(Post post) {
    final isLiked = likedPostIds.contains(post.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header row
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(post.athlete.avatarUrl),
                backgroundColor: const Color(0xFF2A2A2A),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Star_butterf",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    SizedBox(height: 2),
                    Text("Monday, Nov 29, 2025 • 6:35",
                        style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(post.caption,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),

          Row(
            children: const [
              Text("Time\n1h 25min",
                  style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 11)),
              SizedBox(width: 18),
              Text("weight taken\n4,000 kg",
                  style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 11)),
              SizedBox(width: 18),
              Text("Sets\n30",
                  style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 11)),
            ],
          ),

          const SizedBox(height: 10),

          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.home4, arguments: post),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 1.05,
                child: Image.network(post.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // actions row like screenshot
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
                  color: isLiked ? const Color(0xFFFF7A1A) : Colors.white,
                ),
              ),
              const Text("100", style: TextStyle(color: Colors.white)),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _openComments(post),
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
              ),
              const Text("10", style: TextStyle(color: Colors.white)),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _sharePost(post),
                icon: const Icon(Icons.send_outlined, color: Colors.white),
              ),
            ],
          ),

          Row(
            children: [
              const SizedBox(width: 8),
              const CircleAvatar(radius: 10, backgroundColor: Color(0xFF2A2A2A)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Liked by darwell and others",
                  style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          TextButton(
            onPressed: () {},
            child: const Text("Show 2 more",
                style: TextStyle(color: Color(0xFFFF7A1A))),
          ),
          const Divider(color: Color(0xFF1A1A1A)),
        ],
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
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Comments",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
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
                        backgroundColor: const Color(0xFFFF7A1A),
                      ),
                      child: const Text("Send"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _sharePost(Post post) async {
    final text = "BearFit Workout\n@${post.athlete.username}\n${post.caption}";
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied share text ✅")),
    );
  }
}
