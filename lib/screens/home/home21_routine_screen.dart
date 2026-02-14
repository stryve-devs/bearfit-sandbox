import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/app/router.dart';
import 'package:flutter_frontend/routes/router.dart';
import 'package:flutter_frontend/data/models/athlete.dart';
import '../../widgets/bf_bottom_nav.dart';

class Home21Routine extends StatefulWidget {
  final Athlete? athlete; // to go back to Home16 when tapping top-right icon

  const Home21Routine({super.key, this.athlete});

  @override
  State<Home21Routine> createState() => _Home21RoutineState();
}

class _Home21RoutineState extends State<Home21Routine> {
  bool _saved = false;

  Future<void> _copyShareText() async {
    const text = "Routine: D2 Upper Body STR + Shoulder Mobility (BearFit)";
    await Clipboard.setData(const ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied routine share text ✅")),
    );
  }

  void _openTab5UnsavedConfirm() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) => Center(
        child: Material(
          color: const Color(0xFF2E2E2E),
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 320,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Save Routine Again ?",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "You've already saved this routine.would like to\nunsave it ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFD0D0D0), fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() => _saved = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Unsaved ✅")),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A1A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Yes"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF6A6A6A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openTab6RehabPopup() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) => Center(
        child: Material(
          color: const Color(0xFF2E2E2E),
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 340,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "This is a custom exercise . if you save this routine\n,this exercise will be automatically copied to your\nexercise",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFEAEAEA), fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A1A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("ok"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSavePressed() {
    if (!_saved) {
      setState(() => _saved = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved ✅")),
      );
    } else {
      _openTab5UnsavedConfirm(); // pressing again opens Tab5
    }
  }

  void _openExercise(String name) {
    // This goes to your Home6 tab screen (Summary/History/How to)
    Navigator.pushNamed(context, AppRoutes.home6, arguments: name);
  }

  void _openWarmup() {
    Navigator.pushNamed(context, AppRoutes.home22);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF7A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text("Routine", style: TextStyle(color: Color(0xFFBFBFBF), fontSize: 13)),
        actions: [
          // You asked: top-right icon takes you to Screen16
          IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.white),
            onPressed: () async {
              // share (copy) + go to Home16 (Profile) if athlete exists
              await _copyShareText();
              if (!mounted) return;
              if (widget.athlete != null) {
                Navigator.pushNamed(context, AppRoutes.profile, arguments: widget.athlete);
              }
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
        children: [
          const Text(
            "D2 UPPER BODY STR + SHOULDER\nMOBILITY",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              CircleAvatar(radius: 10, backgroundColor: Color(0xFF2A2A2A)),
              SizedBox(width: 8),
              Text("Created by star_butterfly",
                  style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 11)),
            ],
          ),
          const SizedBox(height: 12),

          // Save button (shows Saved, press again -> Tab5)
          SizedBox(
            width: double.infinity,
            height: 38,
            child: FilledButton(
              onPressed: _onSavePressed,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2C2C2C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                _saved ? "Saved" : "Save",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 14),
          const Text("Workout", style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12)),
          const SizedBox(height: 10),

          // Warm Up -> Screen22
          _sectionTile(
            iconBg: const Color(0xFF1F1F1F),
            title: "Warm Up",
            subtitle: "1 Set  •  Rest 1min 30s",
            trailing: Icons.chevron_right,
            onTap: _openWarmup,
            extraLines: const ["Shoulders CARs", "Scapular wall slide", "Band Pull-aparts", "Thoracic Rotations"],
          ),

          const SizedBox(height: 10),

          // Exercises -> Home6 (Summary/History/How to)
          _exerciseTile("Bench Press (Barbell)", "2 Sets", onTap: () => _openExercise("Bench Press (Barbell)")),
          _exerciseTile("Kettlebell clean", "3 Sets", onTap: () => _openExercise("Kettlebell clean")),
          _exerciseTile("Face Pull", "3 Sets", onTap: () => _openExercise("Face Pull")),
          _exerciseTile("Kettle shoulder Press", "2 Sets", onTap: () => _openExercise("Kettle shoulder Press")),
          _exerciseTile("Kettlebell windmill", "3 Sets", onTap: () => _openExercise("Kettlebell windmill")),
          _exerciseTile("Shoulder press", "3 Sets", onTap: () => _openExercise("Shoulder press")),

          const SizedBox(height: 10),

          // Rehab -> Tab6 popup
          _sectionTile(
            iconBg: const Color(0xFF1F1F1F),
            title: "Rehab",
            subtitle: "1 Set  •  Rest 1min 30s",
            trailing: Icons.chevron_right,
            onTap: _openTab6RehabPopup,
            extraLines: const [
              "Shoulder external rotation 3\\12 each side",
              "Shoulder Depression hold 3\\20 each",
            ],
          ),
        ],
      ),
      bottomNavigationBar: BfBottomNav(
        currentIndex: 0, // ✅ Home will be orange
        onTap: (i) {},
      ),
    );
  }

  Widget _exerciseTile(String title, String subtitle, {required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFF1A1A1A))),
          ),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7A1A),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 10),
              const CircleAvatar(radius: 14, backgroundColor: Color(0xFF2A2A2A)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: Color(0xFF8A8A8A), fontSize: 11)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF8A8A8A)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTile({
    required Color iconBg,
    required String title,
    required String subtitle,
    required IconData trailing,
    required VoidCallback onTap,
    List<String> extraLines = const [],
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: iconBg,
                child: const Icon(Icons.pets, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        ),
                        Icon(trailing, color: const Color(0xFF8A8A8A)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: Color(0xFF8A8A8A), fontSize: 11)),
                    if (extraLines.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ...extraLines.map((e) => Text(e, style: const TextStyle(color: Color(0xFF6F6F6F), fontSize: 10))),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
