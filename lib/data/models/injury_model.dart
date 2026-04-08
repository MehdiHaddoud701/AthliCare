class InjuryModel {
  final int? injuryId;
  final int userId;
  final String injuryType;
  final String severity;
  final DateTime injuryDate;
  final int expectedRecoveryDays;
  final double currentPainLevel;
  final int daysRested;
  final String? notes;
  final bool isActive;
  final DateTime? recoveredDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InjuryModel({
    this.injuryId,
    required this.userId,
    required this.injuryType,
    required this.severity,
    required this.injuryDate,
    required this.expectedRecoveryDays,
    this.currentPainLevel = 5.0,
    this.daysRested = 0,
    this.notes,
    this.isActive = true,
    this.recoveredDate,
    this.createdAt,
    this.updatedAt,
  });

  // Calculate days remaining
  int get daysRemaining {
    final elapsed = DateTime.now().difference(injuryDate).inDays;
    final remaining = expectedRecoveryDays - elapsed;
    return remaining > 0 ? remaining : 0;
  }

  // Calculate recovery progress (0.0 to 1.0)
  double get recoveryProgress {
    final elapsed = DateTime.now().difference(injuryDate).inDays;
    final progress = elapsed / expectedRecoveryDays;
    return progress > 1.0 ? 1.0 : (progress < 0.0 ? 0.0 : progress);
  }

  // Get days elapsed since injury
  int get daysElapsed {
    return DateTime.now().difference(injuryDate).inDays;
  }

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      if (injuryId != null) 'injury_id': injuryId,
      'user_id': userId,
      'injury_type': injuryType,
      'severity': severity,
      'injury_date': injuryDate.toIso8601String(),
      'expected_recovery_days': expectedRecoveryDays,
      'current_pain_level': currentPainLevel,
      'days_rested': daysRested,
      'notes': notes,
      'is_active': isActive ? 1 : 0,
      'recovered_date': recoveredDate?.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  // Create from Map (database)
  factory InjuryModel.fromMap(Map<String, dynamic> map) {
    return InjuryModel(
      injuryId: map['injury_id'] as int?,
      userId: map['user_id'] as int,
      injuryType: map['injury_type'] as String,
      severity: map['severity'] as String,
      injuryDate: DateTime.parse(map['injury_date'] as String),
      expectedRecoveryDays: map['expected_recovery_days'] as int,
      currentPainLevel: (map['current_pain_level'] as num).toDouble(),
      daysRested: map['days_rested'] as int,
      notes: map['notes'] as String?,
      isActive: (map['is_active'] as int) == 1,
      recoveredDate: map['recovered_date'] != null
          ? DateTime.parse(map['recovered_date'] as String)
          : null,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  // Copy with method for updates
  InjuryModel copyWith({
    int? injuryId,
    int? userId,
    String? injuryType,
    String? severity,
    DateTime? injuryDate,
    int? expectedRecoveryDays,
    double? currentPainLevel,
    int? daysRested,
    String? notes,
    bool? isActive,
    DateTime? recoveredDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InjuryModel(
      injuryId: injuryId ?? this.injuryId,
      userId: userId ?? this.userId,
      injuryType: injuryType ?? this.injuryType,
      severity: severity ?? this.severity,
      injuryDate: injuryDate ?? this.injuryDate,
      expectedRecoveryDays: expectedRecoveryDays ?? this.expectedRecoveryDays,
      currentPainLevel: currentPainLevel ?? this.currentPainLevel,
      daysRested: daysRested ?? this.daysRested,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      recoveredDate: recoveredDate ?? this.recoveredDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'InjuryModel(id: $injuryId, type: $injuryType, severity: $severity, active: $isActive)';
  }
}
