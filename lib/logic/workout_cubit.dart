// ==================== cubit/workout_cubit.dart ====================
import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repositories/workout_repo.dart';
import '../data/models/workout_model.dart';
import '../data/models/task_model.dart';
import '../data/models/weekly_plan_model.dart';
import '../data/models/day_scheduale_model.dart';
import '../data/models/workout_state.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  final WorkoutRepository _repository;
  WeeklyPlanModel? _currentWeeklyPlan;
  Timer? _workoutTimer;

  // ✅ Track completed tasks globally AND per day-workout
  final Set<int> _completedTaskIds = {};
  final Set<int> _completedDayIds = {};

  // ✅ Track completed workouts per day: Map<dayId, Set<workoutId>>
  final Map<int, Set<int>> _completedWorkoutsByDay = {};

  // ✅ Track current context for proper state restoration
  int? _lastLoadedDayId;
  // ignore: unused_field
  int? _lastLoadedWorkoutId;
  // ignore: unused_field
  int? _lastLoadedUserId;

  // ✅ Persistence keys
  static const String _COMPLETED_TASKS_KEY = 'completed_tasks';
  static const String _COMPLETED_DAYS_KEY = 'completed_days';
  static const String _COMPLETED_WORKOUTS_BY_DAY_KEY =
      'completed_workouts_by_day';

  // ✅ Flag to check if we've loaded saved state
  bool _hasLoadedState = false;

  WorkoutCubit(this._repository) : super(WorkoutInitial()) {
    _loadSavedState(); // Load state on initialization
  }

  // ==================== PERSISTENCE METHODS ====================

  /// Load completed tasks and days from storage
  Future<void> _loadSavedState() async {
    if (_hasLoadedState) return; // Prevent multiple loads

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load completed task IDs
      final tasksJson = prefs.getString(_COMPLETED_TASKS_KEY);
      if (tasksJson != null) {
        final List<dynamic> tasksList = jsonDecode(tasksJson);
        _completedTaskIds.addAll(tasksList.cast<int>());
        print(
          '📥 Loaded ${_completedTaskIds.length} completed tasks from storage',
        );
      }

      // Load completed day IDs
      final daysJson = prefs.getString(_COMPLETED_DAYS_KEY);
      if (daysJson != null) {
        final List<dynamic> daysList = jsonDecode(daysJson);
        _completedDayIds.addAll(daysList.cast<int>());
        print(
          '📥 Loaded ${_completedDayIds.length} completed days from storage',
        );
      }

      // Load completed workouts by day
      final workoutsJson = prefs.getString(_COMPLETED_WORKOUTS_BY_DAY_KEY);
      if (workoutsJson != null) {
        final Map<String, dynamic> workoutsMap = jsonDecode(workoutsJson);
        workoutsMap.forEach((dayIdStr, workoutsList) {
          final dayId = int.parse(dayIdStr);
          final workouts = (workoutsList as List<dynamic>).cast<int>();
          _completedWorkoutsByDay[dayId] = workouts.toSet();
        });
        print('📥 Loaded completed workouts by day from storage');
      }

      _hasLoadedState = true;
    } catch (e) {
      print('❌ Error loading saved state: $e');
    }
  }

  /// Save completed tasks to storage
  Future<void> _saveCompletedTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = jsonEncode(_completedTaskIds.toList());
      await prefs.setString(_COMPLETED_TASKS_KEY, tasksJson);
      print('💾 Saved ${_completedTaskIds.length} completed tasks');
    } catch (e) {
      print('❌ Error saving tasks: $e');
    }
  }

  /// Save completed days to storage
  Future<void> _saveCompletedDays() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final daysJson = jsonEncode(_completedDayIds.toList());
      await prefs.setString(_COMPLETED_DAYS_KEY, daysJson);
      print('💾 Saved ${_completedDayIds.length} completed days');
    } catch (e) {
      print('❌ Error saving days: $e');
    }
  }

  /// Save completed workouts by day to storage
  Future<void> _saveCompletedWorkoutsByDay() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final workoutsMap = _completedWorkoutsByDay.map((dayId, workouts) {
        return MapEntry(dayId.toString(), workouts.toList());
      });
      final workoutsJson = jsonEncode(workoutsMap);
      await prefs.setString(_COMPLETED_WORKOUTS_BY_DAY_KEY, workoutsJson);
      print('💾 Saved completed workouts by day');
    } catch (e) {
      print('❌ Error saving workouts by day: $e');
    }
  }

  /// Clear all completion data (useful for reset/new week)
  Future<void> clearCompletionData() async {
    _completedTaskIds.clear();
    _completedDayIds.clear();
    _completedWorkoutsByDay.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_COMPLETED_TASKS_KEY);
    await prefs.remove(_COMPLETED_DAYS_KEY);
    await prefs.remove(_COMPLETED_WORKOUTS_BY_DAY_KEY);

    print('🗑️ Cleared all completion data');
  }

  // ==================== HELPER METHODS ====================

  /// Get completed tasks for a specific day (only tasks from that day's workouts)
  Set<int> getCompletedTasksForDay(int dayId, List<WorkoutModel> dayWorkouts) {
    // Get task IDs that belong to this day's workouts
    final dayTaskIds = dayWorkouts
        .expand((workout) => workout.tasks ?? <TaskModel>[])
        .map((task) => task.taskId ?? 0)
        .toSet();

    // Return intersection of completed tasks and day task IDs
    return _completedTaskIds.intersection(dayTaskIds);
  }

  // ==================== WEEKLY PLAN METHODS ====================

  /// Load weekly plan for user (for Weekly Plan screen)
  Future<void> loadWeeklyPlan(int userId, int weekNumber) async {
    await _loadSavedState(); // Ensure state is loaded
    emit(WorkoutLoading());
    try {
      final plan = await _repository.getFullWeeklyPlan(userId, weekNumber);

      if (plan == null) {
        emit(const WorkoutError('No weekly plan found'));
        return;
      }

      _currentWeeklyPlan = plan;
      _lastLoadedUserId = userId;

      emit(
        WeeklyPlanLoaded(
          weeklyPlan: plan,
          completedDayIds: Set.from(_completedDayIds),
        ),
      );
    } catch (e) {
      emit(WorkoutError('Failed to load weekly plan: $e'));
    }
  }

  /// Load current weekly plan
  Future<void> loadCurrentWeeklyPlan(int userId) async {
    await _loadSavedState(); // Ensure state is loaded
    emit(WorkoutLoading());
    try {
      final plan = await _repository.getCurrentWeeklyPlan(userId);

      if (plan == null) {
        // No plan exists, generate one
        final newPlan = await _repository.generateWeeklyPlanForUser(userId, 4);
        if (newPlan == null) {
          emit(const WorkoutError('Failed to generate weekly plan'));
          return;
        }
        _currentWeeklyPlan = newPlan;
        _lastLoadedUserId = userId;

        emit(
          WeeklyPlanLoaded(
            weeklyPlan: newPlan,
            completedDayIds: Set.from(_completedDayIds),
          ),
        );
        return;
      }

      final fullPlan = await _repository.getFullWeeklyPlan(
        userId,
        plan.weekNumber,
      );

      if (fullPlan == null) {
        emit(const WorkoutError('Failed to load plan details'));
        return;
      }

      _currentWeeklyPlan = fullPlan;
      _lastLoadedUserId = userId;

      emit(
        WeeklyPlanLoaded(
          weeklyPlan: fullPlan,
          completedDayIds: Set.from(_completedDayIds),
        ),
      );
    } catch (e) {
      emit(WorkoutError('Failed to load current plan: $e'));
    }
  }

  /// Switch between Weekly Plan and Today's Plan tabs
  void selectDay(int dayIndex) {
    final currentState = state;
    if (currentState is WeeklyPlanLoaded) {
      emit(currentState.copyWith(selectedDayIndex: dayIndex));
    }
  }

  /// Load today's workouts (for Today's Plan tab)
  Future<void> loadTodayWorkouts(int userId) async {
    await _loadSavedState(); // Ensure state is loaded
    emit(WorkoutLoading());
    try {
      // Get current weekly plan
      final plan = await _repository.getCurrentWeeklyPlan(userId);
      if (plan == null) {
        emit(const WorkoutError('No weekly plan found'));
        return;
      }

      // Get days from the plan
      final days = await _repository.getDaysByWeeklyPlan(plan.weeklyPlanId!);
      if (days.isEmpty) {
        emit(const WorkoutError('No days found in plan'));
        return;
      }

      // Get first day (today)
      final today = days.first;
      final dayWithWorkouts = await _repository.getDayWithWorkouts(
        today.dayId!,
      );

      if (dayWithWorkouts == null) {
        emit(const WorkoutError('Failed to load today\'s workouts'));
        return;
      }

      final allTasks =
          dayWithWorkouts.workouts
              ?.expand((w) => w.tasks ?? <TaskModel>[])
              .toList()
              .cast<TaskModel>() ??
          <TaskModel>[];
      final completion = calculateDayCompletion(allTasks);

      emit(
        TodayWorkoutsLoaded(
          day: dayWithWorkouts,
          workouts: dayWithWorkouts.workouts ?? [],
          completedTaskIds: Set.from(_completedTaskIds),
          completionPercentage: completion,
        ),
      );
    } catch (e) {
      emit(WorkoutError('Failed to load today\'s workouts: $e'));
    }
  }

  /// Load specific day's workouts
  Future<void> loadDayWorkouts(int dayId) async {
    await _loadSavedState(); // Ensure state is loaded
    print('🔄 WorkoutCubit.loadDayWorkouts called with dayId=$dayId');

    _lastLoadedDayId = dayId; // Track the day we're loading

    emit(WorkoutLoading());
    try {
      final day = await _repository.getDayWithWorkouts(dayId);
      print('📦 Repository returned day: $day');
      print('📦 Day has ${day?.workouts?.length ?? 0} workouts');

      if (day == null) {
        print('❌ Day is null for dayId=$dayId');
        emit(const WorkoutError('No workouts found for this day'));
        return;
      }

      final allTasks =
          day.workouts
              ?.expand((w) => w.tasks ?? <TaskModel>[])
              .toList()
              .cast<TaskModel>() ??
          <TaskModel>[];
      final completion = calculateDayCompletion(allTasks);

      print(
        '✅ Emitting DayWorkoutsLoaded with ${day.workouts?.length ?? 0} workouts',
      );
      print('✅ Completed tasks: $_completedTaskIds');
      print('✅ Completion: ${(completion * 100).toStringAsFixed(0)}%');

      emit(
        DayWorkoutsLoaded(
          day: day,
          workouts: day.workouts ?? [],
          completedTaskIds: Set.from(_completedTaskIds),
          completionPercentage: completion,
        ),
      );

      // ✅ Check if day is now complete
      await _checkAndMarkDayComplete(dayId);
    } catch (e) {
      print('❌ Exception: $e');
      emit(WorkoutError('Failed to load day workouts: $e'));
    }
  }

  // ==================== WORKOUT DETAIL METHODS ====================

  /// Load workout details (for workout detail screen)
  Future<void> loadWorkoutDetail(int workoutId) async {
    await _loadSavedState(); // Ensure state is loaded
    print('🔄 Loading workout detail for workoutId=$workoutId');

    _lastLoadedWorkoutId = workoutId; // Track the workout we're loading

    emit(WorkoutLoading());
    try {
      final workout = await _repository.getWorkoutWithTasks(workoutId);

      if (workout == null) {
        emit(const WorkoutError('Workout not found'));
        return;
      }

      final tasksByRound = await _repository.getTasksByWorkoutIdGroupedByRound(
        workoutId,
      );

      final stats = await _repository.getWorkoutStats(workoutId);

      print('✅ Loaded workout with ${workout.tasks?.length ?? 0} tasks');
      print('✅ Current completed tasks: $_completedTaskIds');

      emit(
        WorkoutDetailLoaded(
          workout: workout,
          tasksByRound: tasksByRound,
          stats: stats,
        ),
      );
    } catch (e) {
      emit(WorkoutError('Failed to load workout: $e'));
    }
  }

  /// Refresh workout detail WITHOUT emitting loading state
  Future<void> refreshWorkoutDetail(int workoutId) async {
    print('🔄 Refreshing workout detail for workoutId=$workoutId');

    try {
      final workout = await _repository.getWorkoutWithTasks(workoutId);
      if (workout == null) {
        print('❌ Workout not found during refresh');
        return;
      }

      final tasksByRound = await _repository.getTasksByWorkoutIdGroupedByRound(
        workoutId,
      );
      final stats = await _repository.getWorkoutStats(workoutId);

      print('✅ Emitting refreshed WorkoutDetailLoaded');
      emit(
        WorkoutDetailLoaded(
          workout: workout,
          tasksByRound: tasksByRound,
          stats: stats,
        ),
      );
    } catch (e) {
      print('❌ Error refreshing workout: $e');
    }
  }

  /// Refresh day workouts WITHOUT emitting loading state
  Future<void> refreshDayWorkouts(int dayId) async {
    print('🔄 Refreshing day workouts for dayId=$dayId');

    try {
      final day = await _repository.getDayWithWorkouts(dayId);
      if (day == null) {
        print('❌ Day not found during refresh');
        return;
      }

      final allTasks =
          day.workouts
              ?.expand((w) => w.tasks ?? <TaskModel>[])
              .toList()
              .cast<TaskModel>() ??
          <TaskModel>[];
      final completion = calculateDayCompletion(allTasks);

      print('✅ Emitting refreshed DayWorkoutsLoaded');
      emit(
        DayWorkoutsLoaded(
          day: day,
          workouts: day.workouts ?? [],
          completedTaskIds: Set.from(_completedTaskIds),
          completionPercentage: completion,
        ),
      );

      await _checkAndMarkDayComplete(dayId);
    } catch (e) {
      print('❌ Error refreshing day: $e');
    }
  }

  /// ✅ NEW: Refresh weekly plan WITHOUT emitting loading state
  Future<void> refreshWeeklyPlan(int userId) async {
    print('🔄 Refreshing weekly plan for userId=$userId');

    try {
      final plan = await _repository.getCurrentWeeklyPlan(userId);
      if (plan == null) {
        print('❌ No weekly plan found during refresh');
        return;
      }

      final fullPlan = await _repository.getFullWeeklyPlan(
        userId,
        plan.weekNumber,
      );
      if (fullPlan == null) {
        print('❌ Failed to load full plan during refresh');
        return;
      }

      _currentWeeklyPlan = fullPlan;

      print('✅ Emitting refreshed WeeklyPlanLoaded');
      emit(
        WeeklyPlanLoaded(
          weeklyPlan: fullPlan,
          completedDayIds: Set.from(_completedDayIds),
        ),
      );
    } catch (e) {
      print('❌ Error refreshing weekly plan: $e');
    }
  }

  /// ✅ Restore/reload the last loaded day after returning from workout detail
  Future<void> restoreLastDayWorkouts() async {
    if (_lastLoadedDayId == null) {
      print('⚠️ No last day loaded, cannot restore');
      return;
    }

    print('🔄 Restoring last day workouts for dayId=$_lastLoadedDayId');
    await loadDayWorkouts(_lastLoadedDayId!);
  }

  // ==================== WORKOUT EXECUTION METHODS ====================

  /// Start workout execution
  Future<void> startWorkoutExecution(int workoutId) async {
    await _loadSavedState(); // Ensure state is loaded
    emit(WorkoutLoading());
    try {
      final workout = await _repository.getWorkoutWithTasks(workoutId);

      if (workout == null) {
        emit(const WorkoutError('Workout not found'));
        return;
      }

      final tasksByRound = await _repository.getTasksByWorkoutIdGroupedByRound(
        workoutId,
      );

      if (tasksByRound.isEmpty) {
        emit(const WorkoutError('No tasks found for this workout'));
        return;
      }

      final firstTask = tasksByRound[1]?.first;
      final initialDuration = firstTask?.durationSec ?? 0;

      emit(
        WorkoutExecutionState(
          workout: workout,
          tasksByRound: tasksByRound,
          currentRound: 1,
          currentTaskIndex: 0,
          remainingSeconds: initialDuration,
          isPlaying: false,
          isCompleted: false,
          completedTaskIds: Set.from(_completedTaskIds),
        ),
      );
    } catch (e) {
      emit(WorkoutError('Failed to start workout: $e'));
    }
  }

  /// Play/Pause the workout timer
  void togglePlayPause() {
    final currentState = state;
    if (currentState is! WorkoutExecutionState) return;

    if (currentState.isPlaying) {
      _pauseTimer();
      emit(currentState.copyWith(isPlaying: false));
    } else {
      _startTimer();
      emit(currentState.copyWith(isPlaying: true));
    }
  }

  /// Start the countdown timer
  void _startTimer() {
    _workoutTimer?.cancel();
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentState = state;
      if (currentState is! WorkoutExecutionState) {
        timer.cancel();
        return;
      }

      if (currentState.remainingSeconds > 0) {
        emit(
          currentState.copyWith(
            remainingSeconds: currentState.remainingSeconds - 1,
          ),
        );
      } else {
        _moveToNextTask();
      }
    });
  }

  /// Pause the timer
  void _pauseTimer() {
    _workoutTimer?.cancel();
  }

  /// Move to next task or round
  void _moveToNextTask() {
    final currentState = state;
    if (currentState is! WorkoutExecutionState) return;

    final tasksInCurrentRound =
        currentState.tasksByRound[currentState.currentRound];
    if (tasksInCurrentRound == null) return;

    // ✅ Mark current task as completed
    final currentTask = tasksInCurrentRound[currentState.currentTaskIndex];
    if (currentTask.taskId != null) {
      markTaskCompleted(currentTask.taskId!);
    }

    // Check if there are more tasks in current round
    if (currentState.currentTaskIndex < tasksInCurrentRound.length - 1) {
      final nextTaskIndex = currentState.currentTaskIndex + 1;
      final nextTask = tasksInCurrentRound[nextTaskIndex];

      emit(
        currentState.copyWith(
          currentTaskIndex: nextTaskIndex,
          remainingSeconds: nextTask.durationSec,
          isPlaying: false,
          completedTaskIds: Set.from(_completedTaskIds),
        ),
      );
    } else {
      // Check if there are more rounds
      final nextRound = currentState.currentRound + 1;
      if (currentState.tasksByRound.containsKey(nextRound)) {
        final firstTaskInNextRound =
            currentState.tasksByRound[nextRound]!.first;

        emit(
          currentState.copyWith(
            currentRound: nextRound,
            currentTaskIndex: 0,
            remainingSeconds: firstTaskInNextRound.durationSec,
            isPlaying: false,
            completedTaskIds: Set.from(_completedTaskIds),
          ),
        );
      } else {
        _completeWorkout();
      }
    }

    _pauseTimer();
  }

  /// Skip to next task
  void skipTask() {
    _pauseTimer();
    _moveToNextTask();
  }

  /// Complete the workout
  void _completeWorkout() {
    _pauseTimer();

    final currentState = state;
    if (currentState is! WorkoutExecutionState) return;

    final stats = currentState.tasksByRound.values
        .expand((tasks) => tasks)
        .fold<Map<String, int>>({'duration': 0, 'calories': 0}, (acc, task) {
          acc['duration'] = (acc['duration'] ?? 0) + task.durationSec;
          return acc;
        });

    final totalCalories = ((stats['duration'] ?? 0) / 60 * 5).round();

    emit(
      WorkoutCompleted(
        workoutId: currentState.workout.workoutId!,
        workoutTitle: currentState.workout.title,
        totalDuration: stats['duration'] ?? 0,
        totalCalories: totalCalories,
      ),
    );
  }

  /// Manually complete workout
  void completeWorkout() {
    _completeWorkout();
  }

  // ==================== TASK COMPLETION METHODS ====================

  /// Mark a task as completed when timer finishes
  Future<void> markTaskCompleted(int taskId) async {
    print('✅ Marking task $taskId as completed');
    _completedTaskIds.add(taskId);
    await _saveCompletedTasks(); // ✅ PERSIST TO STORAGE
    print('✅ Total completed tasks: ${_completedTaskIds.length}');

    final currentState = state;

    if (currentState is WorkoutDetailLoaded) {
      print('✅ Updating WorkoutDetailLoaded state');

      final workoutTasks = currentState.workout.tasks ?? [];
      final isWorkoutComplete =
          workoutTasks.isNotEmpty &&
          workoutTasks.every((task) => _completedTaskIds.contains(task.taskId));

      if (isWorkoutComplete) {
        print('🎉 Workout ${currentState.workout.workoutId} is now complete!');
      }

      // Emit a new state instance to trigger rebuild
      emit(
        WorkoutDetailLoaded(
          workout: currentState.workout,
          tasksByRound: currentState.tasksByRound,
          stats: currentState.stats,
        ),
      );
    }

    if (currentState is DayWorkoutsLoaded) {
      final allTasks = currentState.workouts
          .expand((w) => w.tasks ?? <TaskModel>[])
          .toList()
          .cast<TaskModel>();
      final completion = calculateDayCompletion(allTasks);

      print('✅ Day completion: ${(completion * 100).toStringAsFixed(0)}%');

      emit(
        currentState.copyWith(
          completedTaskIds: Set.from(_completedTaskIds),
          completionPercentage: completion,
        ),
      );

      if (completion >= 1.0 &&
          !_completedDayIds.contains(currentState.day.dayId)) {
        await markDayCompleted(currentState.day.dayId!);
      }
    }

    if (currentState is WorkoutExecutionState) {
      emit(
        currentState.copyWith(completedTaskIds: Set.from(_completedTaskIds)),
      );
    }
  }

  /// Calculate day completion percentage
  double calculateDayCompletion(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0.0;
    final completed = tasks
        .where((t) => _completedTaskIds.contains(t.taskId))
        .length;
    return completed / tasks.length;
  }

  /// Get current week progress data for progress tracking
  Future<Map<String, dynamic>?> getCurrentWeekProgress(int userId) async {
    try {
      // Get current weekly plan
      final plan = await _repository.getCurrentWeeklyPlan(userId);
      if (plan == null) return null;

      // Get full plan with days
      final fullPlan = await _repository.getFullWeeklyPlan(userId, plan.weekNumber);
      if (fullPlan == null || fullPlan.days == null) return null;

      List<Map<String, dynamic>> dayProgress = [];
      int totalCompletedTasks = 0;
      int totalTasks = 0;
      double totalCalories = 0;
      double totalDuration = 0;

      // Calculate progress for each day
      for (var day in fullPlan.days!) {
        final dayWithWorkouts = await _repository.getDayWithWorkouts(day.dayId!);
        if (dayWithWorkouts?.workouts != null) {
          List<TaskModel> allTasks = [];
          for (var workout in dayWithWorkouts!.workouts!) {
            if (workout.tasks != null) {
              allTasks.addAll(workout.tasks!);
            }
          }

          final completedTasks = allTasks.where((task) =>
            _completedTaskIds.contains(task.taskId)).length;

          final completionPercentage = allTasks.isEmpty ? 0.0 :
            (completedTasks / allTasks.length) * 100;

          // Calculate calories and duration for this day
          final dayCalories = allTasks.fold<double>(0, (sum, task) =>
            sum + ((task.durationSec / 60) * 5)); // 5 calories per minute
          final dayDuration = allTasks.fold<int>(0, (sum, task) =>
            sum + task.durationSec);

          dayProgress.add({
            'day': day.getDayName(),
            'completed': completionPercentage.round(),
            'duration': '${(dayDuration ~/ 3600).toString().padLeft(2, '0')}:${((dayDuration % 3600) ~/ 60).toString().padLeft(2, '0')} H',
            'calories': dayCalories.round(),
            'completedTasks': completedTasks,
            'totalTasks': allTasks.length,
          });

          totalCompletedTasks += completedTasks;
          totalTasks += allTasks.length;
          totalCalories += dayCalories;
          totalDuration += dayDuration;
        }
      }

      return {
        'weekNumber': fullPlan.weekNumber,
        'totalCompletedTasks': totalCompletedTasks,
        'totalTasks': totalTasks,
        'totalCalories': totalCalories.round(),
        'totalDuration': totalDuration,
        'dayProgress': dayProgress,
        'weekCompletion': totalTasks > 0 ? (totalCompletedTasks / totalTasks) * 100 : 0,
      };
    } catch (e) {
      print('❌ Error getting week progress: $e');
      return null;
    }
  }

  /// Check if all tasks in a workout are completed
  bool isWorkoutCompleted(int workoutId, List<TaskModel> tasks) {
    if (tasks.isEmpty) return false;
    return tasks.every((task) => _completedTaskIds.contains(task.taskId));
  }

  /// Check if a day is completed and mark it
  Future<void> _checkAndMarkDayComplete(int dayId) async {
    // First, check which workouts in this day are complete and mark them
    final day = await _repository.getDayWithWorkouts(dayId);
    if (day != null && day.workouts != null) {
      for (var workout in day.workouts!) {
        final workoutTasks = workout.tasks ?? [];
        if (workoutTasks.isNotEmpty &&
            workoutTasks.every(
              (task) => _completedTaskIds.contains(task.taskId),
            )) {
          // Mark this workout as complete in this specific day
          await markWorkoutCompleteInDay(dayId, workout.workoutId!);
        }
      }
    }

    // Then check if the entire day is complete
    final isComplete = await checkIfDayCompleted(dayId);
    if (isComplete && !_completedDayIds.contains(dayId)) {
      print('🎉 Day $dayId is complete!');
      await markDayCompleted(dayId);
    }
  }

  /// Check if a day is completed (all workouts done)
  Future<bool> checkIfDayCompleted(int dayId) async {
    final day = await _repository.getDayWithWorkouts(dayId);
    if (day == null || day.workouts == null) return false;

    final allTasks = day.workouts!
        .expand((workout) => workout.tasks ?? <TaskModel>[])
        .toList()
        .cast<TaskModel>();

    if (allTasks.isEmpty) return false;

    final isComplete = allTasks.every(
      (task) => _completedTaskIds.contains(task.taskId),
    );

    print(
      '🔍 Day $dayId completion check: $isComplete (${_completedTaskIds.length}/${allTasks.length} tasks)',
    );
    return isComplete;
  }

  /// Mark a day as completed
  Future<void> markDayCompleted(int dayId) async {
    print('🎉 Marking day $dayId as completed');
    _completedDayIds.add(dayId);
    await _saveCompletedDays(); // ✅ PERSIST TO STORAGE

    // ✅ Update weekly plan if it exists
    if (_currentWeeklyPlan != null) {
      emit(
        WeeklyPlanLoaded(
          weeklyPlan: _currentWeeklyPlan!,
          completedDayIds: Set.from(_completedDayIds),
        ),
      );
    }
  }

  /// Get completed task IDs
  Set<int> getCompletedTaskIds() {
    return Set.from(_completedTaskIds);
  }

  /// Mark a workout as completed in a specific day
  Future<void> markWorkoutCompleteInDay(int dayId, int workoutId) async {
    print('✅ Marking workout $workoutId as completed in day $dayId');
    if (!_completedWorkoutsByDay.containsKey(dayId)) {
      _completedWorkoutsByDay[dayId] = {};
    }
    _completedWorkoutsByDay[dayId]!.add(workoutId);
    await _saveCompletedWorkoutsByDay();
  }

  /// Check if a workout is completed in a specific day
  bool isWorkoutCompleteInDay(int dayId, int workoutId) {
    return _completedWorkoutsByDay[dayId]?.contains(workoutId) ?? false;
  }

  /// Get completed workouts for a specific day
  Set<int> getCompletedWorkoutsForDay(int dayId) {
    return _completedWorkoutsByDay[dayId] ?? {};
  }

  /// Check if a day is completed (from memory)
  bool isDayCompleted(int dayId) {
    return _completedDayIds.contains(dayId);
  }

  // ==================== UTILITY METHODS ====================

  /// Get workout statistics
  Map<String, dynamic> getWorkoutStats(WorkoutModel workout) {
    if (workout.tasks == null || workout.tasks!.isEmpty) {
      return {
        'totalDuration': 0,
        'totalCalories': 0,
        'exerciseCount': 0,
        'rounds': 0,
      };
    }

    final tasks = workout.tasks!;
    final totalDuration = tasks.fold<int>(
      0,
      (sum, task) => sum + task.durationSec,
    );

    final maxRound = tasks.fold<int>(
      0,
      (max, task) => task.roundNumber > max ? task.roundNumber : max,
    );

    final totalCalories = (totalDuration / 60 * 5).round();

    return {
      'totalDuration': totalDuration,
      'totalCalories': totalCalories,
      'exerciseCount': tasks.length,
      'rounds': maxRound,
    };
  }

  /// Get day by index from current weekly plan
  DayScheduleModel? getDayByIndex(int dayIndex) {
    if (_currentWeeklyPlan?.days == null) return null;

    try {
      return _currentWeeklyPlan!.days!.firstWhere(
        (day) => day.dayIndex == dayIndex,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> close() {
    _workoutTimer?.cancel();
    return super.close();
  }
}
