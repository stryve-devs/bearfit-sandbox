import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/app/router.dart';
import '../../routes/router.dart';
import '../../widgets/bf_bottom_nav.dart';

class WorkoutStatsScreen extends StatefulWidget {
  final String title;

  const WorkoutStatsScreen({
    super.key,
    required this.title,
  });

  @override
  State<WorkoutStatsScreen> createState() => _WorkoutStatsScreenState();
}

enum _StatsTab { summary, history, howTo }

class _WorkoutStatsScreenState extends State<WorkoutStatsScreen> {
  _StatsTab tab = _StatsTab.summary;

  String weightUnit = "kg"; // can be kg or lbs
  bool useDefaultUnit = true;

  // random stats
  final _rng = Random();
  String heaviest = "-";
  String oneRepMax = "-";
  String bestSetVol = "-";
  String sessionVol = "-";

  @override
  void initState() {
    super.initState();
    _regenStats();
  }

  void _regenStats() {
    // random values (dummy)
    final w = _rng.nextInt(80) + 20; // 20..99
    final r = _rng.nextInt(10) + 1; // 1..10

    setState(() {
      heaviest = "$w $weightUnit";
      oneRepMax = "${w + 5} $weightUnit";
      bestSetVol = "${(w * r)}";
      sessionVol = "${(w * r * 3)}";
    });
  }

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
              Expanded(
                child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
                    _regenStats();
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
                    _regenStats();
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
                    _regenStats();
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

  void _openB5BulbInfo() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: const Text(
            "When logging weighted bodyweight exercises, you should only log the extra weight you add to the exercise. For example, if you do a Chest Dip (Weighted) with an extra 5kg weight, you should only log the 5kg, not your bodyweight.",
            style: TextStyle(color: Colors.white, height: 1.35),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A1A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("ok"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openB4QuestionInfo() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: const Text(
            "Heaviest Weight\n\nThe heaviest weight you’ve ever lifted.\n\nBest 1RM\n1RM (One Rep Max) uses reps and weight from a set to estimate the max weight you could lift for a single rep.\n\nBest Set Volume\nThe set in which you lifted the most volume (weight x reps).\n\nBest Session Volume\nMax Session Volume is the session you lifted the most weight in total over all your sets in this exercise.",
            style: TextStyle(color: Colors.white, height: 1.35),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A1A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("ok"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onShare() {
    Navigator.pushNamed(context, AppRoutes.statsShare, arguments: widget.title);
  }

  void _onTabTap(_StatsTab next) {
    if (next == _StatsTab.summary) {
      setState(() => tab = _StatsTab.summary);
      return;
    }

    if (next == _StatsTab.history) {
      Navigator.pushNamed(context, AppRoutes.workoutHistory, arguments: widget.title);
      return;
    }

    if (next == _StatsTab.howTo) {
      Navigator.pushNamed(context, AppRoutes.workoutHowTo, arguments: widget.title);
      return;
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // back to Home4
        ),
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _onShare, // share -> new screen
            icon: const Icon(Icons.ios_share),
          ),
          IconButton(
            onPressed: _openB6Menu, // 3 dots -> b6
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        children: [
          // tabs row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _topTab("Summary", tab == _StatsTab.summary, () => _onTabTap(_StatsTab.summary)),
              _topTab("History", false, () => _onTabTap(_StatsTab.history)),
              _topTab("How to", false, () => _onTabTap(_StatsTab.howTo)),
            ],
          ),
          const SizedBox(height: 18),

          Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),

          const Text("Primary : Chest", style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12)),
          const Text("Secondary : Shoulders , Triceps", style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12)),
          const SizedBox(height: 10),

          Row(
            children: [
              InkWell(
                onTap: _onTabTap.bind(_StatsTab.howTo), // not used, keep simple below
                child: const SizedBox(),
              ),
              IconButton(
                onPressed: _openB5BulbInfo,
                icon: const Icon(Icons.lightbulb_outline, color: Color(0xFFB0B0B0)),
              ),
              const SizedBox(width: 4),
              const Text(
                "How to log dumbbell Exercise",
                style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // no data card
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.pets, color: Color(0xFFFF7A1A), size: 42),
                SizedBox(height: 8),
                Text("No data yet", style: TextStyle(color: Color(0xFFB0B0B0))),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // chips row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _chip("Heaviest Weight", () => _regenStats()),
                const SizedBox(width: 8),
                _chip("One Rep Max", () => _regenStats()),
                const SizedBox(width: 8),
                _chip("Best Set Volume", () => _regenStats()),
                const SizedBox(width: 8),
                _chip("Session volume", () => _regenStats()),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Personal records header + question icon
          Row(
            children: [
              const Icon(Icons.emoji_events_outlined, color: Color(0xFFB0B0B0), size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text("Personal Records", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
              IconButton(
                onPressed: _openB4QuestionInfo,
                icon: const Icon(Icons.help_outline, color: Color(0xFFB0B0B0)),
              ),
            ],
          ),

          const SizedBox(height: 6),

          _recordRow("Heaviest weight", heaviest),
          _recordRow("Best 1RM", oneRepMax),
          _recordRow("Best Set Volume", bestSetVol),
          _recordRow("Best Session Volume", sessionVol),
        ],
      ),

      bottomNavigationBar: BfBottomNav(
        currentIndex: 0, // ✅ Home will be orange
        onTap: (i) {},
      ),
    );
  }

  Widget _topTab(String text, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: active ? const Color(0xFFFF7A1A) : const Color(0xFFB0B0B0),
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _chip(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(text, style: const TextStyle(color: Color(0xFFE6E6E6), fontSize: 11)),
      ),
    );
  }

  Widget _recordRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1A1A1A))),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Color(0xFFB0B0B0)))),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
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

extension _BindHack on void Function(_StatsTab) {
  VoidCallback bind(_StatsTab v) => () => this(v);
}
