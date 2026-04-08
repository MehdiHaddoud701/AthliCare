// 📄 FILE: lib/pages/MealPlansPage.dart
// ======================================================
// 🧭 SCREEN: Meal Plans List Screen
// DESC: Displays available meal plans with dummy demo data.
// ======================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MealPlansPage extends StatelessWidget {
  const MealPlansPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),

      // ======================================================
      // 🔺 APP BAR
      // ======================================================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,

        // 🔙 BACK BUTTON
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            // TODO_NAV_BACK: Handle back navigation (Navigator.pop)
          },
        ),

        // 🟥 TITLE
        title: Text(
          'Meal Plans',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFFFF1E00), // red accent
          ),
        ),

        // 🔔 NOTIFICATION ICON
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFFFF1E00)),
            onPressed: () {
              // TODO_ACTION_BELL: Handle notification icon press
            },
          ),
        ],
      ),

      // ======================================================
      // 📜 BODY
      // ======================================================
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Plan',
              style: GoogleFonts.poppins(color: Colors.white54),
            ),
            const SizedBox(height: 6),
            Text(
              'Know your plan',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // 🔻 PLAN LIST
            Expanded(
              child: ListView(
                children: const [
                  _PlanCard(
                    title: 'Keto Friendly',
                    subtitle: 'High fat • Low carb',
                    calories: '1200 kcal',
                  ),
                  SizedBox(height: 12),
                  _PlanCard(
                    title: 'Balanced',
                    subtitle: 'Protein • Veggies',
                    calories: '1500 kcal',
                  ),
                  SizedBox(height: 12),
                  _PlanCard(
                    title: 'Vegan',
                    subtitle: 'Plant based goodness',
                    calories: '1300 kcal',
                  ),
                  SizedBox(height: 12),
                  _PlanCard(
                    title: 'Mediterranean',
                    subtitle: 'Healthy fats • Fish',
                    calories: '1400 kcal',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ======================================================
      // 🔻 BOTTOM NAV BAR
      // ======================================================
      // bottomNavigationBar: CustomBottomNav(
      //   currentIndex: 1,
      //   onTap: (i) {
      //     // TODO_NAV_BOTTOM: Handle bottom nav tap (navigate to other pages)
      //   },
      // ),
    );
  }
}

// ======================================================
// 🧱 PLAN CARD WIDGET
// ======================================================
class _PlanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String calories;

  const _PlanCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.calories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO_NAV_PLAN_DETAILS: Navigate to MealListPage (plan details)
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF121214),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // 🖼️ PLAN IMAGE
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  // TODO_ASSET_THUMBNAIL: Replace with actual plan image
                  image: AssetImage('assets/images/placeholder.jpg'),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 📋 PLAN INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(color: Colors.white54),
                  ),
                ],
              ),
            ),

            // 🔥 CALORIES + BUTTON
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  calories,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF1E00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // TODO_ACTION_START_PLAN: Start selected meal plan
                  },
                  child: Text('Start', style: GoogleFonts.poppins()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
