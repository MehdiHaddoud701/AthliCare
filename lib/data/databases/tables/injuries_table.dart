import '../db_base.dart';

class InjuriesTable extends DBBaseTable {
  InjuriesTable() : super("injuries");

  static const String sql = '''
    CREATE TABLE IF NOT EXISTS injuries (
      injury_id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      injury_type TEXT NOT NULL,
      severity TEXT NOT NULL CHECK(severity IN ('Mild', 'Moderate', 'Severe')),
      injury_date TEXT NOT NULL,
      expected_recovery_days INTEGER NOT NULL,
      current_pain_level REAL NOT NULL DEFAULT 5.0 CHECK(current_pain_level BETWEEN 0 AND 10),
      days_rested INTEGER NOT NULL DEFAULT 0,
      notes TEXT,
      is_active INTEGER NOT NULL DEFAULT 1,
      recovered_date TEXT,
      created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
    );
  ''';
  static const String indexSql = '''
    CREATE INDEX IF NOT EXISTS idx_injuries_user_active 
    ON injuries(user_id, is_active);
  ''';
}
