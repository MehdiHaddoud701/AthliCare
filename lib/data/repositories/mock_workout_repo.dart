import '../models/users_model.dart';
import '../models/workout_model.dart';
import '../models/weekly_plan_model.dart';
import '../models/day_scheduale_model.dart';
import '../models/task_model.dart';
import '../dummy_data.dart';
import 'workout_repo.dart';

class MockWorkoutRepository extends WorkoutRepository {
  // ✅ Call parent constructor
  MockWorkoutRepository() : super();

  @override
  Future<WeeklyPlanModel?> getCurrentWeeklyPlan(int userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return DummyData.getWeeklyPlan();
  }

  @override
  Future<WeeklyPlanModel?> getFullWeeklyPlan(
    int userId,
    int weekNumber,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return DummyData.getWeeklyPlan();
  }

  @override
  Future<List<DayScheduleModel>> getDaysByWeeklyPlan(int weeklyPlanId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DummyData.getWeeklyPlan().days ?? [];
  }

  @override
  Future<DayScheduleModel?> getDayWithWorkouts(int dayId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DummyData.getDayById(dayId);
  }

  @override
  Future<WorkoutModel?> getWorkoutWithTasks(int workoutId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final workout = DummyData.getWorkoutById(workoutId);
    if (workout == null) return null;

    final tasks = DummyData.getTasksByWorkoutId(workoutId);
    return workout.copyWith(tasks: tasks);
  }

  @override
  Future<Map<int, List<TaskModel>>> getTasksByWorkoutIdGroupedByRound(
    int workoutId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyData.getTasksByWorkoutIdGroupedByRound(workoutId);
  }

  @override
  Future<Map<String, dynamic>> getWorkoutStats(int workoutId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final tasks = DummyData.getTasksByWorkoutId(workoutId);
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

  @override
  Future<WeeklyPlanModel?> generateWeeklyPlanForUser(
    int userId,
    int activeDays,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return DummyData.getWeeklyPlan();
  }
}