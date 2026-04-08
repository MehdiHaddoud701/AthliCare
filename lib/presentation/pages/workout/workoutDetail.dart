import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/colors.dart';
import '../../widgets/CustomBottomNavBar.dart';
import '../../../logic/workout_cubit.dart';
import '../../../data/models/workout_state.dart';
import '../../../data/models/workout_model.dart';
import '../../../data/models/task_model.dart';
import 'exerciseDetail.dart';

class WorkoutDetailPage extends StatefulWidget {
  final int workoutId;
  final String title;
  final String imageUrl;
  final String description;

  const WorkoutDetailPage({
    super.key,
    required this.workoutId,
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  int _selectedIndex = 0;

  // ✅ Cache workout data locally
  WorkoutModel? _cachedWorkout;
  Map<int, List<TaskModel>>? _cachedTasksByRound;
  Map<String, dynamic>? _cachedStats;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print(
      '🔍 WorkoutDetailPage.initState - loading workoutId=${widget.workoutId}',
    );
    _loadWorkoutDetail();
  }

  void _loadWorkoutDetail() {
    setState(() => _isLoading = true);
    context.read<WorkoutCubit>().loadWorkoutDetail(widget.workoutId);
  }

  /// ✅ Called when user navigates back (back button)
  Future<void> _onBackPressed() async {
    print('👈 Back button pressed - restoring day workouts');
    // Restore the last loaded day workouts before popping
    await context.read<WorkoutCubit>().restoreLastDayWorkouts();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _cachedWorkout != null && !_isLoading
            ? _buildWorkoutContent(
                _cachedWorkout!,
                _cachedTasksByRound!,
                _cachedStats!,
              )
            : BlocConsumer<WorkoutCubit, WorkoutState>(
                listener: (context, state) {
                  print('🎧 WorkoutDetail Listener: ${state.runtimeType}');

                  // ✅ Cache data when loaded
                  if (state is WorkoutDetailLoaded) {
                    setState(() {
                      _cachedWorkout = state.workout;
                      _cachedTasksByRound = state.tasksByRound;
                      _cachedStats = state.stats;
                      _isLoading = false;
                    });
                    print('💾 Cached workout: ${state.workout.title}');
                  }

                  if (state is WorkoutError) {
                    setState(() => _isLoading = false);
                  }
                },
                buildWhen: (previous, current) {
                  // Skip rebuilds if we have cached data
                  if (_cachedWorkout != null) {
                    print('⏭️ Skipping rebuild - using cached workout data');
                    return false;
                  }

                  return current is WorkoutLoading ||
                      current is WorkoutDetailLoaded ||
                      current is WorkoutError;
                },
                builder: (context, state) {
                  print('🎨 WorkoutDetail State: ${state.runtimeType}');

                  if (state is WorkoutLoading || _isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
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
                            onPressed: _loadWorkoutDetail,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is WorkoutDetailLoaded) {
                    return _buildWorkoutContent(
                      state.workout,
                      state.tasksByRound,
                      state.stats,
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                },
              ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  // ✅ Extract workout content builder
  Widget _buildWorkoutContent(
    WorkoutModel workout,
    Map<int, List<TaskModel>> tasksByRound,
    Map<String, dynamic> stats,
  ) {
    print('🏗️ Building workout content: ${workout.title}');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button + Title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  onPressed: _onBackPressed,
                ),
                Expanded(
                  child: Text(
                    workout.title,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Workout Image
          Container(
            width: double.infinity,
            height: 250,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[800],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: widget.imageUrl.startsWith('http')
                ? Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.fitness_center,
                            size: 80,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                  )
                : Image.asset(
                    'assets/images/${widget.imageUrl}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.fitness_center,
                            size: 80,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ),

          const SizedBox(height: 20),

          // Stats Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard(
                  Icons.timer,
                  '${stats['totalDuration'] ~/ 60} Min',
                  'Duration',
                ),
                _buildStatCard(
                  Icons.local_fire_department,
                  '${stats['totalCalories']} Cal',
                  'Calories',
                ),
                _buildStatCard(
                  Icons.fitness_center,
                  '${stats['exerciseCount']}',
                  'Exercises',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Description
          if (workout.description != null && workout.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    workout.description!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

          // Exercises by Round
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Exercises',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Display tasks grouped by rounds
                ...tasksByRound.entries.map((entry) {
                  final roundNumber = entry.key;
                  final tasks = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Round Header
                      if (tasksByRound.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12, top: 8),
                          child: Text(
                            'Round $roundNumber',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      // Tasks in this round - Wrap in BlocBuilder to rebuild on completion changes
                      ...tasks.map((task) {
                        return BlocBuilder<WorkoutCubit, WorkoutState>(
                          buildWhen: (previous, current) {
                            // Rebuild when state changes to catch completion updates
                            return true;
                          },
                          builder: (context, state) {
                            final isCompleted = context
                                .read<WorkoutCubit>()
                                .getCompletedTaskIds()
                                .contains(task.taskId);
                            return _buildExerciseCard(
                              context,
                              task.title,
                              task.imagePath ?? 'sport.jpg',
                              task.durationSec,
                              task.level ?? 'moderate',
                              task.taskId!,
                              isCompleted,
                            );
                          },
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(43, 255, 255, 255),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context,
    String title,
    String imageUrl,
    int duration,
    String level,
    int taskId,
    bool isCompleted,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isCompleted
            ? AppColors.primary.withOpacity(0.2)
            : const Color.fromARGB(43, 255, 255, 255),
        border: isCompleted
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
      ),
      child: Row(
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      if (isCompleted)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                          size: 24,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${duration ~/ 60}:${(duration % 60).toString().padLeft(2, '0')} min',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.trending_up,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        level,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      // ✅ NAVIGATE AND WAIT FOR RETURN
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<WorkoutCubit>(),
                            child: ExerciseDetailPage(
                              taskId: taskId,
                              title: title,
                              imageUrl: 'assets/images/$imageUrl',
                              duration: duration,
                              level: level,
                            ),
                          ),
                        ),
                      );

                      // ✅ REFRESH WHEN RETURNING
                      if (mounted) {
                        print(
                          '🔄 Returned from exercise, refreshing workout detail',
                        );
                        context.read<WorkoutCubit>().refreshWorkoutDetail(
                          widget.workoutId,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCompleted
                          ? Colors.grey
                          : AppColors.secondry,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      isCompleted ? 'Completed' : 'Start',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 110,
                      height: 140,
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
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 110,
                      height: 140,
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
    );
  }
}
