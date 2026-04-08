import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/colors.dart';
import '../../../logic/workout_cubit.dart';

class ProgressTrackingPage extends StatefulWidget {
  const ProgressTrackingPage({Key? key}) : super(key: key);

  @override
  State<ProgressTrackingPage> createState() => _ProgressTrackingPageState();
}

class _ProgressTrackingPageState extends State<ProgressTrackingPage> {
  Map<String, dynamic>? weekProgress;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeekProgress();
  }

  Future<void> _loadWeekProgress() async {
    setState(() => isLoading = true);
    try {
      final workoutCubit = context.read<WorkoutCubit>();
      final progress = await workoutCubit.getCurrentWeekProgress(1); // User ID 1
      setState(() {
        weekProgress = progress;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading week progress: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF111111),
        appBar: AppBar(
          backgroundColor: const Color(0xFF111111),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.orange),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Progress Tracking",
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (weekProgress == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF111111),
        appBar: AppBar(
          backgroundColor: const Color(0xFF111111),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.orange),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Progress Tracking",
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'No workout plan found',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadWeekProgress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final weekNumber = weekProgress!['weekNumber'] as int;
    final totalCompletedTasks = weekProgress!['totalCompletedTasks'] as int;
    final totalTasks = weekProgress!['totalTasks'] as int;
    final totalCalories = weekProgress!['totalCalories'] as int;
    final weekCompletion = weekProgress!['weekCompletion'] as double;
    final List<dynamic> dayProgressList = weekProgress!['dayProgress'] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Progress Tracking",
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌹 Week Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary.withOpacity(0.8), AppColors.secondry],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Week $weekNumber Progress',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                        '${weekCompletion.round()}%',
                        'Completed',
                        Icons.check_circle,
                      ),
                      _buildStatItem(
                        '$totalCompletedTasks/$totalTasks',
                        'Tasks Done',
                        Icons.assignment_turned_in,
                      ),
                      _buildStatItem(
                        '$totalCalories',
                        'Calories',
                        Icons.local_fire_department,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const SizedBox(height: 15),

            // 📊 Chart Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: AppColors.primary, width: 1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Daily Completion %",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 220,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) => FlLine(
                                  color: Colors.white10,
                                  strokeWidth: 1,
                                )),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            axisNameWidget: const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                "",
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                if (index < dayProgressList.length &&
                                    dayProgressList[index]['day'] != null) {
                                  return Text(
                                    dayProgressList[index]['day'].toString().replaceAll('Day ', ''),
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 11),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        barGroups:
                            dayProgressList.asMap().entries.map((entry) {
                          int i = entry.key;
                          final val =
                              (entry.value['completed'] ?? 0).toDouble();

                          Color barColor;
                          if (val >= 100) {
                            barColor = Colors.green;
                          } else if (val > 0) {
                            barColor = Colors.orangeAccent;
                          } else {
                            barColor = Colors.redAccent;
                          }

                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: val,
                                color: barColor,
                                width: 22,
                                borderRadius: BorderRadius.circular(8),
                                backDrawRodData:
                                    BackgroundBarChartRodData(
                                  show: true,
                                  toY: 100,
                                  color: const Color.fromARGB(158, 94, 94, 94),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Daily Progress",
              style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 🧩 Daily Progress Cards
            Column(
              children: dayProgressList.map((dayData) {
                final completed = (dayData['completed'] ?? 0) as int;
                final day = (dayData['day'] ?? 'Unknown') as String;
                final duration = (dayData['duration'] ?? '-') as String;
                final calories = (dayData['calories'] ?? 0).toString();
                final completedTasks = (dayData['completedTasks'] ?? 0) as int;
                final totalTasks = (dayData['totalTasks'] ?? 0) as int;

                // Determine status color + icon (colored) for the right side
                String statusText;
                Color statusColor;
                IconData statusIcon;

                if (completed >= 100) {
                  statusText = "Completed";
                  statusColor = Colors.green;
                  statusIcon = Icons.check_circle;
                } else if (completed > 0) {
                  statusText = "In Progress";
                  statusColor = Colors.orange;
                  statusIcon = Icons.directions_run;
                } else {
                  statusText = "Pending";
                  statusColor = Colors.red;
                  statusIcon = Icons.pause_circle_outline;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🏃 Left circular icon (running person) - always primary background
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.primary,
                        child: const Icon(Icons.directions_run, color: Colors.white, size: 28),
                      ),

                      const SizedBox(width: 12),

                      // 📋 Center info (Day on top, calories under it, then duration and tasks)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              day,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "🔥 $calories Kcal",
                              style: TextStyle(
                                  color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.access_time, color: Colors.grey, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  duration,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Tasks: $completedTasks/$totalTasks",
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 11),
                            ),
                          ],
                        ),
                      ),

                      // ✅ Right side: status icon + text (colored by status)
                      Row(
                        children: [
                          Icon(statusIcon, color: statusColor, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
   ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
