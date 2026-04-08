import 'package:athlicare/presentation/pages/notification/notification.dart';
import 'package:athlicare/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

Widget buildHeader(BuildContext context, {String userName = 'Madison'}) {
  final l10n = AppLocalizations.of(context)!;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        margin: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(7),
              child: Text(
                l10n.hiUser(userName),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B35),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.challengeLimits,
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ),
      ),

      // 🔔 Notification icon
      Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationPage()),
            );
          },
          child: const Icon(
            Icons.notifications,
            color: Color(0xFFFF6B35),
            size: 28,
          ),
        ),
      ),
    ],
  );
}
