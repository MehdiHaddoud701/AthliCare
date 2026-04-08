import '../db_base.dart';

class DayScheduleTable extends DBBaseTable {
  DayScheduleTable() : super("day_schedule");

  static const String sql = '''
    CREATE TABLE IF NOT EXISTS day_schedule (
      day_id INTEGER PRIMARY KEY AUTOINCREMENT,
      weekly_plan_id INTEGER NOT NULL REFERENCES weekly_plans(weekly_plan_id) ON DELETE CASCADE,
      day_index INTEGER NOT NULL CHECK(day_index BETWEEN 1 AND 7)
    );
  ''';
}
