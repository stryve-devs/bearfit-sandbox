import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/app/router.dart';
import '../../routes/router.dart';

class StatsShareScreen extends StatefulWidget {
  final String title;

  const StatsShareScreen({
    super.key,
    required this.title,
  });

  @override
  State<StatsShareScreen> createState() => _StatsShareScreenState();
}

class _StatsShareScreenState extends State<StatsShareScreen> {
  final _rng = Random();

  late String heaviest;
  late String best1rm;
  late String bestSetVol;
  late String bestSessionVol;

  String bgMode = "Dark"; // Light / Dark / Transparent

  @override
  void initState() {
    super.initState();
    _regen();
  }

  void _regen() {
    final w = _rng.nextInt(80) + 20;
    final r = _rng.nextInt(10) + 1;

    setState(() {
      heaviest = "${w}kg";
      best1rm = "${w + 5}kg";
      bestSetVol = "${w * r}";
      bestSessionVol = "${w * r * 3}";
    });
  }

  void _openInsta1Dialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          content: const Text(
            "“Bearit” wants to open\n“instagram”",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Color(0xFFFF7A1A))),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Opening Instagram… (demo)")),
                );
              },
              child: const Text("Open", style: TextStyle(color: Color(0xFFFF7A1A))),
            ),
          ],
        );
      },
    );
  }

  void _openInsta2BackgroundSheet() {
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
                  "Pick a background",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _bgChoice("Light", bgMode == "Light", () {
                      setState(() => bgMode = "Light");
                      Navigator.pop(context);
                    }),
                    _bgChoice("Dark", bgMode == "Dark", () {
                      setState(() => bgMode = "Dark");
                      Navigator.pop(context);
                    }),
                    _bgChoice("Transparent", bgMode == "Transparent", () {
                      setState(() => bgMode = "Transparent");
                      Navigator.pop(context);
                    }),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _bgChoice(String text, bool selected, VoidCallback onTap) {
    final dotColor = selected ? const Color(0xFFFF7A1A) : const Color(0xFFB0B0B0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(height: 6),
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _openMoreShare() {
    final apps = ["WhatsApp", "Telegram", "Messages", "Gmail", "Instagram", "Snapchat"];
    final pick = apps[_rng.nextInt(apps.length)];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sharing via $pick… (demo)")),
    );
  }

  Color _bgColor() {
    if (bgMode == "Light") return const Color(0xFFF2F2F2);
    if (bgMode == "Transparent") return Colors.transparent;
    return const Color(0xFF0B0B0B);
  }

  Color _cardColor() {
    if (bgMode == "Light") return const Color(0xFFE6E6E6);
    return const Color(0xFF2A2A2A);
  }

  Color _textColor() {
    if (bgMode == "Light") return Colors.black;
    return Colors.white;
  }

  void _goHome15() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.statsShare2,
      arguments: widget.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Share"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Color(0xFFFF7A1A), fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _bgColor(),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF1A1A1A)),
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _cardColor(),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: const Color(0xFFFF7A1A),
                        child: const Icon(Icons.fitness_center, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: TextStyle(color: _textColor(), fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text("Personal Records", style: TextStyle(color: _textColor().withOpacity(0.55), fontSize: 12)),
                  const SizedBox(height: 10),

                  _prRow("Heaviest weight", heaviest),
                  _prRow("Best 1RM", best1rm),
                  _prRow("Best Set Volume", bestSetVol),
                  _prRow("Best Session Volume", bestSessionVol),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: _textColor().withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Center(child: Text("🐻", style: TextStyle(fontSize: 14))),
                          ),
                          const SizedBox(width: 8),
                          Text("BEARIT", style: TextStyle(color: _textColor(), fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const Spacer(),
                      Text("@niha", style: TextStyle(color: _textColor().withOpacity(0.8), fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _dot(active: true, onTap: () {}), // Home14 active
              const SizedBox(width: 8),
              _dot(active: false, onTap: _goHome15), // go Home15
            ],
          ),

          const SizedBox(height: 12),
          const Text(
            "Share this image and tag @bearitapp",
            style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
          ),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _shareIcon(icon: Icons.wallpaper_outlined, label: "Background", onTap: _openInsta2BackgroundSheet),
              const SizedBox(width: 26),
              _shareIcon(icon: Icons.auto_awesome, label: "Stories", onTap: _openInsta1Dialog),
              const SizedBox(width: 26),
              _shareIcon(icon: Icons.more_horiz, label: "More", onTap: _openMoreShare),
            ],
          ),

          const SizedBox(height: 10),

          TextButton(
            onPressed: _regen,
            child: const Text("Regenerate values", style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _prRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: _textColor().withOpacity(0.65), fontSize: 12))),
          Text(value, style: TextStyle(color: _textColor(), fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _dot({required bool active, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active ? const Color(0xFFFF7A1A) : Colors.white,
        ),
      ),
    );
  }

  Widget _shareIcon({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFB0B0B0)),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
