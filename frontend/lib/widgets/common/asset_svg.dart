import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';

class AssetSvg extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final Alignment alignment;

  const AssetSvg({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: rootBundle.loadString(assetPath),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done && snap.hasData) {
          return SvgPicture.string(
            snap.data!,
            width: width,
            height: height,
            fit: fit,
            alignment: alignment,
            colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
          );
        }
        if (snap.hasError) {
          // Clear “not found” fallback: small box with an x
          return Container(
            width: width ?? 20,
            height: height ?? 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.transparent,
              border: Border.all(color: Colors.redAccent),
            ),
            child: const Icon(Icons.close, size: 14, color: Colors.redAccent),
          );
        }
        // Placeholder while loading
        return SizedBox(width: width ?? 20, height: height ?? 20);
      },
    );
  }
}