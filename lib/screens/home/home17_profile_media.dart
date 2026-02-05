import 'package:flutter/material.dart';
import 'package:flutter_frontend/app/router.dart';
import 'package:flutter_frontend/state/app_state.dart';
import '../../data/models/athlete.dart';
import '../../data/models/post.dart';

class Home17ProfileMedia extends StatelessWidget {
  final AppState appState;
  final Athlete athlete;

  const Home17ProfileMedia({
    super.key,
    required this.appState,
    required this.athlete,
  });

  void _openTab3(BuildContext context) {
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
                _item(context, "Save As Routine"),
                const SizedBox(height: 10),
                _item(context, "Copy Workout"),
                const SizedBox(height: 10),
                _item(context, "Report Workout"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _item(BuildContext context, String title) {
    return Material(
      color: const Color(0xFF7A7A7A),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$title (demo) ✅")),
          );
        },
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
    // ✅ 2 media items like your screenshot (add more if you want)
    final media = [
      _MediaItem(
        title: "Back + Stuff",
        imageUrl: "https://picsum.photos/seed/${athlete.username}_m1/900/900",
        route: AppRoutes.home18,
      ),
      _MediaItem(
        title: "Loose Belly fat",
        imageUrl: "https://picsum.photos/seed/${athlete.username}_m2/900/900",
        route: AppRoutes.home19,
      ),
      // If you want 3rd item -> goes to Home20
      // _MediaItem(
      //   title: "Abs Burner",
      //   imageUrl: "https://picsum.photos/seed/${athlete.username}_m3/900/900",
      //   route: AppRoutes.home20,
      // ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("${athlete.name}'s Media"),
        actions: [
          IconButton(
            onPressed: () => _openTab3(context),
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
        itemCount: media.length,
        itemBuilder: (_, i) {
          final item = media[i];

          // ✅ Create a Post to send to Home18/19/20
          final post = Post(
            id: "${athlete.username}_media_$i",
            athlete: athlete,
            caption: item.title,
            imageUrl: item.imageUrl,
            comments: const ["Nice!", "🔥🔥", "Good work!"],
            exercises: const ["Bench Press (Barbell)", "Back Extension (Hyperextension)", "Knee Raise Parallel Bars"],
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(item.imageUrl, width: double.infinity, height: 240, fit: BoxFit.cover),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF0B0B0B),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, item.route, arguments: post),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MediaItem {
  final String title;
  final String imageUrl;
  final String route;

  _MediaItem({
    required this.title,
    required this.imageUrl,
    required this.route,
  });
}
