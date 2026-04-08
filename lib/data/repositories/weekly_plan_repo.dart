// repositories/workout_repository.dart
import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../models/workout_model.dart';
import '../models/task_model.dart';
import '../models/weekly_plan_model.dart';
import '../models/day_scheduale_model.dart';
import '../models/day_workout_model.dart';

class WorkoutRepository {
  // ==================== WORKOUT CRUD ====================

  /// Insert a new workout
  /// Returns workout_id or -1 on error
  Future<int> insertWorkout(WorkoutModel workout) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.insert('workouts', workout.toMap());
    } catch (e) {
      print("❌ Insert workout error: $e");
      return -1;
    }
  }

  /// Get all workouts (without tasks)
  Future<List<WorkoutModel>> getAllWorkouts() async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query('workouts');
      return maps.map((map) => WorkoutModel.fromMap(map)).toList();
    } catch (e) {
      print("❌ Get all workouts error: $e");
      return [];
    }
  }

  /// Get workout by ID (without tasks)
  Future<WorkoutModel?> getWorkoutById(int workoutId) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'workouts',
        where: 'workout_id = ?',
        whereArgs: [workoutId],
      );

      if (maps.isEmpty) return null;
      return WorkoutModel.fromMap(maps.first);
    } catch (e) {
      print("❌ Get workout by id error: $e");
      return null;
    }
  }

  /// Get workout with all its tasks
  Future<WorkoutModel?> getWorkoutWithTasks(int workoutId) async {
    try {
      final workout = await getWorkoutById(workoutId);
      if (workout == null) return null;

      final tasks = await getTasksByWorkoutId(workoutId);
      return workout.copyWith(tasks: tasks);
    } catch (e) {
      print("❌ Get workout with tasks error: $e");
      return null;
    }
  }

  /// Update workout
  Future<int> updateWorkout(WorkoutModel workout) async {
    try {
      if (workout.workoutId == null) return 0;

      final db = await DBHelper.getDatabase();
      return await db.update(
        'workouts',
        workout.toMap(),
        where: 'workout_id = ?',
        whereArgs: [workout.workoutId],
      );
    } catch (e) {
      print("❌ Update workout error: $e");
      return 0;
    }
  }

  /// Delete workout (cascade deletes tasks)
  Future<int> deleteWorkout(int workoutId) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.delete(
        'workouts',
        where: 'workout_id = ?',
        whereArgs: [workoutId],
      );
    } catch (e) {
      print("❌ Delete workout error: $e");
      return 0;
    }
  }

  // ==================== TASK CRUD ====================

  /// Insert a new task
  Future<int> insertTask(TaskModel task) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.insert('tasks', task.toMap());
    } catch (e) {
      print("❌ Insert task error: $e");
      return -1;
    }
  }

  /// Insert multiple tasks at once (batch operation)
  Future<bool> insertTasks(List<TaskModel> tasks) async {
    try {
      final db = await DBHelper.getDatabase();
      final batch = db.batch();

      for (var task in tasks) {
        batch.insert('tasks', task.toMap());
      }

      await batch.commit(noResult: true);
      return true;
    } catch (e) {
      print("❌ Insert tasks batch error: $e");
      return false;
    }
  }

  /// Get all tasks for a specific workout
  Future<List<TaskModel>> getTasksByWorkoutId(int workoutId) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        where: 'workout_id = ?',
        whereArgs: [workoutId],
        orderBy: 'round_number ASC, task_id ASC',
      );
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      print("❌ Get tasks by workout error: $e");
      return [];
    }
  }

  /// Get tasks grouped by round number
  Future<Map<int, List<TaskModel>>> getTasksByWorkoutIdGroupedByRound(
    int workoutId,
  ) async {
    try {
      final tasks = await getTasksByWorkoutId(workoutId);
      final Map<int, List<TaskModel>> grouped = {};

      for (var task in tasks) {
        if (!grouped.containsKey(task.roundNumber)) {
          grouped[task.roundNumber] = [];
        }
        grouped[task.roundNumber]!.add(task);
      }

      return grouped;
    } catch (e) {
      print("❌ Group tasks by round error: $e");
      return {};
    }
  }

  /// Get tasks by round number
  Future<List<TaskModel>> getTasksByRound(
    int workoutId,
    int roundNumber,
  ) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        where: 'workout_id = ? AND round_number = ?',
        whereArgs: [workoutId, roundNumber],
        orderBy: 'task_id ASC',
      );
      return maps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      print("❌ Get tasks by round error: $e");
      return [];
    }
  }

  /// Update task
  Future<int> updateTask(TaskModel task) async {
    try {
      if (task.taskId == null) return 0;

      final db = await DBHelper.getDatabase();
      return await db.update(
        'tasks',
        task.toMap(),
        where: 'task_id = ?',
        whereArgs: [task.taskId],
      );
    } catch (e) {
      print("❌ Update task error: $e");
      return 0;
    }
  }

  /// Delete task
  Future<int> deleteTask(int taskId) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.delete(
        'tasks',
        where: 'task_id = ?',
        whereArgs: [taskId],
      );
    } catch (e) {
      print("❌ Delete task error: $e");
      return 0;
    }
  }

  // ==================== WEEKLY PLAN CRUD ====================

  /// Insert a new weekly plan
  Future<int> insertWeeklyPlan(WeeklyPlanModel plan) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.insert('weekly_plans', plan.toMap());
    } catch (e) {
      print("❌ Insert weekly plan error: $e");
      return -1;
    }
  }

  /// Get weekly plan by user and week number
  Future<WeeklyPlanModel?> getWeeklyPlanByUserAndWeek(
    int userId,
    int weekNumber,
  ) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'weekly_plans',
        where: 'user_id = ? AND week_number = ?',
        whereArgs: [userId, weekNumber],
      );

      if (maps.isEmpty) return null;
      return WeeklyPlanModel.fromMap(maps.first);
    } catch (e) {
      print("❌ Get weekly plan error: $e");
      return null;
    }
  }

  /// Get current (latest) weekly plan for a user
  Future<WeeklyPlanModel?> getCurrentWeeklyPlan(int userId) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'weekly_plans',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'week_number DESC',
        limit: 1,
      );

      if (maps.isEmpty) return null;
      return WeeklyPlanModel.fromMap(maps.first);
    } catch (e) {
      print("❌ Get current weekly plan error: $e");
      return null;
    }
  }

  /// Get all weekly plans for a user
  Future<List<WeeklyPlanModel>> getAllWeeklyPlansByUser(int userId) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'weekly_plans',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'week_number ASC',
      );
      return maps.map((map) => WeeklyPlanModel.fromMap(map)).toList();
    } catch (e) {
      print("❌ Get all weekly plans error: $e");
      return [];
    }
  }

  /// Delete weekly plan (cascade deletes day schedules)
  Future<int> deleteWeeklyPlan(int weeklyPlanId) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.delete(
        'weekly_plans',
        where: 'weekly_plan_id = ?',
        whereArgs: [weeklyPlanId],
      );
    } catch (e) {
      print("❌ Delete weekly plan error: $e");
      return 0;
    }
  }

  // ==================== DAY SCHEDULE CRUD ====================

  /// Insert a new day schedule
  Future<int> insertDaySchedule(DayScheduleModel day) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.insert('day_schedule', day.toMap());
    } catch (e) {
      print("❌ Insert day schedule error: $e");
      return -1;
    }
  }

  /// Get all days for a weekly plan
  Future<List<DayScheduleModel>> getDaysByWeeklyPlan(int weeklyPlanId) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'day_schedule',
        where: 'weekly_plan_id = ?',
        whereArgs: [weeklyPlanId],
        orderBy: 'day_index ASC',
      );
      return maps.map((map) => DayScheduleModel.fromMap(map)).toList();
    } catch (e) {
      print("❌ Get days by weekly plan error: $e");
      return [];
    }
  }

  /// Get a specific day by ID
  Future<DayScheduleModel?> getDayById(int dayId) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'day_schedule',
        where: 'day_id = ?',
        whereArgs: [dayId],
      );

      if (maps.isEmpty) return null;
      return DayScheduleModel.fromMap(maps.first);
    } catch (e) {
      print("❌ Get day by id error: $e");
      return null;
    }
  }

  /// Delete day schedule
  Future<int> deleteDaySchedule(int dayId) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.delete(
        'day_schedule',
        where: 'day_id = ?',
        whereArgs: [dayId],
      );
    } catch (e) {
      print("❌ Delete day schedule error: $e");
      return 0;
    }
  }

  // ==================== DAY WORKOUT CRUD ====================

  /// Insert a new day-workout relationship
  Future<int> insertDayWorkout(DayWorkoutModel dayWorkout) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.insert('day_workout', dayWorkout.toMap());
    } catch (e) {
      print("❌ Insert day workout error: $e");
      return -1;
    }
  }

  /// Assign a workout to a day
  Future<int> assignWorkoutToDay(int dayId, int workoutId) async {
    return await insertDayWorkout(
      DayWorkoutModel(dayId: dayId, workoutId: workoutId),
    );
  }

  /// Get all workouts for a specific day
  Future<List<WorkoutModel>> getWorkoutsByDayId(int dayId) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        '''
        SELECT w.* FROM workouts w
        INNER JOIN day_workout dw ON w.workout_id = dw.workout_id
        WHERE dw.day_id = ?
        ORDER BY dw.day_workout_id ASC
      ''',
        [dayId],
      );

      return maps.map((map) => WorkoutModel.fromMap(map)).toList();
    } catch (e) {
      print("❌ Get workouts by day error: $e");
      return [];
    }
  }

  /// Remove a workout from a day
  Future<int> removeDayWorkout(int dayWorkoutId) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.delete(
        'day_workout',
        where: 'day_workout_id = ?',
        whereArgs: [dayWorkoutId],
      );
    } catch (e) {
      print("❌ Remove day workout error: $e");
      return 0;
    }
  }

  /// Remove all workouts from a day
  Future<int> removeAllWorkoutsFromDay(int dayId) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.delete(
        'day_workout',
        where: 'day_id = ?',
        whereArgs: [dayId],
      );
    } catch (e) {
      print("❌ Remove all workouts from day error: $e");
      return 0;
    }
  }

  // ==================== COMPLEX QUERIES ====================

  /// Get complete weekly plan with all nested data
  /// (weekly plan -> days -> workouts -> tasks)
  Future<WeeklyPlanModel?> getFullWeeklyPlan(int userId, int weekNumber) async {
    try {
      // 1. Get the weekly plan
      final weeklyPlan = await getWeeklyPlanByUserAndWeek(userId, weekNumber);
      if (weeklyPlan == null) return null;

      // 2. Get all days for this plan
      final days = await getDaysByWeeklyPlan(weeklyPlan.weeklyPlanId!);

      // 3. For each day, get workouts with tasks
      final List<DayScheduleModel> daysWithWorkouts = [];
      for (var day in days) {
        final workouts = await getWorkoutsByDayId(day.dayId!);

        // 4. For each workout, get tasks
        final List<WorkoutModel> workoutsWithTasks = [];
        for (var workout in workouts) {
          final tasks = await getTasksByWorkoutId(workout.workoutId!);
          workoutsWithTasks.add(workout.copyWith(tasks: tasks));
        }

        daysWithWorkouts.add(
          DayScheduleModel(
            dayId: day.dayId,
            weeklyPlanId: day.weeklyPlanId,
            dayIndex: day.dayIndex,
            workouts: workoutsWithTasks,
          ),
        );
      }

      return WeeklyPlanModel(
        weeklyPlanId: weeklyPlan.weeklyPlanId,
        userId: weeklyPlan.userId,
        weekNumber: weeklyPlan.weekNumber,
        days: daysWithWorkouts,
      );
    } catch (e) {
      print("❌ Get full weekly plan error: $e");
      return null;
    }
  }

  /// Get a specific day with all workouts and tasks
  Future<DayScheduleModel?> getDayWithWorkouts(int dayId) async {
    try {
      final db = await DBHelper.getDatabase();

      // Get day info
      final List<Map<String, dynamic>> dayMaps = await db.query(
        'day_schedule',
        where: 'day_id = ?',
        whereArgs: [dayId],
      );

      if (dayMaps.isEmpty) return null;

      final day = DayScheduleModel.fromMap(dayMaps.first);

      // Get workouts for this day
      final workouts = await getWorkoutsByDayId(dayId);

      // Get tasks for each workout
      final List<WorkoutModel> workoutsWithTasks = [];
      for (var workout in workouts) {
        final tasks = await getTasksByWorkoutId(workout.workoutId!);
        workoutsWithTasks.add(workout.copyWith(tasks: tasks));
      }

      return DayScheduleModel(
        dayId: day.dayId,
        weeklyPlanId: day.weeklyPlanId,
        dayIndex: day.dayIndex,
        workouts: workoutsWithTasks,
      );
    } catch (e) {
      print("❌ Get day with workouts error: $e");
      return null;
    }
  }

  // ==================== WORKOUT PLAN GENERATION ====================

  /// Generate a new weekly plan for a user
  /// Creates empty days based on activeDaysPerWeek
  Future<WeeklyPlanModel?> generateWeeklyPlanForUser(
    int userId,
    int activeDaysPerWeek,
  ) async {
    try {
      final db = await DBHelper.getDatabase();

      // Get current week number
      final currentPlan = await getCurrentWeeklyPlan(userId);
      final weekNumber = currentPlan == null ? 1 : currentPlan.weekNumber + 1;

      // Create weekly plan
      final weeklyPlanId = await insertWeeklyPlan(
        WeeklyPlanModel(userId: userId, weekNumber: weekNumber),
      );

      if (weeklyPlanId == -1) return null;

      // Create day schedules
      for (int i = 1; i <= activeDaysPerWeek; i++) {
        await insertDaySchedule(
          DayScheduleModel(weeklyPlanId: weeklyPlanId, dayIndex: i),
        );
      }

      return await getFullWeeklyPlan(userId, weekNumber);
    } catch (e) {
      print("❌ Generate weekly plan error: $e");
      return null;
    }
  }

  // ==================== STATISTICS & HELPERS ====================

  /// Get total workout duration for a specific workout
  Future<int> getTotalWorkoutDuration(int workoutId) async {
    try {
      final tasks = await getTasksByWorkoutId(workoutId);
      return tasks.fold<int>(0, (sum, task) => sum + task.durationSec);
    } catch (e) {
      print("❌ Get total duration error: $e");
      return 0;
    }
  }

  /// Get workout statistics
  Future<Map<String, dynamic>> getWorkoutStats(int workoutId) async {
    try {
      final tasks = await getTasksByWorkoutId(workoutId);

      if (tasks.isEmpty) {
        return {
          'totalDuration': 0,
          'totalCalories': 0,
          'exerciseCount': 0,
          'rounds': 0,
        };
      }

      final totalDuration = tasks.fold<int>(
        0,
        (sum, task) => sum + task.durationSec,
      );

      final maxRound = tasks.fold<int>(
        0,
        (max, task) => task.roundNumber > max ? task.roundNumber : max,
      );

      // Rough calorie estimate (5 cal/min)
      final totalCalories = (totalDuration / 60 * 5).round();

      return {
        'totalDuration': totalDuration,
        'totalCalories': totalCalories,
        'exerciseCount': tasks.length,
        'rounds': maxRound,
      };
    } catch (e) {
      print("❌ Get workout stats error: $e");
      return {
        'totalDuration': 0,
        'totalCalories': 0,
        'exerciseCount': 0,
        'rounds': 0,
      };
    }
  }

  /// Get number of workouts in a day
  Future<int> getWorkoutCountForDay(int dayId) async {
    try {
      final db = await DBHelper.getDatabase();
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM day_workout WHERE day_id = ?',
        [dayId],
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print("❌ Get workout count error: $e");
      return 0;
    }
  }
}
