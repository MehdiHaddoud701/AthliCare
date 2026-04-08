import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final IconData? icon;
  final VoidCallback? onIconTap;

  const SectionHeader({
    Key? key,
    required this.title,
    this.textColor = Colors.white,
    this.fontSize = 20,
    this.fontWeight = FontWeight.bold,
    this.icon,
    this.onIconTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
        if (icon != null)
          IconButton(
            icon: Icon(icon, color: textColor),
            onPressed: onIconTap,
          ),
      ],
    );
  }
}
