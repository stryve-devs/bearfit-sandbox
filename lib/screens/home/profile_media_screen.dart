import 'package:flutter/material.dart';
import 'package:flutter_frontend/app/router.dart';
import '../../routes/router.dart';

class Home17ProfileMedia extends StatelessWidget {
  final String username;

  const Home17ProfileMedia({
    super.key,
    required this.username,
  });

  void _openTab3(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _tabItem(context, "Save As Routine"),
              _tabItem(context, "Copy Workout"),
              _tabItem(context, "Report Workout"),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _tabItem(BuildContext context, String title) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$title (demo)")),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaItems = [
      {
        "title": "Back + Stuff",
        "image": "https://picsum.photos/seed/back/900/700",
        "route": AppRoutes.home18,
      },
      {
        "title": "Loose Belly fat",
        "image": "https://picsum.photos/seed/belly/900/700",
        "route": AppRoutes.home19,
      },
      {
        "title": "Core Strength",
        "image": "https://picsum.photos/seed/core/900/700",
        "route": AppRoutes.home20,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Workout Detail"), // ✅ FIXED TITLE
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () => _openTab3(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: mediaItems.length,
        itemBuilder: (_, i) {
          final item = mediaItems[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    item["image"] as String,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, item["route"] as String);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item["title"] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
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
