import 'task_model.dart';

class WorkoutModel {
  final int? workoutId;
  final String title;
  final String? description;
  final String? imagePath;
  final List<TaskModel>? tasks; // Optional: populated when needed

  WorkoutModel({
    this.workoutId,
    required this.title,
    this.description,
    this.imagePath,
    this.tasks,
  });

  Map<String, dynamic> toMap() {
    return {
      if (workoutId != null) 'workout_id': workoutId,
      'title': title,
      'description': description,
      'image_path': imagePath,
    };
  }

  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    return WorkoutModel(
      workoutId: map['workout_id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      imagePath: map['image_path'] as String?,
      tasks: null, // Tasks loaded separately
    );
  }

  WorkoutModel copyWith({
    int? workoutId,
    String? title,
    String? description,
    String? imagePath,
    List<TaskModel>? tasks,
  }) {
    return WorkoutModel(
      workoutId: workoutId ?? this.workoutId,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  String toString() {
    return 'WorkoutModel(workoutId: $workoutId, title: $title, tasksCount: ${tasks?.length ?? 0})';
  }
}
