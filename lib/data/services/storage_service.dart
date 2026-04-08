import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _completedTasksKey = 'completed_tasks';
  static const String _completedDaysKey = 'completed_days';

  /// Save completed task IDs
  static Future<void> saveCompletedTasks(Set<int> taskIds) async {
    final prefs = await SharedPreferences.getInstance();
    final taskIdStrings = taskIds.map((id) => id.toString()).toList();
    await prefs.setStringList(_completedTasksKey, taskIdStrings);
    print('💾 Saved ${taskIds.length} completed tasks');
  }

  /// Load completed task IDs
  static Future<Set<int>> loadCompletedTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskIdStrings = prefs.getStringList(_completedTasksKey) ?? [];
    final taskIds = taskIdStrings.map((id) => int.parse(id)).toSet();
    print('📂 Loaded ${taskIds.length} completed tasks: $taskIds');
    return taskIds;
  }

  /// Save completed day IDs
  static Future<void> saveCompletedDays(Set<int> dayIds) async {
    final prefs = await SharedPreferences.getInstance();
    final dayIdStrings = dayIds.map((id) => id.toString()).toList();
    await prefs.setStringList(_completedDaysKey, dayIdStrings);
    print('💾 Saved ${dayIds.length} completed days');
  }

  /// Load completed day IDs
  static Future<Set<int>> loadCompletedDays() async {
    final prefs = await SharedPreferences.getInstance();
    final dayIdStrings = prefs.getStringList(_completedDaysKey) ?? [];
    final dayIds = dayIdStrings.map((id) => int.parse(id)).toSet();
    print('📂 Loaded ${dayIds.length} completed days: $dayIds');
    return dayIds;
  }

  /// Clear all completion data (for testing or reset)
  static Future<void> clearAllCompletions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedTasksKey);
    await prefs.remove(_completedDaysKey);
    print('🗑️ Cleared all completion data');
  }

  /// Clear completed tasks only
  static Future<void> clearCompletedTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedTasksKey);
    print('🗑️ Cleared completed tasks');
  }

  /// Clear completed days only
  static Future<void> clearCompletedDays() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedDaysKey);
    print('🗑️ Cleared completed days');
  }
}