import '../db_base.dart';

class WeeklyPlansTable extends DBBaseTable {
  WeeklyPlansTable() : super("weekly_plans");

  static const String sql = '''
    CREATE TABLE IF NOT EXISTS weekly_plans (
      weekly_plan_id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
      week_number INTEGER NOT NULL CHECK(week_number >= 0),
      UNIQUE(user_id, week_number)
    );
  ''';
}
