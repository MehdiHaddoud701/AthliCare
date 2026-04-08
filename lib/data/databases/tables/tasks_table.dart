import '../db_base.dart';

class TasksTable extends DBBaseTable {
  TasksTable() : super("tasks");

  static const String sql = '''
    CREATE TABLE IF NOT EXISTS tasks (
      task_id INTEGER PRIMARY KEY AUTOINCREMENT,
      workout_id INTEGER NOT NULL REFERENCES workouts(workout_id) ON DELETE CASCADE,
      level TEXT CHECK(level IN ('easy','moderate','high')),
      duration_sec INTEGER NOT NULL CHECK(duration_sec BETWEEN 1 AND 9999),
      round_number INTEGER NOT NULL CHECK(round_number >= 1),
      title TEXT NOT NULL,
      description TEXT,
      image_path TEXT
    );
  ''';
}
