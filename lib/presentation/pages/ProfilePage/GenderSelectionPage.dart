import 'package:athlicare/presentation/pages/ProfilePage/AgeSelectionPage.dart';
import 'package:athlicare/presentation/pages/ProfilePage/WeightSelectionPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenderSelectionPage extends StatefulWidget {
  const GenderSelectionPage({super.key});

  @override
  State<GenderSelectionPage> createState() => _GenderSelectionPageState();
}

class _GenderSelectionPageState extends State<GenderSelectionPage> {
  String? selectedGender;

  // COLORS
  final Color bgColor = const Color(0xFF0D0D0D);
  final Color primaryColor = Colors.orange; // used for button, text
  final Color buttonColor = Colors.black;   // elevated button background
  final Color circleSelected = Colors.deepOrange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button row
              Row(
                children: [
                  IconButton(
                    onPressed: () async {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AgeSelectionPage()),
                      );
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                    color: primaryColor,
                  ),
                  const Text(
                    "Back",
                    style: TextStyle(color: Colors.orange),
                  )
                ],
              ),

              // TITLE + GENDER SELECTION
              Column(
                children: [
                  const SizedBox(height: 10),

                  // 🔹 Title text
                  Text(
                    "Choose your gender",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Male Circle
                  GenderCircle(
                    label: "Male",
                    icon: Icons.male,
                    isSelected: selectedGender == "Male",
                    onTap: () => setState(() => selectedGender = "Male"),
                    selectedColor: circleSelected,
                    bgColor: bgColor,
                  ),

                  const SizedBox(height: 32),

                  // Female Circle
                  GenderCircle(
                    label: "Female",
                    icon: Icons.female,
                    isSelected: selectedGender == "Female",
                    onTap: () => setState(() => selectedGender = "Female"),
                    selectedColor: circleSelected,
                    bgColor: bgColor,
                  ),
                ],
              ),

              // CONTINUE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedGender == null
                      ? null
                      : () async {
                    final  SharedPreferences prefs =  await SharedPreferences.getInstance();
                    prefs.setString("gender", selectedGender!);
                    print("gender:");
                    print(selectedGender);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WeightSelectionPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: primaryColor),
                    ),
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
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

class GenderCircle extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color bgColor;

  const GenderCircle({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? selectedColor : Colors.transparent,
              border: Border.all(
                color: isSelected ? selectedColor : Colors.white24,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected ? Colors.black26 : Colors.black54,
                  blurRadius: isSelected ? 8 : 6,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 72,
              color: isSelected ? bgColor : Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
