import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/colors.dart';
import '../../widgets/CustomBottomNavBar.dart';
import '../../../logic/workout_cubit.dart';
import '../../../data/models/workout_state.dart';
import '../../../data/models/workout_model.dart';
import 'workoutDetail.dart';

class DayDetailPage extends StatefulWidget {
  final String dayTitle;
  final int dayId;

  const DayDetailPage({super.key, required this.dayTitle, required this.dayId});

  @override
  State<DayDetailPage> createState() => _DayDetailPageState();
}

class _DayDetailPageState extends State<DayDetailPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  void _loadWorkouts() {
    context.read<WorkoutCubit>().loadDayWorkouts(widget.dayId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            print('🔙 Back button pressed - just popping');
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.dayTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: BlocBuilder<WorkoutCubit, WorkoutState>(
            builder: (context, state) {
              // ✅ LOADING STATE
              if (state is WorkoutLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              // ✅ ERROR STATE
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
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadWorkouts,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              // ✅ Check if we have the correct DayWorkoutsLoaded state
              if (state is DayWorkoutsLoaded &&
                  state.day.dayId == widget.dayId) {
                final workouts = state.workouts;
                final completionPercentage = state.completionPercentage;
                final isCompleted = completionPercentage >= 1.0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ HEADER WITH COMPLETION STATUS
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isCompleted
                              ? [Colors.green.withOpacity(0.8), Colors.teal]
                              : [
                                  AppColors.primary.withOpacity(0.8),
                                  Colors.orange,
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: isCompleted
                                ? Colors.green.withOpacity(0.4)
                                : AppColors.primary.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  isCompleted
                                      ? "✅ ${widget.dayTitle} Complete!"
                                      : "Welcome to ${widget.dayTitle}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (isCompleted)
                                const Icon(
                                  Icons.celebration,
                                  color: Colors.white,
                                  size: 28,
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // ✅ PROGRESS BAR
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: completionPercentage,
                              backgroundColor: Colors.white30,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            isCompleted
                                ? "🎉 All workouts completed!"
                                : "${(completionPercentage * 100).toInt()}% Complete - Keep going!",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Your Workouts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ✅ WORKOUT LIST
                    Expanded(
                      child: _buildWorkoutList(
                        workouts,
                        state.completedTaskIds,
                      ),
                    ),
                  ],
                );
              }

              // ✅ If state doesn't match, reload and show loading
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _loadWorkouts();
                }
              });

              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            },
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }

  // ✅ WORKOUT LIST WITH COMPLETION STATUS (DAY-SPECIFIC)
  Widget _buildWorkoutList(
    List<WorkoutModel> workouts,
    Set<int> completedTaskIds,
  ) {
    if (workouts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 60, color: Colors.white24),
            SizedBox(height: 16),
            Text(
              'No workouts scheduled',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];

        // ✅ CHECK IF THIS WORKOUT IS COMPLETED IN THIS DAY (NOT globally)
        final isWorkoutCompletedInThisDay = context
            .read<WorkoutCubit>()
            .isWorkoutCompleteInDay(widget.dayId, workout.workoutId!);

        // ✅ GET TASK COMPLETION FOR THIS WORKOUT
        final workoutTasks = workout.tasks ?? [];

        // ✅ GET COMPLETED TASKS COUNT (for progress display)
        final daySpecificCompletedCount = workoutTasks
            .where((task) => completedTaskIds.contains(task.taskId))
            .length;
        final totalCount = workoutTasks.length;
        final completionPercentage = totalCount > 0
            ? daySpecificCompletedCount / totalCount
            : 0.0;

        // ✅ USE DAY-SPECIFIC COMPLETION
        final isWorkoutCompleted = isWorkoutCompletedInThisDay;

        return GestureDetector(
          onTap: () async {
            // ✅ NAVIGATE TO WORKOUT DETAIL
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: context.read<WorkoutCubit>(),
                  child: WorkoutDetailPage(
                    workoutId: workout.workoutId!,
                    title: workout.title,
                    imageUrl: workout.imagePath ?? 'sport.jpg',
                    description: workout.description ?? '',
                  ),
                ),
              ),
            );

            // ✅ NO REFRESH HERE - Let state update naturally
          },
          child: _buildTrainingCard(
            title: workout.title,
            imageUrl: workout.imagePath ?? 'sport.jpg',
            description: workout.description ?? "No description available",
            isCompleted: isWorkoutCompleted,
            completionPercentage: completionPercentage,
            completedTasks: daySpecificCompletedCount,
            totalTasks: totalCount,
          ),
        );
      },
    );
  }

  // ✅ TRAINING CARD WITH COMPLETION STATUS
  Widget _buildTrainingCard({
    required String title,
    required String imageUrl,
    required String description,
    required bool isCompleted,
    required double completionPercentage,
    required int completedTasks,
    required int totalTasks,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isCompleted
            ? AppColors.primary.withOpacity(0.2)
            : const Color.fromARGB(43, 255, 255, 255),
        border: isCompleted
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isCompleted
                                    ? AppColors.primary
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          // ✅ CHECKMARK IF COMPLETED
                          if (isCompleted)
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                              size: 22,
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // ✅ SHOW PROGRESS
                      if (!isCompleted)
                        Text(
                          '$completedTasks / $totalTasks tasks done',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: imageUrl.startsWith('http')
              ? Image.network(
                  imageUrl,
                  width: 110,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 110,
                      height: 100,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.fitness_center,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    );
                  },
                )
              : Image.asset(
                  'assets/images/$imageUrl',
                  width: 110,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 110,
                      height: 100,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.fitness_center,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    );
                  },
                ),
          ),
            ],
          ),
          // ✅ PROGRESS BAR AT BOTTOM
          if (!isCompleted && totalTasks > 0)
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: completionPercentage,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                  minHeight: 4,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
