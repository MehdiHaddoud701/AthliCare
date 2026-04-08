import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Correct Cubit import
import '../../logic/workout_cubit.dart';

// ✅ ADD THIS - Import MockWorkoutRepository
import '../../data/repositories/mock_workout_repo.dart';

// Correct weekly page
import '../pages/workout/weekly.dart';

// Correct Colors path
import '../../core/constants/colors.dart';

void main() {
  runApp(const TestWorkoutApp());
}

class TestWorkoutApp extends StatelessWidget {
  const TestWorkoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Test App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: BlocProvider(
        // ✅ This should work now
        create: (context) => WorkoutCubit(MockWorkoutRepository()),
        child: const TestHomePage(),
      ),
    );
  }
}

// ... rest of your code stays the same

class TestHomePage extends StatelessWidget {
  const TestHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Test Menu'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or Icon
              const Icon(
                Icons.fitness_center,
                size: 100,
                color: AppColors.primary,
              ),
              const SizedBox(height: 40),

              const Text(
                'Test Your Workout Flow',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Using Mock Data',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),

              // Test Buttons
              _buildTestButton(
                context,
                'Test Weekly Plan',
                'View all days in the week',
                Icons.calendar_today,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<WorkoutCubit>(),
                        child: const WeeklyWorkoutPage(userId: 1),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              _buildTestButton(
                context,
                'Debug Info',
                'View dummy data structure',
                Icons.info_outline,
                () {
                  _showDebugInfo(context);
                },
              ),

              const SizedBox(height: 40),

              // Test Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '📋 Test Checklist:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '✓ Click "Test Weekly Plan"\n'
                      '✓ Select a day (e.g., Day 1)\n'
                      '✓ Click on a workout\n'
                      '✓ Click "Start" on an exercise\n'
                      '✓ Press play to start timer\n'
                      '✓ Wait for timer to finish\n'
                      '✓ Check if exercise shows "Completed"\n'
                      '✓ Complete all exercises in all workouts\n'
                      '✓ Go back to weekly plan\n'
                      '✓ Verify day is removed from list',
                      style: TextStyle(
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.8),
              AppColors.secondry.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  void _showDebugInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Dummy Data Info',
          style: TextStyle(color: AppColors.primary),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                '📊 Data Structure:\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '• 1 User (ID: 1)\n'
                '• 1 Weekly Plan (Week 0)\n'
                '• 4 Days\n'
                '• 4 Workouts\n'
                '• 15 Tasks (exercises)\n\n',
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                '📅 Day Breakdown:\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Day 1: 2 workouts (8 tasks)\n'
                'Day 2: 1 workout (3 tasks)\n'
                'Day 3: 1 workout (4 tasks)\n'
                'Day 4: 2 workouts (7 tasks)\n\n',
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                '⏱️ Task Durations:\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Easy: 30s\n'
                'Moderate: 45-60s\n'
                'High: 40-50s',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}