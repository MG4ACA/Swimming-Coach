import 'package:flutter/material.dart';

class ButtonComponent extends StatelessWidget {
  final String buttonText;
  final Function()? onTap;
  const ButtonComponent(
      {super.key, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue.shade600),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 22, color: Colors.white70),
        ),
      ),
    );
  }
}
