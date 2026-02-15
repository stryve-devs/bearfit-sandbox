import 'package:flutter/material.dart';
import 'package:flutter_frontend/app/router.dart';
import '../../routes/router.dart';
import '../../widgets/bf_bottom_nav.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  final String title;     // e.g. "Bench Press (Barbell)"
  final String username;  // passed from Home6 if you want (not required for empty UI)

  const WorkoutHistoryScreen({
    super.key,
    required this.title,
    required this.username,
  });

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  String weightUnit = "kg";
  bool useDefaultUnit = true;

  // ✅ share icon (same as Home6)
  void _onShare() {
    Navigator.pushNamed(context, AppRoutes.statsShare, arguments: widget.title);
  }

  // ✅ 3 dots -> b6 (same as Home6)
  void _openB6Menu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B0B0B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
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

                _b6Item(
                  leading: Text(
                    weightUnit,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  title: "Weight Units",
                  onTap: () {
                    Navigator.pop(context);
                    _openB7WeightUnits();
                  },
                ),
                const SizedBox(height: 10),

                _b6Item(
                  leading: const Icon(Icons.copy, color: Colors.white),
                  title: "Duplicate Exercise",
                  onTap: () {
                    Navigator.pop(context);
                    _openB9Duplicate();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _b6Item({
    required Widget leading,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFF7A7A7A),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              SizedBox(width: 24, child: Center(child: leading)),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14))),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ b7
  void _openB7WeightUnits() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B0B0B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
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
                const Text(
                  "Weight Units",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                Text(
                  widget.title,
                  style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
                ),
                const SizedBox(height: 12),

                _b7Option(
                  title: "Default (kg)",
                  selected: useDefaultUnit,
                  onTap: () {
                    setState(() {
                      useDefaultUnit = true;
                      weightUnit = "kg";
                    });
                    Navigator.pop(context);
                  },
                ),
                _b7Option(
                  title: "kg",
                  selected: !useDefaultUnit && weightUnit == "kg",
                  onTap: () {
                    setState(() {
                      useDefaultUnit = false;
                      weightUnit = "kg";
                    });
                    Navigator.pop(context);
                  },
                ),
                _b7Option(
                  title: "lbs",
                  selected: !useDefaultUnit && weightUnit == "lbs",
                  onTap: () {
                    setState(() {
                      useDefaultUnit = false;
                      weightUnit = "lbs";
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _b7Option({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: const Color(0xFF7A7A7A),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Expanded(child: Text(title, style: const TextStyle(color: Colors.white))),
                if (selected) const Icon(Icons.check, color: Color(0xFFFF7A1A)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ b9
  void _openB9Duplicate() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B0B0B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                Text(
                  "Duplicate “${widget.title}” ?",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF7A7A7A)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Exercise duplicated ✅")),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7A1A),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Continue"),
                      ),
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

  void _onTabTap(String tab) {
    if (tab == "summary") {
      Navigator.pop(context); // ✅ back to Home6 summary
      return;
    }
    if (tab == "howto") {
      Navigator.pushNamed(context, AppRoutes.workoutHowTo, arguments: widget.title);
      return;
    }
    // history is current screen
  }

  void _onBottomNav(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, AppRoutes.home1);
      return;
    }
    if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Workout tapped")));
      return;
    }
    if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile tapped")));
      return;
    }
  }

  // ✅ NEW (ONLY USED INSIDE HISTORY BODY): demo data for ONLY ONE exercise
  bool get _showDemoGraph => widget.title.trim().toLowerCase() == "bench press (barbell)".toLowerCase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // ✅ back to Home6
        ),
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _onShare,
            icon: const Icon(Icons.ios_share),
          ),
          IconButton(
            onPressed: _openB6Menu,
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 8),

          // Tabs row (History selected like screenshot)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _topTab("Summary", false, () => _onTabTap("summary")),
                _topTab("History", true, () {}),
                _topTab("How to", false, () => _onTabTap("howto")),
              ],
            ),
          ),

          const SizedBox(height: 26),

          // ✅ CHANGED ONLY THIS PART:
          Expanded(
            child: _showDemoGraph ? _demoGraphBody() : _emptyHistoryBody(),
          ),

        ],
      ),
      bottomNavigationBar: BfBottomNav(
        currentIndex: 0, // ✅ Home will be orange
        onTap: (i) {},
      ),
    );
  }

  // ✅ your old empty UI (unchanged)
  Widget _emptyHistoryBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            "No exercise history",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            "When you log a workout with this\nexercise, your history will appear here.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  // ✅ demo graph body (only for Bench Press)
  Widget _demoGraphBody() {
    // Example workout history: (date label, weight)
    final data = <Map<String, dynamic>>[
      {"d": "Jan", "w": 30},
      {"d": "Feb", "w": 35},
      {"d": "Mar", "w": 40},
      {"d": "Apr", "w": 42},
      {"d": "May", "w": 45},
    ];

    final maxW = data.map((e) => e["w"] as int).reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Example history (demo)",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Top set weight ($weightUnit)",
                  style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 160,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(data.length, (i) {
                      final w = data[i]["w"] as int;
                      final label = data[i]["d"] as String;
                      final pct = (w / maxW).clamp(0.0, 1.0);

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 140 * pct,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF7A1A),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(label, style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 11)),
                              const SizedBox(height: 2),
                              Text("$w", style: const TextStyle(color: Colors.white, fontSize: 11)),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            "Latest sessions",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: ListView.separated(
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final daysAgo = [2, 5, 9, 14][i];
                final w = [45, 42, 40, 35][i];

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$w $weightUnit",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "$daysAgo days ago",
                              style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward, color: Color(0xFFB0B0B0)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _topTab(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFFB0B0B0),
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          if (selected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 30,
              color: const Color(0xFFFF7A1A),
            ),
        ],
      ),
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
    final color = active ? const Color(0xFFFF7A1A) : const Color(0xFFB0B0B0);

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
