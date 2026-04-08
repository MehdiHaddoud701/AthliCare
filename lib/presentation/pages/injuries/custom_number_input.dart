import 'package:flutter/material.dart';

class CustomNumberInput extends StatelessWidget {
  final String label;
  final int value;
  final Function(int) onChanged;
  final int min;
  final int max;
  final Color backgroundColor;
  final Color textColor;
  final Color buttonColor;

  const CustomNumberInput({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 365,
    this.backgroundColor = const Color(0xFF2A2A2A),
    this.textColor = Colors.white,
    this.buttonColor = const Color(0xFFFF6B35),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                color: textColor,
                onPressed: value > min ? () => onChanged(value - 1) : null,
              ),
              Text(
                value.toString(),
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                color: textColor,
                onPressed: value < max ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
