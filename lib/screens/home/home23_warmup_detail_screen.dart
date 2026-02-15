import 'package:flutter/material.dart';
import 'package:flutter_frontend/app/router.dart';
import '../../routes/router.dart';
import '../../widgets/bf_bottom_nav.dart';

class Home23WarmUpDetail extends StatelessWidget {
  final String title;
  const Home23WarmUpDetail({super.key, required this.title});

  void _openPop1(BuildContext context) {
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
                Material(
                  color: const Color(0xFF7A7A7A),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Duplicate Exercise (demo)")),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      child: const Text("Duplicate Exercise", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openShare(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.home24,
      arguments: {
        "title": "Warm Up",
        "username": "nihaa",
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Warm up"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => _openShare(context), icon: const Icon(Icons.ios_share)),
          IconButton(onPressed: () => _openPop1(context), icon: const Icon(Icons.more_horiz)),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          // top tabs (History selected)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context), // ✅ Summary -> back to Home22
                      child: const Text(
                        "Summary",
                        style: TextStyle(color: Color(0xFFB0B0B0), fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "History",
                      style: TextStyle(color: const Color(0xFFFF7A1A), fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("No exercise history", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  SizedBox(height: 8),
                  Text(
                    "When you log a workout with this\nexercise, your history will appear here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFB0B0B0)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BfBottomNav(
        currentIndex: 0, // ✅ Home will be orange
        onTap: (i) {},
      ),
    );
  }
}
