import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../models/injury_model.dart';

class InjuryRepository {
  // ==================== CREATE ====================
  InjuryRepository();

  /// Insert a new injury
  Future<int> insertInjury(InjuryModel injury) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.insert('injuries', injury.toMap());
    } catch (e) {
      print("❌ Insert injury error: $e");
      return -1;
    }
  }

  // ==================== READ ====================

  /// Get all active injuries for a user
  Future<List<InjuryModel>> getActiveInjuries(int userId) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'injuries',
        where: 'user_id = ? AND is_active = 1',
        whereArgs: [userId],
        orderBy: 'injury_date DESC',
      );
      return maps.map((map) => InjuryModel.fromMap(map)).toList();
    } catch (e) {
      print("❌ Get active injuries error: $e");
      return [];
    }
  }

  /// Get injury history (recovered injuries) for a user
  Future<List<InjuryModel>> getInjuryHistory(int userId) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'injuries',
        where: 'user_id = ? AND is_active = 0',
        whereArgs: [userId],
        orderBy: 'recovered_date DESC',
      );
      return maps.map((map) => InjuryModel.fromMap(map)).toList();
    } catch (e) {
      print("❌ Get injury history error: $e");
      return [];
    }
  }

  /// Get a specific injury by ID
  Future<InjuryModel?> getInjuryById(int injuryId) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'injuries',
        where: 'injury_id = ?',
        whereArgs: [injuryId],
      );

      if (maps.isEmpty) return null;
      return InjuryModel.fromMap(maps.first);
    } catch (e) {
      print("❌ Get injury by id error: $e");
      return null;
    }
  }

  /// Get all injuries (active + history) for a user
  Future<List<InjuryModel>> getAllInjuries(int userId) async {
    try {
      final db = await DBHelper.getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        'injuries',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'is_active DESC, injury_date DESC',
      );
      return maps.map((map) => InjuryModel.fromMap(map)).toList();
    } catch (e) {
      print("❌ Get all injuries error: $e");
      return [];
    }
  }

  // ==================== UPDATE ====================

  /// Update an injury
  Future<int> updateInjury(InjuryModel injury) async {
    try {
      if (injury.injuryId == null) return 0;

      final db = await DBHelper.getDatabase();
      return await db.update(
        'injuries',
        injury.toMap(),
        where: 'injury_id = ?',
        whereArgs: [injury.injuryId],
      );
    } catch (e) {
      print("❌ Update injury error: $e");
      return 0;
    }
  }

  /// Update pain level
  Future<int> updatePainLevel(int injuryId, double painLevel) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.update(
        'injuries',
        {
          'current_pain_level': painLevel,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'injury_id = ?',
        whereArgs: [injuryId],
      );
    } catch (e) {
      print("❌ Update pain level error: $e");
      return 0;
    }
  }

  /// Update days rested
  Future<int> updateDaysRested(int injuryId, int daysRested) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.update(
        'injuries',
        {
          'days_rested': daysRested,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'injury_id = ?',
        whereArgs: [injuryId],
      );
    } catch (e) {
      print("❌ Update days rested error: $e");
      return 0;
    }
  }

  /// Mark injury as recovered
  Future<int> markAsRecovered(int injuryId) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.update(
        'injuries',
        {
          'is_active': 0,
          'recovered_date': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'injury_id = ?',
        whereArgs: [injuryId],
      );
    } catch (e) {
      print("❌ Mark as recovered error: $e");
      return 0;
    }
  }

  // ==================== DELETE ====================

  /// Delete an injury
  Future<int> deleteInjury(int injuryId) async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.delete(
        'injuries',
        where: 'injury_id = ?',
        whereArgs: [injuryId],
      );
    } catch (e) {
      print("❌ Delete injury error: $e");
      return 0;
    }
  }

  // ==================== STATISTICS ====================

  /// Get count of active injuries
  Future<int> getActiveInjuryCount(int userId) async {
    try {
      final db = await DBHelper.getDatabase();
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM injuries WHERE user_id = ? AND is_active = 1',
        [userId],
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print("❌ Get active injury count error: $e");
      return 0;
    }
  }

  /// Get total recovery days across all active injuries
  Future<int> getTotalRecoveryDays(int userId) async {
    try {
      final injuries = await getActiveInjuries(userId);
      return injuries.fold<int>(0, (sum, injury) => sum + injury.daysRemaining);
    } catch (e) {
      print("❌ Get total recovery days error: $e");
      return 0;
    }
  }
}
