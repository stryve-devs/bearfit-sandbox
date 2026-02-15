import 'package:flutter/material.dart';
import 'workout_colors.dart';

class WT {
  static TextStyle h1(BuildContext c, {Color? color}) => TextStyle(
        fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, height: 20 / 16,
        color: color ?? WorkoutColors.orange,
      );

  static TextStyle h2(BuildContext c, {Color? color}) => TextStyle(
        fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, height: 20 / 16,
        color: color ?? WorkoutColors.orange,
      );

  static TextStyle title(BuildContext c, {Color? color}) => TextStyle(
        fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16, height: 20 / 16,
        color: color ?? WorkoutColors.white,
      );

  static TextStyle body(BuildContext c, {Color? color}) => TextStyle(
        fontFamily: 'Quicksand', fontWeight: FontWeight.w400, fontSize: 16, height: 20 / 16,
        color: color ?? WorkoutColors.white,
      );

  static TextStyle small(BuildContext c, {Color? color, FontWeight weight = FontWeight.w400}) => TextStyle(
        fontFamily: 'Quicksand', fontWeight: weight, fontSize: 12, height: 15 / 12,
        color: color ?? WorkoutColors.white,
      );
}