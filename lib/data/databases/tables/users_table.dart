import '../db_base.dart';

class UsersTable extends DBBaseTable {
  UsersTable() : super("users");

  static const String sql = '''
    CREATE TABLE IF NOT EXISTS users (
      user_id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL UNIQUE,
      email TEXT NOT NULL UNIQUE,
      hashed_password TEXT NOT NULL,
      age INTEGER NOT NULL,
      gender TEXT NOT NULL,
      height REAL NOT NULL,
      weight REAL NOT NULL,
      sport_type TEXT NOT NULL,
      active_days_per_week INTEGER NOT NULL CHECK(active_days_per_week BETWEEN 1 AND 7),
      first_sign_in_date TEXT NOT NULL DEFAULT CURRENT_DATE
    );
  ''';
}
