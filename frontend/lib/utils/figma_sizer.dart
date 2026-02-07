import 'package:flutter/widgets.dart';

/// Scales Figma values (base width 393) to the current device for consistent spacing & sizes.
class FigmaSizer {
  FigmaSizer.of(BuildContext context)
      : size = MediaQuery.of(context).size,
        scaleW = MediaQuery.of(context).size.width / 393.0,
        scaleH = MediaQuery.of(context).size.height / 852.0;

  final Size size;
  final double scaleW;
  final double scaleH;

  double fw(double px) => px * scaleW; // width/spacing
  double fs(double px) => px * scaleW; // font sizes
  double fh(double px) => px * scaleH; // heights
}