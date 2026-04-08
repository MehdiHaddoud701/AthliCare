// ==================== database/db_helper.dart ====================
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tables/users_table.dart';
import 'tables/workouts_table.dart';
import 'tables/tasks_table.dart';
import 'tables/weekly_plans_table.dart';
import 'tables/day_schedule_table.dart';
import 'tables/day_workout_table.dart';
import 'tables/injuries_table.dart';

class DBHelper {
  static Database? _database;
  static const String _databaseName = 'workout_app_2.db';
  static const int _databaseVersion = 1;

  // Singleton pattern
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  // Get database instance
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  static Future<Database> _initDatabase() async {
    // Get the database path
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    print('📁 Database path: $path');

    // Open/create the database
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  // Configure database (enable foreign keys)
  static Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
    print('✅ Foreign keys enabled');
  }

  // Create tables
  static Future<void> _onCreate(Database db, int version) async {
    print('🔨 Creating database tables...');

    // Create tables in order (respecting foreign key dependencies)
    await db.execute(UsersTable.sql);
    print('✅ Users table created');

    await db.execute(WorkoutsTable.sql);
    print('✅ Workouts table created');

    await db.execute(TasksTable.sql);
    print('✅ Tasks table created');

    await db.execute(WeeklyPlansTable.sql);
    print('✅ Weekly plans table created');

    await db.execute(DayScheduleTable.sql);
    print('✅ Day schedule table created');

    await db.execute(DayWorkoutTable.sql);
    print('✅ Day workout table created');

    await db.execute(InjuriesTable.sql);
    print('✅ ✅✅✅✅✅✅ Injuries table created');

    print('🎉 Database created successfully!');
  }

  // Handle database upgrades
  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    print('⬆️ Upgrading database from v$oldVersion to v$newVersion');
    // Add migration logic here when you update your schema
  }

  // Close database
  static Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      print('🔒 Database closed');
    }
  }

  // Delete database (useful for testing)
  static Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
    print('🗑️ Database deleted');
  }

  // Reset database (delete and recreate)
  static Future<void> resetDatabase() async {
    await closeDatabase();
    await deleteDatabase();
    await getDatabase();
    print('🔄 Database reset complete');
  }
}
