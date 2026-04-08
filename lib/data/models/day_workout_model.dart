// class DayWorkout {
//   final int dayWorkoutId;
//   final int dayId;
//   final int workoutId;

//   DayWorkout({
//     required this.dayWorkoutId,
//     required this.dayId,
//     required this.workoutId,
//   });
// }
import 'workout_model.dart';

class DayWorkoutModel {
  final int? dayWorkoutId;
  final int dayId;
  final int workoutId;

  DayWorkoutModel({
    this.dayWorkoutId,
    required this.dayId,
    required this.workoutId,
  });

  Map<String, dynamic> toMap() {
    return {
      if (dayWorkoutId != null) 'day_workout_id': dayWorkoutId,
      'day_id': dayId,
      'workout_id': workoutId,
    };
  }

  factory DayWorkoutModel.fromMap(Map<String, dynamic> map) {
    return DayWorkoutModel(
      dayWorkoutId: map['day_workout_id'] as int?,
      dayId: map['day_id'] as int,
      workoutId: map['workout_id'] as int,
    );
  }

  DayWorkoutModel copyWith({int? dayWorkoutId, int? dayId, int? workoutId}) {
    return DayWorkoutModel(
      dayWorkoutId: dayWorkoutId ?? this.dayWorkoutId,
      dayId: dayId ?? this.dayId,
      workoutId: workoutId ?? this.workoutId,
    );
  }

  @override
  String toString() {
    return 'DayWorkoutModel(dayWorkoutId: $dayWorkoutId, dayId: $dayId, workoutId: $workoutId)';
  }
}
