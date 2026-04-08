import 'package:athlicare/presentation/pages/ProfilePage/FitnessGoalPage.dart';
import 'package:athlicare/presentation/pages/ProfilePage/HeightSelectionPage.dart';
import 'package:athlicare/presentation/pages/ProfilePage/TrainingHourSelectionPage.dart';
import 'package:athlicare/presentation/pages/ProfilePage/WeightSelectionPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SportSelectionPage extends StatefulWidget {
  const SportSelectionPage({Key? key}) : super(key: key);

  @override
  State<SportSelectionPage> createState() => _SportSelectionPageState();
}

class _SportSelectionPageState extends State<SportSelectionPage> {
  String? selectedSport;

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0D0D0D);
    const lightOrange = Color(0xFFFF9100); // Age bar background
    const darkOrange = Color(0xFFFF6D00);  // Text color

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HeightSelectionPage()),
                  );
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: darkOrange,
                  size: 20,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                "What Is Your Sport?",
                style: TextStyle(
                  color: darkOrange,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 50),

            // Sport options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  sportOption("Football"),
                  const SizedBox(height: 20),
                  // Add more sports if needed
                  // sportOption("Swimming"),
                ],
              ),
            ),

            const Spacer(),

            // Continue button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: darkOrange, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor:
                    selectedSport == null ? Colors.white10 : Colors.transparent,
                  ),
                  onPressed: selectedSport == null
                      ? null // Disabled if no sport selected
                      : () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString("sportType", selectedSport!);
                    print("Selected Sport: $selectedSport");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FitnessGoalPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      // Make text slightly dimmed if disabled
                      color: selectedSport == null ? Colors.white54 : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sportOption(String sport) {
    final isSelected = selectedSport == sport;
    return GestureDetector(
      onTap: () {
        setState(() => selectedSport = sport);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.orange, width: 1.2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              sport,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                color: isSelected ? Colors.white : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
