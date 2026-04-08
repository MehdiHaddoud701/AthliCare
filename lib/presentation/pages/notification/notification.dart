import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = {
      "Today": [
        {
          "icon": Icons.fitness_center,
          "color": Colors.orange,
          "title": "New Workout Is Available",
        },
        {
          "icon": Icons.local_drink,
          "color": Colors.redAccent,
          "title": "Don't Forget To Drink Water",
        },
      ],
      "Yesterday": [
        {
          "icon": Icons.emoji_events,
          "color": Colors.red,
          "title": "Upper Body Workout Completed!",
        },
        {
          "icon": Icons.notifications_active,
          "color": Colors.orange,
          "title": "Remember Your Exercise Session",
        },
        {
          "icon": Icons.article,
          "color": Colors.deepOrange,
          "title": "New Nutrition Tip Posted!",
        },
      ],
      "This Week": [
        {
          "icon": Icons.restaurant,
          "color": Colors.redAccent,
          "title": "Don’t Skip Your Protein Meals ",
        },
        {
          "icon": Icons.track_changes,
          "color": Colors.orange,
          "title": "2 Workouts Done — 1 Left This Week ",
        },
      ],
    };

    return Scaffold(
      backgroundColor: Colors.black,
appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Notifications", style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: notifications.entries.map((entry) {
            return _buildSection(entry.key, entry.value);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 254),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: items.map((n) => _buildNotificationCard(n)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> n) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: n["color"].withOpacity(0.2),
            child: Icon(n["icon"], color: n["color"], size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              n["title"],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
