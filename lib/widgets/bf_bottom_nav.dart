import 'package:flutter/material.dart';

class BfBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BfBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF2A2A2A);
    const active = Color(0xFFFF7A1A);
    const inactive = Colors.white;

    return SafeArea(
      child: Padding(
        // ✅ This padding makes it “floating”
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: Container(
          height: 66,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                label: "Home",
                icon: Icons.home_rounded,
                selected: currentIndex == 0,
                activeColor: active,
                inactiveColor: inactive,
                onTap: () => onTap(0),
              ),
              _NavItem(
                label: "Workout",
                icon: Icons.fitness_center_rounded,
                selected: currentIndex == 1,
                activeColor: active,
                inactiveColor: inactive,
                onTap: () => onTap(1),
              ),
              _NavItem(
                label: "Profile",
                icon: Icons.person_outline_rounded,
                selected: currentIndex == 2,
                activeColor: active,
                inactiveColor: inactive,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? activeColor : inactiveColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
