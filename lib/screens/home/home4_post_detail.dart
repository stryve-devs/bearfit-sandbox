import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/app/router.dart';
import 'package:flutter_frontend/state/app_state.dart';
import '../../widgets/workout_info_popup.dart';
import '../../routes/router.dart';
import '../../widgets/athlete_avatar.dart';
import '../../widgets/bf_card.dart';
import '../../widgets/bf_bottom_nav.dart';
import '../../data/models/post.dart';

class Home4PostDetail extends StatefulWidget {
  final AppState appState;
  final Post post;

  const Home4PostDetail({
    super.key,
    required this.appState,
    required this.post,
  });

  @override
  State<Home4PostDetail> createState() => _Home4PostDetailState();
}

class _Home4PostDetailState extends State<Home4PostDetail> {
  bool isLiked = false;
  bool isFollowed = false;

  // ✅ ADDED: open Home16 (ProfileScreen) from Home4
  void _openProfile() {
    Navigator.pushNamed(
      context,
      AppRoutes.profile, // Home16 route
      arguments: widget.post.athlete,
    );
  }

  // ✅ ADDED: relative time label instead of fixed date text
  String _relativeTimeLabel() {
    // Demo (no timestamp available in Post model right now)
    return "3 days ago";
  }

  void _showWorkoutPopup({
    required String title,
    required String primary,
    required String secondary,
    required String equipment,
    required List<String> steps,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) => WorkoutInfoPopup(
        title: title,
        primary: primary,
        secondary: secondary,
        equipment: equipment,
        steps: steps,
      ),
    );
  }

  void _openComments() {
    final post = widget.post;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B0B0B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        final comments = post.comments;

        return Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Comments",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              const SizedBox(height: 10),

              // ✅ CHANGED: show something even if empty
              Expanded(
                child: (comments.isEmpty)
                    ? const Center(
                        child: Text(
                          "No comments yet",
                          style: TextStyle(color: Color(0xFFB0B0B0)),
                        ),
                      )
                    : ListView.separated(
                        itemCount: comments.length,
                        separatorBuilder: (_, __) => const Divider(color: Color(0xFF222222), height: 1),
                        itemBuilder: (_, i) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            comments[i],
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
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFF7A1A)),
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

  Future<void> _sharePost() async {
    final text = "BearFit Workout\n@${widget.post.athlete.username}\n${widget.post.caption}";
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied share text to clipboard ✅")),
    );
  }

  void _openMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B0B0B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _menuItem(
                  title: "Save As Routine",
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Saved as routine ✅")),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _menuItem(
                  title: "Copy Workout",
                  onTap: () async {
                    Navigator.pop(context);
                    final text = "Workout copied from @${widget.post.athlete.username}\n${widget.post.caption}";
                    await Clipboard.setData(ClipboardData(text: text));
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Workout copied ✅")),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _menuItem(
                  title: "Report Workout",
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Reported. Thank you ✅")),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _menuItem({required String title, required VoidCallback onTap}) {
    return Material(
      color: const Color(0xFF7A7A7A),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // ✅ back to Home3
        ),
        title: const Text("Workout Routine"),
        actions: [
          IconButton(
            onPressed: _openMoreMenu, // ✅ 3 dots bottom popup
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
        child: Column(
          children: [
            BFCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row (Follow + athlete)
                  Row(
                    children: [
                      // ✅ ADDED: tap avatar -> Home16 Profile
                      GestureDetector(
                        onTap: _openProfile,
                        child: AthleteAvatar(url: post.athlete.avatarUrl),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: GestureDetector(
                          // ✅ ADDED: tap username area -> Home16 Profile
                          onTap: _openProfile,
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.athlete.username,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),

                              // ✅ CHANGED: relative time
                              Text(
                                _relativeTimeLabel(),
                                style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // ✅ CHANGED: Follow button on RIGHT
                      TextButton(
                        onPressed: () => setState(() => isFollowed = !isFollowed),
                        child: Text(
                          isFollowed ? "Followed" : "+ Follow",
                          style: const TextStyle(
                            color: Color(0xFFFF7A1A),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Caption line + stats
                  Text(post.caption, style: const TextStyle(color: Color(0xFFE6E6E6))),
                  const SizedBox(height: 10),

                  Row(
                    children: const [
                      _MiniStat(label: "Time", value: "1h 25min"),
                      SizedBox(width: 16),
                      _MiniStat(label: "Weight taken", value: "400 kgs"),
                      SizedBox(width: 16),
                      _MiniStat(label: "Distance", value: "4.5 km"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Image -> Home5
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.home5, arguments: post.imageUrl),
                      child: AspectRatio(
                        aspectRatio: 1.1,
                        child: Image.network(post.imageUrl, fit: BoxFit.cover),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ✅ CHANGED: Like / Comment / Share row (less congested + counts + share tile)
                  Row(
                    children: [
                      IconButton(
                        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                        padding: EdgeInsets.zero,
                        onPressed: () => setState(() => isLiked = !isLiked),
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? cs.primary : const Color(0xFFE6E6E6),
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Text("100", style: TextStyle(color: Color(0xFFE6E6E6))),

                      const SizedBox(width: 14),

                      IconButton(
                        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                        padding: EdgeInsets.zero,
                        onPressed: _openComments,
                        icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFFE6E6E6)),
                      ),
                      const SizedBox(width: 2),
                      const Text("10", style: TextStyle(color: Color(0xFFE6E6E6))),

                      const Spacer(),

                      IconButton(
                        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                        padding: EdgeInsets.zero,
                        onPressed: _sharePost,
                        icon: const Icon(Icons.ios_share, color: Color(0xFFE6E6E6)),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      const SizedBox(width: 6),
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(post.athlete.avatarUrl),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Liked by ${post.athlete.username} and others",
                          style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // “Muscle Split” bars like screenshot
                  const Text("Muscle Split", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),

                  const _SplitBar(label: "Arms", value: 0.35),
                  const SizedBox(height: 8),
                  const _SplitBar(label: "Core", value: 0.15),
                  const SizedBox(height: 8),
                  const _SplitBar(label: "Shoulders", value: 0.50),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Workout list blocks like screenshot (NOW opens center popup)
            _workoutBlock(
              title: "Bench Press (Barbell)",
              subtitle: "10Kg • 15 reps",
              sets: const ["10Kg • 15 reps", "10Kg • 15 reps", "10Kg • 15 reps"],
              onTap: () => _showWorkoutPopup(
                title: "Bench Press (Barbell)",
                primary: "Chest",
                secondary: "Shoulders, Triceps",
                equipment: "Barbell",
                steps: const [
                  "Lie down on the bench with your eyes under the bar.",
                  "Hold the bar slightly wider than shoulder width.",
                  "Unrack the bar and lower it slowly to your chest.",
                  "Press the bar up with control.",
                  "Repeat for the required reps.",
                ],
              ),
            ),
            const SizedBox(height: 10),
            _workoutBlock(
              title: "Back Extension (Hyperextension)",
              subtitle: "10 reps",
              sets: const ["10 reps", "10 reps"],
              onTap: () => _showWorkoutPopup(
                title: "Back Extension (Hyperextension)",
                primary: "Core",
                secondary: "Shoulders, Triceps",
                equipment: "Dumbbell",
                steps: const [
                  "Set yourself on the hyperextension bench safely.",
                  "Keep spine neutral and core engaged.",
                  "Lower your torso slowly with control.",
                  "Raise back up using your lower back muscles.",
                  "Repeat without jerking.",
                ],
              ),
            ),
            const SizedBox(height: 10),
            _workoutBlock(
              title: "Parallel Bars",
              subtitle: "12 reps",
              sets: const ["12 reps", "12 reps"],
              onTap: () => _showWorkoutPopup(
                title: "Knee Raise Parallel Bars",
                primary: "Core",
                secondary: "Shoulders, Triceps",
                equipment: "Dumbbell",
                steps: const [
                  "Support yourself on the bars with arms locked.",
                  "Lift knees towards chest slowly.",
                  "Lower legs back down with control.",
                  "Avoid swinging your body.",
                  "Repeat for reps.",
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _workoutBlock({
    required String title,
    required String subtitle,
    required List<String> sets,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: BFCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 12)),
            const SizedBox(height: 10),
            ListView.separated(
              itemCount: sets.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          sets[i],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
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
        Text(label, style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 12)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _SplitBar extends StatelessWidget {
  final String label;
  final double value; // 0..1

  const _SplitBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(label, style: const TextStyle(color: Colors.white)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              backgroundColor: const Color(0xFF2A2A2A),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFFF7A1A)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 42,
          child: Text(
            '${(value * 100).round()}%',
            style: const TextStyle(color: Color(0xFFB0B0B0)),
          ),
        ),
      ],
    );
  }
}
