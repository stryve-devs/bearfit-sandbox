import 'package:flutter/material.dart';

class BFCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const BFCard({super.key, required this.child, this.padding = const EdgeInsets.all(12)});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
