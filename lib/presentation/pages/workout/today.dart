import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../presentation/widgets/CustomBottomNavBar.dart';
import 'weekly.dart';
import 'workoutDetail.dart';

class DailyWorkoutPage extends StatefulWidget {
  final int dayId;

  const DailyWorkoutPage({super.key, required this.dayId});

  @override
  State<DailyWorkoutPage> createState() => _DailyWorkoutPageState();
}

class _DailyWorkoutPageState extends State<DailyWorkoutPage> {
  // ✅ FIXED: workout tab is index 1
  int _selectedIndex = 1;

  final List<Map<String, String>> trainings = [
    {
      'title': 'Cycling Challenge',
      'image': 'sport.jpg',
      'desc':
          'Lorem Ipsum Dolor Sit Amet Consectetur. Magis Pellentesque Felis Ullamcorper Imperdiet.',
    },
    {
      'title': 'Power Squat',
      'image': 'sport.jpg',
      'desc':
          'Lorem Ipsum Dolor Sit Amet Consectetur. Magis Pellentesque Felis Ullamcorper Imperdiet.',
    },
    {
      'title': 'Press Leg Ultimate',
      'image': 'sport.jpg',
      'desc':
          'Lorem Ipsum Dolor Sit Amet Consectetur. Magis Pellentesque Felis Ullamcorper Imperdiet.',
    },
    {
      'title': 'Cycling',
      'image': 'sport.jpg',
      'desc':
          'Lorem Ipsum Dolor Sit Amet Consectetur. Magis Pellentesque Felis Ullamcorper Imperdiet.',
    },
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 4) {
      Navigator.pushNamed(context, '/profile');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/workout');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Workout Plan",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 🔘 Toggle Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WeeklyWorkoutPage(userId: 1),
                        ),
                      );
                    },
                    child: _buildPlanButton('Weekly Plan', false),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {}, // Already on today's page
                    child: _buildPlanButton('Today\'s Plan', true),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Training Of Today',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),
              // 🏋️ Training list
              Expanded(
                child: ListView.builder(
                  itemCount: trainings.length,
                  itemBuilder: (context, index) {
                    final t = trainings[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkoutDetailPage(
                                  workoutId: index + 100, // dummy id for demo
                                  title: t['title']!,
                                  imageUrl: t['image']!,
                                  description: t['desc']!,
                                ),
                          ),
                        );
                      },
                      child: _buildTrainingCard(
                        title: t['title']!,
                        imageUrl: t['image']!,
                        description: t['desc']!,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildPlanButton(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondry : Colors.white10,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.primary, width: 1.2),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.secondry.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 15,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTrainingCard({
    required String title,
    required String imageUrl,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(43, 255, 255, 255),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // Image section
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/$imageUrl',
              width: 110,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
