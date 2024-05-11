import 'package:flutter/material.dart';

class TextComponent extends StatelessWidget {
  final String? hintText;
  final bool? obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final int? maxLines;
  const TextComponent(
      {super.key,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      required this.keyboardType,
      this.suffixIcon,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.0)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(style: BorderStyle.solid)),
            hintText: hintText),
        obscureText: obscureText!,
        maxLines: maxLines,
        controller: controller,
        keyboardType: keyboardType,
      ),
    );
  }
}
