import 'dart:math';
import 'package:athlicare/presentation/pages/ProfilePage/SportSelectionPage.dart';
import 'package:athlicare/presentation/pages/utils/Gender.dart';
import 'package:athlicare/presentation/pages/utils/SportType.dart';
import 'package:athlicare/presentation/pages/utils/Profile.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home_page.dart';
import 'FitnessGoalPage.dart';

class TrainingHoursPage extends StatefulWidget {
  const TrainingHoursPage({Key? key}) : super(key: key);

  @override
  State<TrainingHoursPage> createState() => _TrainingHoursPageState();
}

class _TrainingHoursPageState extends State<TrainingHoursPage> {
  String? selectedHours;

  @override
  void initState() {
    super.initState();
    selectedHours = null; // Reset previous value
  }

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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  FitnessGoalPage()),
                  );
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
                "Training days per week",
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
                  "Select how many days you train in a week to help us customize your workout plan.",
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
                    value: selectedHours,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    dropdownColor: accentOrange,
                    hint: const Text(
                      "Choose",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    items: List<DropdownMenuItem<String>>.generate(
                      7,
                          (index) {
                        final text =
                            "${index + 1} day${index == 0 ? '' : 's'}/week";
                        return DropdownMenuItem<String>(
                          value: text,
                          child: Text(
                            text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedHours = value;
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
                  onPressed: selectedHours == null
                      ? null
                      : () async {
                    final days =
                    int.parse(selectedHours!.split(' ')[0]);
                    final SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                    // Create User instance with SharedPreferences + defaults


                    final profile = Profile(
                      username: prefs.getString("username") ?? "defaultUser",
                      email: FirebaseAuth.instance.currentUser?.email.toString() ?? "default@example.com",
                      hashedPassword: "hashedPassword123",
                      age: prefs.getInt("age") ?? 18,
                      gender: genderFromString(prefs.getString("gender")),
                      height: (prefs.getInt("height") ?? 140).toDouble(),
                      weight: (prefs.getInt("weight") ?? 70).toDouble(),
                      sportType: SportType.fromString(prefs.getString("sportType") ?? "football"),
                      activeDaysPerWeek: days,
                      fitnessGoal: prefs.getString("fitnessGoal") ?? "General Fitness",
                    );
                    print("profile goal: ${profile.fitnessGoal}");
                    print(profile.toString());

                    try {
                      // Save to Firestore with auto-generated ID
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.email.toString())
                          .set(profile.toJson());

                      print('User saved successfully');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FitnessHomePage()),
                      );
                    } catch (e) {
                      print('Error saving user: $e');
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
