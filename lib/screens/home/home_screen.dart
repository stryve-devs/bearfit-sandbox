import 'package:flutter/material.dart';
import 'package:flutter_frontend/app/router.dart';
import 'package:flutter_frontend/state/app_state.dart';
import '../../routes/router.dart';

class HomeScreen extends StatefulWidget {
  final AppState appState;

  const HomeScreen({
    super.key,
    required this.appState,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<String> followed = {};
  final TextStyle _smallGrey = const TextStyle(color: Color(0xFFB0B0B0), fontSize: 12);

  void _openProfile(dynamic athlete) {
    Navigator.pushNamed(
      context,
      AppRoutes.profile,
      arguments: athlete,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // If you have athletes in appState, use them.
    // Otherwise this works as UI demo (3 items like your screenshot).
    final athletes = widget.appState.athletes.take(3).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        titleSpacing: 12,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PopupMenuButton<String>(
              offset: const Offset(0, 44),
              color: const Color(0xFF121212),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (value) {
                if (value == 'home') {
                  Navigator.pushNamed(context, AppRoutes.home1);
                } else if (value == 'discover') {
                  Navigator.pushNamed(context, AppRoutes.home3);
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
                        child: Text("Home (Following)", style: TextStyle(color: Colors.white)),
                      ),
                      Icon(Icons.check, size: 18, color: Color(0xFFFF7A1A)),
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
                        child: Text("Discover", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
              child: Row(
                children: const [
                  Text(
                    "Home",
                    style: TextStyle(
                      color: Color(0xFFFF7A1A),
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.keyboard_arrow_down, color: Color(0xFFFF7A1A)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: _AthleteSearchDelegate(
                  athletes: widget.appState.athletes,
                  onTap: (athlete) => _openProfile(athlete), // ✅ open profile from search
                ),
              );
            },
            icon: const Icon(Icons.search, color: Color(0xFFFF7A1A)),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
            icon: const Icon(Icons.notifications_none, color: Color(0xFFFF7A1A)),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: Suggested Athletes + invite a friend
            Row(
              children: [
                const Text(
                  "Suggested Athletes",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.contacts),
                  icon: const Icon(Icons.add, size: 18, color: Color(0xFFFF7A1A)),
                  label: const Text(
                    "invite a friend",
                    style: TextStyle(color: Color(0xFFFF7A1A)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Athlete cards row
            SizedBox(
              height: 165,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: athletes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final a = athletes[i];

                  final athleteKey = a.username; // safe unique key
                  final isFollowed = followed.contains(athleteKey);

                  return GestureDetector(
                    onTap: () => _openProfile(a), // ✅ open profile on card tap
                    child: Container(
                      width: 104,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => _openProfile(a), // ✅ avatar tap
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(a.avatarUrl),
                              backgroundColor: const Color(0xFF2A2A2A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _openProfile(a), // ✅ name tap
                            child: Text(
                              a.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          Text("Feature", style: _smallGrey),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 28,
                            child: OutlinedButton(
                              // ✅ prevent tap from also triggering profile open
                              onPressed: () => setState(() {
                                if (isFollowed) {
                                  followed.remove(athleteKey);
                                } else {
                                  followed.add(athleteKey);
                                }
                              }),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: cs.primary),
                                foregroundColor: cs.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                isFollowed ? "Followed" : "Follow",
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // Center grey placeholders like screenshot
            Center(
              child: Column(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(23),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 240,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 200,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Center(
              child: Text(
                "FOLLOW PEOPLE TO SEE THEIR WORKOUTS IN YOUR FEED.",
                style: const TextStyle(color: Color(0xFF7A7A7A), fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 14),

            // Bottom buttons
            SizedBox(
              width: double.infinity,
              height: 42,
              child: OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.home3),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFF7A1A)),
                  foregroundColor: const Color(0xFFFF7A1A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text("Discover Athletes"),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.contacts),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFF7A1A)),
                  foregroundColor: const Color(0xFFFF7A1A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text("Connect Contacts"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AthleteSearchDelegate extends SearchDelegate {
  final List<dynamic> athletes;
  final void Function(dynamic athlete) onTap;

  _AthleteSearchDelegate({
    required this.athletes,
    required this.onTap,
  });

  @override
  String get searchFieldLabel => "Search athletes";

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
            onPressed: () => query = '',
            icon: const Icon(Icons.clear),
          ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );

  @override
  Widget buildResults(BuildContext context) => _results(context);

  @override
  Widget buildSuggestions(BuildContext context) => _results(context);

  Widget _results(BuildContext context) {
    final q = query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? athletes
        : athletes.where((a) {
            final name = (a.name as String).toLowerCase();
            final username = (a.username as String).toLowerCase();
            return name.contains(q) || username.contains(q);
          }).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text("No athletes found", style: TextStyle(color: Colors.white)),
      );
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (_, i) {
        final a = filtered[i];
        return ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(a.avatarUrl)),
          title: Text(a.name, style: const TextStyle(color: Colors.white)),
          subtitle: Text(a.username, style: const TextStyle(color: Color(0xFFB0B0B0))),
          onTap: () {
            close(context, null);
            onTap(a);
          },
        );
      },
    );
  }
}
