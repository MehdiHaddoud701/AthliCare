import '../db_base.dart';

class WorkoutsTable extends DBBaseTable {
  WorkoutsTable() : super("workouts");

  static const String sql = '''
    CREATE TABLE IF NOT EXISTS workouts (
      workout_id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT,
      image_path TEXT
    );
  ''';
}
