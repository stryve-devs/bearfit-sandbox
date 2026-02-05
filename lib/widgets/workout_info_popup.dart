import 'package:flutter/material.dart';
import 'package:flutter_frontend/app/router.dart';
import '../routes/router.dart';

class WorkoutInfoPopup extends StatelessWidget {
  final String title;
  final String primary;
  final String secondary;
  final String equipment;
  final List<String> steps;

  // ✅ new (for stats navigation)
  final String statsTitle;

  const WorkoutInfoPopup({
    super.key,
    required this.title,
    required this.primary,
    required this.secondary,
    required this.equipment,
    required this.steps,
    this.statsTitle = "Workout Stats",
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SizedBox(
        width: 340,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // top row (title + X)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // icon placeholder
              Container(
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.fitness_center, color: Colors.black, size: 70),
              ),

              const SizedBox(height: 12),

              _kv("Primary", primary),
              _kv("Secondary", secondary),
              _kv("Equipment", equipment),

              const SizedBox(height: 12),

              // ✅ How to + See your stats row (as in screenshot)
              Row(
                children: [
                  Text(
                    "How to",
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context); // close popup first
                      Navigator.pushNamed(
                        context,
                        AppRoutes.workoutStats,
                        arguments: statsTitle,
                      );
                    },
                    child: const Text(
                      "See Your Stats",
                      style: TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Container(
                constraints: const BoxConstraints(maxHeight: 180),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: steps.length,
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        "${i + 1}. ${steps[i]}",
                        style: const TextStyle(color: Color(0xFFE6E6E6), fontSize: 12, height: 1.35),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 42,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A1A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Done"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(k, style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 12)),
          ),
          Expanded(
            child: Text(v, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
