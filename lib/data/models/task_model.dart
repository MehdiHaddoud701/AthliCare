// ==================== models/task_model.dart ====================
class TaskModel {
  final int? taskId;
  final int workoutId;
  final String? level; // 'easy', 'moderate', 'high'
  final int durationSec;
  final int roundNumber;
  final String title;
  final String? description;
  final String? imagePath;

  TaskModel({
    this.taskId,
    required this.workoutId,
    this.level,
    required this.durationSec,
    required this.roundNumber,
    required this.title,
    this.description,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      if (taskId != null) 'task_id': taskId,
      'workout_id': workoutId,
      'level': level,
      'duration_sec': durationSec,
      'round_number': roundNumber,
      'title': title,
      'description': description,
      'image_path': imagePath,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskId: map['task_id'] as int?,
      workoutId: map['workout_id'] as int,
      level: map['level'] as String?,
      durationSec: map['duration_sec'] as int,
      roundNumber: map['round_number'] as int,
      title: map['title'] as String,
      description: map['description'] as String?,
      imagePath: map['image_path'] as String?,
    );
  }

  TaskModel copyWith({
    int? taskId,
    int? workoutId,
    String? level,
    int? durationSec,
    int? roundNumber,
    String? title,
    String? description,
    String? imagePath,
  }) {
    return TaskModel(
      taskId: taskId ?? this.taskId,
      workoutId: workoutId ?? this.workoutId,
      level: level ?? this.level,
      durationSec: durationSec ?? this.durationSec,
      roundNumber: roundNumber ?? this.roundNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  // Helper method to format duration
  String getFormattedDuration() {
    final minutes = durationSec ~/ 60;
    final seconds = durationSec % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return 'TaskModel(taskId: $taskId, title: $title, round: $roundNumber, duration: ${getFormattedDuration()})';
  }
}
