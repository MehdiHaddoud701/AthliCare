import 'package:flutter/material.dart';

class RecoveryProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color backgroundColor;
  final Color progressColor;
  final Color textColor;
  final List<String> stages;

  const RecoveryProgressBar({
    Key? key,
    required this.progress,
    this.backgroundColor = const Color(0xFF2A2A2A),
    this.progressColor = const Color(0xFFFF6B35),
    this.textColor = Colors.white,
    this.stages = const ['Rest', 'Rehabilitation', 'Return to Play'],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recovery Progress',
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        // Progress Bar
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Stage Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: stages.map((stage) {
            return Text(
              stage,
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12),
            );
          }).toList(),
        ),
      ],
    );
  }
}
