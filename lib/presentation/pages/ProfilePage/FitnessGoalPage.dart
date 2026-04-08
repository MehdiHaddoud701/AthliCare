import 'package:athlicare/presentation/pages/ProfilePage/SportSelectionPage.dart';
import 'package:athlicare/presentation/pages/ProfilePage/TrainingHourSelectionPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FitnessGoalPage extends StatefulWidget {
  const FitnessGoalPage({Key? key}) : super(key: key);

  @override
  State<FitnessGoalPage> createState() => _FitnessGoalPageState();
}

class _FitnessGoalPageState extends State<FitnessGoalPage> {
  String? selectedGoal;

  final List<String> goals = [
    "Improve overall fitness",
    "Lose weight",
    "Build muscle",
    "Increase stamina",
    "Improve skills",
    "Track my performance",
    "Stay motivated",
    "Learn new exercises",
    "Avoid injuries",
    "Join challenge/competition",
  ];

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF0D0D0D);
    const accentOrange = Color(0xFFFF7A3D);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SportSelectionPage()),
                  )
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                "What's your fitness goal?",
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  "Select your main goal so we can customize your workout plan accordingly.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Dropdown
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: accentOrange,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedGoal,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    dropdownColor: accentOrange,
                    hint: const Text(
                      "Choose your goal",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    items: goals
                        .map(
                          (goal) => DropdownMenuItem<String>(
                        value: goal,
                        child: Text(
                          goal,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGoal = value;
                      });
                    },
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Continue Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.orange, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: selectedGoal == null
                      ? null
                      : () async {
                    final prefs =
                    await SharedPreferences.getInstance();
                    await prefs.setString("fitnessGoal", selectedGoal!);

                    try {
                      // Optionally save to Firestore


                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TrainingHoursPage()),
                      );
                    } catch (e) {
                      print('Error saving goal: $e');
                    }
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
}
