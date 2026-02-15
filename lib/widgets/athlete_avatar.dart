import 'package:flutter/material.dart';

class AthleteAvatar extends StatelessWidget {
  final String url;
  final double radius;

  // ✅ ADDED: optional tap callback
  final VoidCallback? onTap;

  const AthleteAvatar({
    super.key,
    required this.url,
    this.radius = 18,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(url),
    );

    // ✅ If onTap is null, return normal avatar (no change)
    if (onTap == null) return avatar;

    // ✅ If onTap exists, make it clickable
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius + 8),
      child: avatar,
    );
  }
}
