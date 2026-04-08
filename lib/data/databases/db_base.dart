import 'package:sqflite/sqflite.dart';
import 'db_helper.dart';

// class DBBaseTable {
//   final String tableName;

//   DBBaseTable(this.tableName);

//   // Insert and return inserted row id
//   Future<int> insert(Map<String, dynamic> data) async {
//     final db = await DBHelper.getDatabase();
//     return await db.insert(
//       tableName,
//       data,
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   // Generic query all
//   Future<List<Map<String, dynamic>>> getAll({String? orderBy}) async {
//     final db = await DBHelper.getDatabase();
//     return await db.query(tableName, orderBy: orderBy);
//   }

//   // Query with where clause
//   Future<List<Map<String, dynamic>>> getWhere(
//     String where,
//     List<Object?> args, {
//     String? orderBy,
//   }) async {
//     final db = await DBHelper.getDatabase();
//     return await db.query(
//       tableName,
//       where: where,
//       whereArgs: args,
//       orderBy: orderBy,
//     );
//   }

//   // Update by where
//   Future<int> update(
//     Map<String, dynamic> data,
//     String where,
//     List<Object?> args,
//   ) async {
//     final db = await DBHelper.getDatabase();
//     return await db.update(tableName, data, where: where, whereArgs: args);
//   }

//   // Delete by where
//   Future<int> delete(String where, List<Object?> args) async {
//     final db = await DBHelper.getDatabase();
//     return await db.delete(tableName, where: where, whereArgs: args);
//   }
// }
class DBBaseTable {
  late final String tableName;

  DBBaseTable(this.tableName);

  Future<bool> insertRecord(Map<String, dynamic> data) async {
    try {
      final db = await DBHelper.getDatabase();
      await db.insert(
        tableName,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print("Insert error: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getRecords() async {
    try {
      final db = await DBHelper.getDatabase();
      return await db.query(tableName, orderBy: "ROWID DESC");
    } catch (e) {
      print("Query error: $e");
      return [];
    }
  }
}
