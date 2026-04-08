import 'package:athlicare/presentation/pages/ProfilePage/SportSelectionPage.dart';
import 'package:athlicare/presentation/pages/ProfilePage/WeightSelectionPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeightSelectionPage extends StatefulWidget {
  const HeightSelectionPage({super.key});

  @override
  State<HeightSelectionPage> createState() => _HeightSelectionPageState();
}

class _HeightSelectionPageState extends State<HeightSelectionPage> {
  int selectedHeight = 165;
  late FixedExtentScrollController _controller;

  // COLORS
  final Color bgColor = const Color(0xFF0D0D0D);
  final Color primaryColor = Colors.orange; // light orange for text & border
  final Color accentRed = Colors.orange;    // accent for scroll wheel
  final Color buttonBg = Colors.black;      // button background

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: selectedHeight - 140);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // BACK BUTTON
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WeightSelectionPage()),
                      );
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                    color: primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text('Back', style: TextStyle(color: primaryColor)),
                ],
              ),

              // HEIGHT SELECTION
              Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'What Is Your Height?',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$selectedHeight',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Cm',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 260,
                    child: Center(
                      child: Container(
                        width: 120,
                        decoration: BoxDecoration(
                          color: accentRed,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListWheelScrollView.useDelegate(
                          controller: _controller,
                          itemExtent: 48,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() => selectedHeight = index + 140);
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              final value = index + 140;
                              final isSelected = value == selectedHeight;
                              return Center(
                                child: Text(
                                  '$value',
                                  style: TextStyle(
                                    fontSize: isSelected ? 26 : 18,
                                    fontWeight:
                                    isSelected ? FontWeight.w800 : FontWeight.w600,
                                    color: isSelected ? Colors.white : Colors.white70,
                                  ),
                                ),
                              );
                            },
                            childCount: 81,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // CONFIRM BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final  SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setInt("height", selectedHeight);
                    print(selectedHeight);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SportSelectionPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBg,
                    disabledBackgroundColor: primaryColor.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: primaryColor),
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
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
