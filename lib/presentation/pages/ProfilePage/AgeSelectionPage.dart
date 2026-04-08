import 'package:athlicare/presentation/pages/LoginSignInPages/SetupPage.dart';
import 'package:athlicare/presentation/pages/ProfilePage/GenderSelectionPage.dart';
import 'package:athlicare/presentation/pages/ProfilePage/UserNameSelectionPage.dart';
import 'package:athlicare/presentation/pages/ProfilePage/WeightSelectionPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgeSelectionPage extends StatefulWidget {
  const AgeSelectionPage({super.key});

  @override
  State<AgeSelectionPage> createState() => _AgeSelectionPageState();
}

class _AgeSelectionPageState extends State<AgeSelectionPage> {
  int selectedAge = 28;
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: selectedAge - 10);
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0D0D0D);
    const lightOrange = Color(0xFFFF9100);
    const darkOrange = Color(0xFFFF6D00);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const UsernameSelectionPage()),
                              );
                            },
                            icon: const Icon(Icons.arrow_back_ios),
                            color: darkOrange,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Back',
                            style: TextStyle(color: Color(0xFFFF7A3D)),
                          ),
                        ],
                      ),

                      // Age Picker
                      Column(
                        children: [
                          Text(
                            'How Old Are You?',
                            style: TextStyle(
                              color: darkOrange,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '$selectedAge',
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
                                setState(() {
                                  selectedAge = index + 10;
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  final age = index + 10;
                                  final isSelected = age == selectedAge;
                                  return Center(
                                    child: Text(
                                      '$age',
                                      style: TextStyle(
                                        fontSize: isSelected ? 28 : 20,
                                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                        color: isSelected ? Colors.white : Colors.white70,
                                      ),
                                    ),
                                  );
                                },
                                childCount: 100,
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
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              prefs.setInt('age', selectedAge);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GenderSelectionPage(),
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
          },
        ),
      ),
    );
  }
}
