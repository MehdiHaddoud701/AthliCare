import '../db_base.dart';

class DayWorkoutTable extends DBBaseTable {
  DayWorkoutTable() : super("day_workout");

  static const String sql = '''
    CREATE TABLE IF NOT EXISTS day_workout (
      day_workout_id INTEGER PRIMARY KEY AUTOINCREMENT,
      day_id INTEGER NOT NULL REFERENCES day_schedule(day_id) ON DELETE CASCADE,
      workout_id INTEGER NOT NULL REFERENCES workouts(workout_id)
    );
  ''';
}
