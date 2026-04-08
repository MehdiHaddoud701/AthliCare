import 'package:athlicare/presentation/pages/ProfilePage/GenderSelectionPage.dart';
import 'package:athlicare/presentation/pages/ProfilePage/HeightSelectionPage.dart';
import 'package:athlicare/presentation/pages/ProfilePage/SportSelectionPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeightSelectionPage extends StatefulWidget {
  const WeightSelectionPage({super.key});

  @override
  State<WeightSelectionPage> createState() => _WeightSelectionPageState();
}

class _WeightSelectionPageState extends State<WeightSelectionPage> {
  int selectedWeight = 70; // Default weight
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: selectedWeight - 30);
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0D0D0D);
    const lightOrange = Color(0xFFFF9100); // Wheel background
    const darkOrange = Color(0xFFFF6D00);  // Text color
    const orange = Color(0xFFFF7A3D);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GenderSelectionPage()),
                      );
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                    color: darkOrange,
                  ),
                  const SizedBox(width: 8),
                  const Text('Back', style: TextStyle(color: orange)),
                ],
              ),

              // Weight Picker
              Column(
                children: [
                  Text(
                    'What Is Your Weight?',
                    style: TextStyle(
                      color: darkOrange,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Kg',
                    style: TextStyle(
                      color: orange,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$selectedWeight',
                    style: TextStyle(
                      color: darkOrange,
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 220,
                    width: 160,
                    decoration: BoxDecoration(
                      color: lightOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListWheelScrollView.useDelegate(
                      controller: _controller,
                      itemExtent: 50,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() => selectedWeight = index + 30);
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          final weight = index + 30;
                          final isSelected = weight == selectedWeight;
                          return Center(
                            child: Text(
                              '$weight',
                              style: TextStyle(
                                fontSize: isSelected ? 28 : 20,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected ? Colors.white : Colors.white70,
                              ),
                            ),
                          );
                        },
                        childCount: 171,
                      ),
                    ),
                  ),
                ],
              ),

              // Continue Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: darkOrange, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      // Navigate to the next page
                      final  SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setInt("weight",selectedWeight);
                      print(selectedWeight);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HeightSelectionPage(),
                        ),
                      );
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
      ),
    );
  }
}
