import 'package:flutter/material.dart';
import 'package:athlicare/core/constants/colors.dart';

class Header extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onNotificationPressed;

  const Header({
    Key? key,
    this.title = 'Guidness Center',
    this.showBackButton = true,
    this.onBackPressed,
    this.onNotificationPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                // Check if there's a page to pop back to
                if (Navigator.canPop(context)) {
                  if (onBackPressed != null) {
                    onBackPressed!();
                  } else {
                    Navigator.pop(context);
                  }
                } else {
                  // If no page to pop, you can navigate to home or do nothing
                  // Optional: Show a message or navigate to a specific route
                  print('No page to go back to');
                }
              },
            )
          else
            const SizedBox(width: 48), // Placeholder for alignment

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.secondry,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.secondry),
            onPressed:
                onNotificationPressed ??
                () {
                  // Default notification action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No new notifications'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
          ),
        ],
      ),
    );
  }
}
