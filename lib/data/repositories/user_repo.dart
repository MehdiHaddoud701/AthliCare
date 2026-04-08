// repositories/user_repository.dart
import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../models/users_model.dart';

class UserRepository {
  // ==================== CREATE ====================

  /// Insert a new user into the database
  /// Returns the user_id of the inserted user, or -1 on error
  Future<int> insertUser(UserModel user) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (e) {
      print("❌ Insert user error: $e");
      return -1;
    }
  }

  // ==================== READ ====================

  /// Get all users from the database
  Future<List<UserModel>> getAllUsers() async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query('users');
      return maps.map((map) => UserModel.fromMap(map)).toList();
    } catch (e) {
      print("❌ Get all users error: $e");
      return [];
    }
  }

  /// Get a user by their ID
  Future<UserModel?> getUserById(int userId) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      if (maps.isEmpty) return null;
      return UserModel.fromMap(maps.first);
    } catch (e) {
      print("❌ Get user by id error: $e");
      return null;
    }
  }

  /// Get a user by username
  Future<UserModel?> getUserByUsername(String username) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );

      if (maps.isEmpty) return null;
      return UserModel.fromMap(maps.first);
    } catch (e) {
      print("❌ Get user by username error: $e");
      return null;
    }
  }

  /// Get a user by email
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (maps.isEmpty) return null;
      return UserModel.fromMap(maps.first);
    } catch (e) {
      print("❌ Get user by email error: $e");
      return null;
    }
  }

  /// Check if a username already exists
  Future<bool> usernameExists(String username) async {
    final user = await getUserByUsername(username);
    return user != null;
  }

  /// Check if an email already exists
  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  // ==================== UPDATE ====================

  /// Update an existing user
  /// Returns the number of rows affected
  Future<int> updateUser(UserModel user) async {
    try {
      if (user.userId == null) {
        print("❌ Cannot update user without userId");
        return 0;
      }

      final db = await DBHelper.getDatabase();
      return await db.update(
        'users',
        user.toMap(),
        where: 'user_id = ?',
        whereArgs: [user.userId],
      );
    } catch (e) {
      print("❌ Update user error: $e");
      return 0;
    }
  }

  /// Update specific fields of a user
  Future<int> updateUserFields(int userId, Map<String, dynamic> fields) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.update(
        'users',
        fields,
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      print("❌ Update user fields error: $e");
      return 0;
    }
  }

  // ==================== DELETE ====================

  /// Delete a user by ID
  /// Returns the number of rows deleted
  Future<int> deleteUser(int userId) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.delete(
        'users',
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      print("❌ Delete user error: $e");
      return 0;
    }
  }

  // ==================== AUTHENTICATION ====================

  /// Validate user credentials
  /// Returns user if credentials match, null otherwise
  Future<UserModel?> validateCredentials(
    String username,
    String hashedPassword,
  ) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'username = ? AND hashed_password = ?',
        whereArgs: [username, hashedPassword],
      );

      if (maps.isEmpty) return null;
      return UserModel.fromMap(maps.first);
    } catch (e) {
      print("❌ Validate credentials error: $e");
      return null;
    }
  }

  // ==================== STATISTICS ====================

  /// Get total number of users
  Future<int> getTotalUsers() async {
    try {
      final db = await DBHelper.getDatabase();
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM users');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print("❌ Get total users error: $e");
      return 0;
    }
  }

  /// Get users by sport type
  Future<List<UserModel>> getUsersBySportType(String sportType) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'sport_type = ?',
        whereArgs: [sportType],
      );
      return maps.map((map) => UserModel.fromMap(map)).toList();
    } catch (e) {
      print("❌ Get users by sport type error: $e");
      return [];
    }
  }

  /// Get users by gender
  Future<List<UserModel>> getUsersByGender(String gender) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'gender = ?',
        whereArgs: [gender],
      );
      return maps.map((map) => UserModel.fromMap(map)).toList();
    } catch (e) {
      print("❌ Get users by gender error: $e");
      return [];
    }
  }
}
