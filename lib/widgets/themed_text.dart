import 'package:flutter/material.dart';

class ThemedText extends StatelessWidget {
  final String text;
  const ThemedText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge,
      textAlign: TextAlign.center,
    );
  }
}
