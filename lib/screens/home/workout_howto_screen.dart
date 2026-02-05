import 'package:flutter/material.dart';
import 'package:flutter_frontend/app/router.dart';
import '../../routes/router.dart';

class WorkoutHowToScreen extends StatefulWidget {
  final String title;

  const WorkoutHowToScreen({
    super.key,
    required this.title,
  });

  @override
  State<WorkoutHowToScreen> createState() => _WorkoutHowToScreenState();
}

class _WorkoutHowToScreenState extends State<WorkoutHowToScreen> {
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
              Expanded(
                child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ b7 bottom sheet
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

  // ✅ b9 bottom sheet
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
      Navigator.pop(context); // back to Home6 summary
      return;
    }
    if (tab == "history") {
      Navigator.pushNamed(context, AppRoutes.workoutHistory, arguments: widget.title);
      return;
    }
    // how-to is current screen
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
          onPressed: () => Navigator.pop(context), // ✅ back
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

          // Tabs row (How to selected like screenshot)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _topTab("Summary", false, () => _onTabTap("summary")),
                _topTab("History", false, () => _onTabTap("history")),
                _topTab("How to", true, () {}),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ✅ blank space for workout video (as you said)
          Container(
            height: 180,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0B0B0B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF1A1A1A)),
            ),
            child: const Center(
              child: Text(
                "Workout video preview",
                style: TextStyle(color: Color(0xFF4A4A4A), fontSize: 12),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 14),
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),

                const _StepText("1. Lie down on the bench with your eyes under the bar."),
                const _StepText("2. Hold the bar slightly wider than shoulder width."),
                const _StepText("3. Keep your chest up and shoulders back."),
                const _StepText("4. Unrack the bar and hold it above your chest."),
                const _StepText("5. Lower the bar slowly to the middle of your chest."),
                const _StepText("6. Push the bar back up while breathing out."),
                const _StepText("7. Lock your arms at the top to finish the rep."),
              ],
            ),
          ),

          // Bottom nav (same style)
          Container(
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
                      active: false,
                      onTap: () => _onBottomNav(0),
                    ),
                    _BottomIcon(
                      icon: Icons.fitness_center,
                      label: "Workout",
                      active: true,
                      onTap: () => _onBottomNav(1),
                    ),
                    _BottomIcon(
                      icon: Icons.person_outline,
                      label: "Profile",
                      active: false,
                      onTap: () => _onBottomNav(2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
}

class _StepText extends StatelessWidget {
  final String text;
  const _StepText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, height: 1.35),
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
