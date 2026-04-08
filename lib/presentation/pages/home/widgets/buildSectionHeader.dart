import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

class buildSectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onTap;

  const buildSectionHeader({
    super.key,
    required this.action,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        if (action.isNotEmpty)
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  action,
                  style: const TextStyle(
                    color: Color(0xFFFF6B35),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_right,
                  color: Color(0xFFFF6B35),
                  size: 20,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
