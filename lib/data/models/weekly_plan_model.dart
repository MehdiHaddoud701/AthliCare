import 'day_scheduale_model.dart';

class WeeklyPlanModel {
  final int? weeklyPlanId;
  final int userId;
  final int weekNumber;
  final List<DayScheduleModel>? days; // Optional: populated when needed

  WeeklyPlanModel({
    this.weeklyPlanId,
    required this.userId,
    required this.weekNumber,
    this.days,
  });

  Map<String, dynamic> toMap() {
    return {
      if (weeklyPlanId != null) 'weekly_plan_id': weeklyPlanId,
      'user_id': userId,
      'week_number': weekNumber,
    };
  }

  factory WeeklyPlanModel.fromMap(Map<String, dynamic> map) {
    return WeeklyPlanModel(
      weeklyPlanId: map['weekly_plan_id'] as int?,
      userId: map['user_id'] as int,
      weekNumber: map['week_number'] as int,
      days: null, // Days loaded separately
    );
  }

  WeeklyPlanModel copyWith({
    int? weeklyPlanId,
    int? userId,
    int? weekNumber,
    List<DayScheduleModel>? days,
  }) {
    return WeeklyPlanModel(
      weeklyPlanId: weeklyPlanId ?? this.weeklyPlanId,
      userId: userId ?? this.userId,
      weekNumber: weekNumber ?? this.weekNumber,
      days: days ?? this.days,
    );
  }

  @override
  String toString() {
    return 'WeeklyPlanModel(weeklyPlanId: $weeklyPlanId, userId: $userId, weekNumber: $weekNumber, daysCount: ${days?.length ?? 0})';
  }
}
