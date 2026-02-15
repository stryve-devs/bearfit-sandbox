import 'dart:math' as math;
import 'package:flutter/widgets.dart';

class WorkoutLayout {
  static const double contentMaxW = 369;
  static const double contentMinW = 220;
  static const double pageHPad = 12;

  static double contentWidth(BuildContext context) {
    final w = MediaQuery.of(context).size.width - pageHPad * 2;
    return math.min(contentMaxW, math.max(contentMinW, w));
  }
}