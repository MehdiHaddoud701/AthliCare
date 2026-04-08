import 'workout_model.dart';

class DayScheduleModel {
  final int? dayId;
  final int weeklyPlanId;
  final int dayIndex; // 1-7 (Monday to Sunday or Day 1 to Day 7)
  final List<WorkoutModel>? workouts; // Optional: populated when needed

  DayScheduleModel({
    this.dayId,
    required this.weeklyPlanId,
    required this.dayIndex,
    this.workouts,
  });

  Map<String, dynamic> toMap() {
    return {
      if (dayId != null) 'day_id': dayId,
      'weekly_plan_id': weeklyPlanId,
      'day_index': dayIndex,
    };
  }

  factory DayScheduleModel.fromMap(Map<String, dynamic> map) {
    return DayScheduleModel(
      dayId: map['day_id'] as int?,
      weeklyPlanId: map['weekly_plan_id'] as int,
      dayIndex: map['day_index'] as int,
      workouts: null, // Workouts loaded separately
    );
  }

  DayScheduleModel copyWith({
    int? dayId,
    int? weeklyPlanId,
    int? dayIndex,
    List<WorkoutModel>? workouts,
  }) {
    return DayScheduleModel(
      dayId: dayId ?? this.dayId,
      weeklyPlanId: weeklyPlanId ?? this.weeklyPlanId,
      dayIndex: dayIndex ?? this.dayIndex,
      workouts: workouts ?? this.workouts,
    );
  }

  // Helper to get day name
  String getDayName() {
    const days = ['', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven'];
    return dayIndex <= 7 ? 'Day ${days[dayIndex]}' : 'Day $dayIndex';
  }

  @override
  String toString() {
    return 'DayScheduleModel(dayId: $dayId, dayIndex: $dayIndex, workoutsCount: ${workouts?.length ?? 0})';
  }
}
