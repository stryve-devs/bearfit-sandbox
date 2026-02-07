/*import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hint;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: AppColors.grey),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey),
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType keyboardType;
  final String? errorText;
  final bool compact;
  final bool useFloatingLabel;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.compact = false,
    this.useFloatingLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!useFloatingLabel) ...[
            Text(label, style: const TextStyle(color: AppColors.white)),
            const SizedBox(height: 6),
          ],
          TextField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: TextStyle(color: AppColors.white, fontSize: compact ? 14 : 16),
            decoration: InputDecoration(
              hintText: hint,
              labelText: useFloatingLabel ? label : null,
              labelStyle: useFloatingLabel ? const TextStyle(color: AppColors.grey) : null,
              floatingLabelStyle: useFloatingLabel ? const TextStyle(color: AppColors.orange) : null,
              hintStyle: const TextStyle(color: AppColors.grey),
              suffixIcon: suffix,
              suffixIconConstraints: BoxConstraints(
                minWidth: compact ? 24 : 40,
                minHeight: compact ? 24 : 40,
              ),
              isDense: compact,
              filled: true,
              fillColor: const Color(0xFF2D2C2C),
              contentPadding: EdgeInsets.symmetric(
                vertical: compact ? 10 : 16,
                horizontal: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: errorText != null ? const Color(0xFFD22B2B) : Colors.transparent,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: errorText != null ? const Color(0xFFD22B2B) : AppColors.orange,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD22B2B)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD22B2B)),
              ),
            ),
          ),
          if (errorText != null && errorText!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              errorText!,
              style: const TextStyle(color: Color(0xFFD22B2B), fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

