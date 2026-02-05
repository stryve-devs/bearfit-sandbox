import 'package:flutter/material.dart';
import 'package:flutter_frontend/app/router.dart';
import '../../routes/router.dart';

class Home22WarmUp extends StatefulWidget {
  const Home22WarmUp({super.key});

  @override
  State<Home22WarmUp> createState() => _Home22WarmUpState();
}

class _Home22WarmUpState extends State<Home22WarmUp> {
  void _openPop1() {
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

  void _openTab4() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Center(
            child: Text("Best Time", style: TextStyle(color: Colors.white)),
          ),
          content: const Text(
            "The longest time you have performed this exercise for\nin a give set",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            Center(
              child: SizedBox(
                width: 220,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A1A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("ok", style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openShare() {
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
          IconButton(
            onPressed: _openShare,
            icon: const Icon(Icons.ios_share),
          ),
          IconButton(
            onPressed: _openPop1,
            icon: const Icon(Icons.more_horiz),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          // top tabs (Summary selected)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "Summary",
                      style: TextStyle(
                        color: const Color(0xFFFF7A1A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.home23),
                      child: const Text(
                        "History",
                        style: TextStyle(color: Color(0xFFB0B0B0), fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Warm Up", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  const Text("Primary : Full Body", style: TextStyle(color: Color(0xFFB0B0B0))),
                  const SizedBox(height: 12),
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text("No data yet", style: TextStyle(color: Color(0xFFFF7A1A))),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _chip("Best Time", active: true),
                      const SizedBox(width: 10),
                      _chip("Total Time", active: false),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Text("Personal Records", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      IconButton(
                        onPressed: _openTab4,
                        icon: const Icon(Icons.help_outline, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text("Best Time", style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 6),
                  Container(height: 1, color: const Color(0xFF2A2A2A)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, {required bool active}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: active ? const Color(0xFFFF7A1A) : const Color(0xFF2A2A2A)),
      ),
      child: Text(
        label,
        style: TextStyle(color: active ? const Color(0xFFFF7A1A) : const Color(0xFFB0B0B0), fontSize: 12),
      ),
    );
  }
}
