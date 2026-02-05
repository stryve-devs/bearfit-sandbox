import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home24ShareScreen extends StatefulWidget {
  final String title;
  final String username;

  const Home24ShareScreen({
    super.key,
    required this.title,
    required this.username,
  });

  // ✅ FIX: route must be a String, not null
  static const String route = '/screen24-share';

  @override
  State<Home24ShareScreen> createState() => _Home24ShareScreenState();
}

class _Home24ShareScreenState extends State<Home24ShareScreen> {
  String _bg = "Dark"; // Light / Dark / Transparent

  void _openInsta1Confirm() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          content: const Text(
            '"Bearfit" wants to open\n"instagram"',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Color(0xFFFF7A1A))),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Opening Instagram Stories (demo)")),
                );
              },
              child: const Text("Open", style: TextStyle(color: Color(0xFFFF7A1A))),
            ),
          ],
        );
      },
    );
  }

  void _openInsta2BackgroundPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  "Pick a background",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _bgChoice("Light"),
                    _bgChoice("Dark"),
                    _bgChoice("Transparent"),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _bgChoice(String label) {
    final selected = _bg == label;
    return InkWell(
      onTap: () {
        setState(() => _bg = label);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Background: $label")),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _openMoreShare() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
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
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 12),
                _sheetItem("Copy caption", () async {
                  Navigator.pop(context);
                  final text = "${widget.title}\n@${widget.username}\n#bearitapp";
                  await Clipboard.setData(ClipboardData(text: text));
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Copied ✅")),
                  );
                }),
                const SizedBox(height: 10),
                _sheetItem("Share to other platforms (demo)", () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Open native share (demo)")),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sheetItem(String title, VoidCallback onTap) {
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
    // ✅ SAFETY: if someone navigates without arguments, show defaults
    final title = (widget.title.isNotEmpty) ? widget.title : "Warm Up";
    final username = (widget.username.isNotEmpty) ? widget.username : "niha";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Share"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Color(0xFFFF7A1A))),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(radius: 16, backgroundColor: Color(0xFF1A1A1A)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text("Personal records", style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12)),
                    const SizedBox(height: 6),
                    Row(
                      children: const [
                        Expanded(child: Text("Best Time", style: TextStyle(color: Colors.white))),
                        Text("-", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text(
                            "SHARE CARD PREVIEW\n(demo)",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFFB0B0B0)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text("BEARIT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                        const Spacer(),
                        Text("@$username", style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        "Share this image and tag @bearitapp",
                        style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _shareIcon(
                          icon: Icons.circle_outlined,
                          label: "Background",
                          onTap: _openInsta2BackgroundPicker,
                        ),
                        const SizedBox(width: 18),
                        _shareIcon(
                          icon: Icons.auto_awesome,
                          label: "Stories",
                          onTap: _openInsta1Confirm,
                        ),
                        const SizedBox(width: 18),
                        _shareIcon(
                          icon: Icons.more_horiz,
                          label: "More",
                          onTap: _openMoreShare,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shareIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
