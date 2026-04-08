import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/colors.dart';
import '../../../presentation/widgets/CustomBottomNavBar.dart';
import '../../../logic/workout_cubit.dart';
import '../../../data/models/workout_state.dart';
import 'today.dart';
import 'DayDetail.dart';

class WeeklyWorkoutPage extends StatefulWidget {
  final int userId;

  const WeeklyWorkoutPage({super.key, required this.userId});

  @override
  State<WeeklyWorkoutPage> createState() {
    return _WeeklyWorkoutPageState();
  }
}

class _WeeklyWorkoutPageState extends State<WeeklyWorkoutPage> {
  int _selectedIndex = 1;

  // ✅ Save cubit reference to use after navigation
  late final WorkoutCubit _cubit;

  // ✅ Cache the last weekly state to show while refreshing
  WeeklyPlanLoaded? _cachedWeeklyState;

  @override
  void initState() {
    super.initState();
    // ✅ Get cubit reference once
    _cubit = context.read<WorkoutCubit>();
    // Load weekly plan
    _cubit.loadCurrentWeeklyPlan(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text(
          "Workout Plan",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // ✅ RESET BUTTON
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            tooltip: 'Reset Progress',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: const Text(
                    'Reset Progress?',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'This will clear all completed workouts and days. Continue?',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _cubit.clearCompletionData();
                        Navigator.pop(ctx);
                        // ✅ Use cached cubit reference
                        _cubit.loadCurrentWeeklyPlan(widget.userId);
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              const Center(
                child: Text(
                  "Weekly Plan",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: BlocBuilder<WorkoutCubit, WorkoutState>(
                  // ✅ Only rebuild for relevant states
                  buildWhen: (previous, current) {
                    return current is WeeklyPlanLoaded ||
                        current is WorkoutLoading ||
                        current is WorkoutError;
                  },
                  builder: (context, state) {
                    // ✅ Save weekly state when we get it
                    if (state is WeeklyPlanLoaded) {
                      _cachedWeeklyState = state;
                    }

                    // ✅ If state is DayWorkoutsLoaded, show cached weekly state
                    if (state is DayWorkoutsLoaded &&
                        _cachedWeeklyState != null) {
                      state = _cachedWeeklyState!;
                    }

                    if (state is WorkoutLoading) {
                      // ✅ If we have cached state, show it instead of loading
                      if (_cachedWeeklyState != null) {
                        state = _cachedWeeklyState!;
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }
                    }

                    if (state is WorkoutError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 60,
                              color: Colors.red.withOpacity(0.7),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                _cubit.loadCurrentWeeklyPlan(widget.userId);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is WeeklyPlanLoaded) {
                      final days = state.weeklyPlan.days ?? [];
                      final completedDayIds = state.completedDayIds;

                      if (days.isEmpty) {
                        return const Center(
                          child: Text(
                            'No days in plan',
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      // ✅ COUNT COMPLETED DAYS
                      final completedCount = days.where((day) {
                        return completedDayIds.contains(day.dayId);
                      }).length;

                      return Column(
                        children: [
                          // ✅ PROGRESS INDICATOR
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withOpacity(0.3),
                                  AppColors.secondry.withOpacity(0.3),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Week Progress',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '$completedCount / ${days.length} Days',
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: days.isEmpty
                                        ? 0
                                        : completedCount / days.length,
                                    backgroundColor: Colors.white24,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          AppColors.primary,
                                        ),
                                    minHeight: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ✅ CHECK IF ALL DAYS COMPLETE
                          if (completedCount == days.length)
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.celebration,
                                      size: 80,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      '🎉 Week Complete! 🎉',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'You have completed all workouts!',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            // ✅ SHOW ALL DAYS
                            Expanded(
                              child: ListView.separated(
                                itemCount: days.length,
                                separatorBuilder: (context, i) {
                                  return const SizedBox(height: 20);
                                },
                                itemBuilder: (context, index) {
                                  final day = days[index];
                                  final isCompleted = completedDayIds.contains(
                                    day.dayId,
                                  );

                                  return _dayButton(
                                    context,
                                    "Day ${day.dayIndex}",
                                    day.dayId!,
                                    isCompleted,
                                  );
                                },
                              ),
                            ),
                        ],
                      );
                    }

                    return const Center(
                      child: Text(
                        'No workout plan available',
                        style: TextStyle(color: Colors.white70),
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
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 4) {
            Navigator.pushNamed(context, '/profile');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/workout');
          }
        },
      ),
    );
  }

  Widget _dayButton(
    BuildContext context,
    String text,
    int dayId,
    bool isCompleted,
  ) {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setInnerState) {
        return MouseRegion(
          onEnter: (event) => setInnerState(() => isHovered = true),
          onExit: (event) => setInnerState(() => isHovered = false),
          child: GestureDetector(
            onTap: () async {
              print('📍 Navigating to Day $dayId');

              // ✅ Navigate to day detail
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: _cubit,
                    child: DayDetailPage(dayTitle: text, dayId: dayId),
                  ),
                ),
              );

              // ✅ When returning, refresh weekly plan
              print('🔙 Returned from day → refreshing');
              _cubit.refreshWeeklyPlan(widget.userId);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.primary.withOpacity(0.3)
                    : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: isCompleted
                    ? Border.all(color: AppColors.primary, width: 2)
                    : null,
                boxShadow: isHovered
                    ? [
                        BoxShadow(
                          color: isCompleted
                              ? AppColors.primary.withOpacity(0.6)
                              : Colors.orange.withOpacity(0.6),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isCompleted ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  // ✅ Show checkmark if completed
                  if (isCompleted) ...[
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 22,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
