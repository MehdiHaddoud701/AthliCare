// ==================== cubit/workout_state.dart ====================
import 'package:equatable/equatable.dart';
import '../models/workout_model.dart';
import '../models/weekly_plan_model.dart';
import '../models/day_scheduale_model.dart';
import '../models/task_model.dart';

abstract class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object?> get props => [];
}

// Initial state
class WorkoutInitial extends WorkoutState {}

// Loading state
class WorkoutLoading extends WorkoutState {}

// ✅ UPDATED: Weekly plan loaded (for the Weekly Plan screen)
class WeeklyPlanLoaded extends WorkoutState {
  final WeeklyPlanModel weeklyPlan;
  final int selectedDayIndex; // Which day is currently selected (1-based)
  final Set<int> completedDayIds; // ✅ ADD THIS - Track completed days

  const WeeklyPlanLoaded({
    required this.weeklyPlan,
    this.selectedDayIndex = 1,
    this.completedDayIds = const {}, // ✅ ADD THIS
  });

  @override
  List<Object?> get props => [weeklyPlan, selectedDayIndex, completedDayIds]; // ✅ UPDATE THIS

  WeeklyPlanLoaded copyWith({
    WeeklyPlanModel? weeklyPlan,
    int? selectedDayIndex,
    Set<int>? completedDayIds, // ✅ ADD THIS
  }) {
    return WeeklyPlanLoaded(
      weeklyPlan: weeklyPlan ?? this.weeklyPlan,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      completedDayIds: completedDayIds ?? this.completedDayIds, // ✅ ADD THIS
    );
  }
}

// ✅ UPDATED: Today's workouts loaded (for Today's Plan tab)
class TodayWorkoutsLoaded extends WorkoutState {
  final DayScheduleModel day;
  final List<WorkoutModel> workouts;
  final Set<int> completedTaskIds; // ✅ ADD THIS - Track completed tasks
  final double completionPercentage; // ✅ ADD THIS - Day completion %

  const TodayWorkoutsLoaded({
    required this.day,
    required this.workouts,
    this.completedTaskIds = const {}, // ✅ ADD THIS
    this.completionPercentage = 0.0, // ✅ ADD THIS
  });

  @override
  List<Object?> get props => [
    day,
    workouts,
    completedTaskIds,
    completionPercentage,
  ]; // ✅ UPDATE THIS

  TodayWorkoutsLoaded copyWith({
    DayScheduleModel? day,
    List<WorkoutModel>? workouts,
    Set<int>? completedTaskIds, // ✅ ADD THIS
    double? completionPercentage, // ✅ ADD THIS
  }) {
    return TodayWorkoutsLoaded(
      day: day ?? this.day,
      workouts: workouts ?? this.workouts,
      completedTaskIds: completedTaskIds ?? this.completedTaskIds, // ✅ ADD THIS
      completionPercentage:
          completionPercentage ?? this.completionPercentage, // ✅ ADD THIS
    );
  }
}

// ✅ NEW: Day workouts loaded (for specific day detail screen)
class DayWorkoutsLoaded extends WorkoutState {
  final DayScheduleModel day;
  final List<WorkoutModel> workouts;
  final Set<int> completedTaskIds;
  final double completionPercentage;

  const DayWorkoutsLoaded({
    required this.day,
    required this.workouts,
    this.completedTaskIds = const {},
    this.completionPercentage = 0.0,
  });

  @override
  List<Object?> get props => [
    day,
    workouts,
    completedTaskIds,
    completionPercentage,
  ];

  DayWorkoutsLoaded copyWith({
    DayScheduleModel? day,
    List<WorkoutModel>? workouts,
    Set<int>? completedTaskIds,
    double? completionPercentage,
  }) {
    return DayWorkoutsLoaded(
      day: day ?? this.day,
      workouts: workouts ?? this.workouts,
      completedTaskIds: completedTaskIds ?? this.completedTaskIds,
      completionPercentage: completionPercentage ?? this.completionPercentage,
    );
  }
}

// Single workout detail loaded (for workout detail screen)
class WorkoutDetailLoaded extends WorkoutState {
  final WorkoutModel workout;
  final Map<int, List<TaskModel>> tasksByRound;
  final Map<String, dynamic> stats;

  const WorkoutDetailLoaded({
    required this.workout,
    required this.tasksByRound,
    required this.stats,
  });

  @override
  List<Object?> get props => [workout, tasksByRound, stats];
}

// ✅ UPDATED: Workout execution state (for the workout execution screen)
class WorkoutExecutionState extends WorkoutState {
  final WorkoutModel workout;
  final Map<int, List<TaskModel>> tasksByRound;
  final int currentRound;
  final int currentTaskIndex;
  final int remainingSeconds;
  final bool isPlaying;
  final bool isCompleted;
  final Set<int>
  completedTaskIds; // ✅ ADD THIS - Track completed tasks in execution

  const WorkoutExecutionState({
    required this.workout,
    required this.tasksByRound,
    this.currentRound = 1,
    this.currentTaskIndex = 0,
    this.remainingSeconds = 0,
    this.isPlaying = false,
    this.isCompleted = false,
    this.completedTaskIds = const {}, // ✅ ADD THIS
  });

  @override
  List<Object?> get props => [
    workout,
    tasksByRound,
    currentRound,
    currentTaskIndex,
    remainingSeconds,
    isPlaying,
    isCompleted,
    completedTaskIds, // ✅ ADD THIS
  ];

  TaskModel? get currentTask {
    final tasksInRound = tasksByRound[currentRound];
    if (tasksInRound == null || currentTaskIndex >= tasksInRound.length) {
      return null;
    }
    return tasksInRound[currentTaskIndex];
  }

  WorkoutExecutionState copyWith({
    WorkoutModel? workout,
    Map<int, List<TaskModel>>? tasksByRound,
    int? currentRound,
    int? currentTaskIndex,
    int? remainingSeconds,
    bool? isPlaying,
    bool? isCompleted,
    Set<int>? completedTaskIds, // ✅ ADD THIS
  }) {
    return WorkoutExecutionState(
      workout: workout ?? this.workout,
      tasksByRound: tasksByRound ?? this.tasksByRound,
      currentRound: currentRound ?? this.currentRound,
      currentTaskIndex: currentTaskIndex ?? this.currentTaskIndex,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isPlaying: isPlaying ?? this.isPlaying,
      isCompleted: isCompleted ?? this.isCompleted,
      completedTaskIds: completedTaskIds ?? this.completedTaskIds, // ✅ ADD THIS
    );
  }
}

// Workout completed state
class WorkoutCompleted extends WorkoutState {
  final int workoutId;
  final String workoutTitle;
  final int totalDuration;
  final int totalCalories;

  const WorkoutCompleted({
    required this.workoutId,
    required this.workoutTitle,
    required this.totalDuration,
    required this.totalCalories,
  });

  @override
  List<Object?> get props => [
    workoutId,
    workoutTitle,
    totalDuration,
    totalCalories,
  ];
}

// Error state
class WorkoutError extends WorkoutState {
  final String message;

  const WorkoutError(this.message);

  @override
  List<Object?> get props => [message];
}
