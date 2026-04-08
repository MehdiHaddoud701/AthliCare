class InjuryLog {
  final String id;
  final String injuryType;
  final double painLevel;
  final int daysResting;
  final DateTime dateLogged;
  final String notes;
  final double recoveryProgress;

  InjuryLog({
    required this.id,
    required this.injuryType,
    required this.painLevel,
    required this.daysResting,
    required this.dateLogged,
    this.notes = '',
    this.recoveryProgress = 0.0,
  });

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'injuryType': injuryType,
      'painLevel': painLevel,
      'daysResting': daysResting,
      'dateLogged': dateLogged.toIso8601String(),
      'notes': notes,
      'recoveryProgress': recoveryProgress,
    };
  }

  // Create from Map
  factory InjuryLog.fromMap(Map<String, dynamic> map) {
    return InjuryLog(
      id: map['id'],
      injuryType: map['injuryType'],
      painLevel: map['painLevel'],
      daysResting: map['daysResting'],
      dateLogged: DateTime.parse(map['dateLogged']),
      notes: map['notes'] ?? '',
      recoveryProgress: map['recoveryProgress'] ?? 0.0,
    );
  }

  // Copy with method for updates
  InjuryLog copyWith({
    String? id,
    String? injuryType,
    double? painLevel,
    int? daysResting,
    DateTime? dateLogged,
    String? notes,
    double? recoveryProgress,
  }) {
    return InjuryLog(
      id: id ?? this.id,
      injuryType: injuryType ?? this.injuryType,
      painLevel: painLevel ?? this.painLevel,
      daysResting: daysResting ?? this.daysResting,
      dateLogged: dateLogged ?? this.dateLogged,
      notes: notes ?? this.notes,
      recoveryProgress: recoveryProgress ?? this.recoveryProgress,
    );
  }
}

class InjuryInformation {
  final String name;
  final String description;
  final List<String> symptoms;
  final List<String> treatments;
  final String severity;
  final int estimatedRecoveryDays;

  InjuryInformation({
    required this.name,
    required this.description,
    required this.symptoms,
    required this.treatments,
    required this.severity,
    required this.estimatedRecoveryDays,
  });
}

// Sample injury information database
class InjuryDatabase {
  static final List<InjuryInformation> injuries = [
    InjuryInformation(
      name: 'Muscle Strain',
      description:
          'A muscle strain occurs when muscle fibers are overstretched or torn. Severity levels: Mild (slight discomfort), Moderate (pain with movement), Severe (significant pain and loss of function).',
      symptoms: [
        'Pain',
        'Swelling',
        'Limited range of motion',
        'Muscle weakness',
      ],
      treatments: [
        'Rest',
        'Ice application',
        'Compression',
        'Gentle stretching',
      ],
      severity: 'Mild to Severe',
      estimatedRecoveryDays: 14,
    ),
    InjuryInformation(
      name: 'Sprain',
      description:
          'A sprain is a stretching or tearing of ligaments. Common in ankles, knees, and wrists. Rest, ice, compression, and elevation are key treatments.',
      symptoms: [
        'Pain',
        'Swelling',
        'Bruising',
        'Limited mobility',
        'Popping sound at time of injury',
      ],
      treatments: [
        'R.I.C.E method',
        'Elevation',
        'Pain medication',
        'Physical therapy',
      ],
      severity: 'Grade 1-3',
      estimatedRecoveryDays: 21,
    ),
    InjuryInformation(
      name: 'Fracture',
      description:
          'A fracture is a broken bone. Can range from a hairline crack to a complete break. Requires immediate medical attention and immobilization.',
      symptoms: [
        'Severe pain',
        'Swelling',
        'Deformity',
        'Inability to move',
        'Bruising',
      ],
      treatments: [
        'Immobilization',
        'Cast or splint',
        'Surgery (if needed)',
        'Pain management',
      ],
      severity: 'Severe',
      estimatedRecoveryDays: 42,
    ),
    InjuryInformation(
      name: 'Tendonitis',
      description:
          'Inflammation of a tendon, often caused by repetitive motion. Common in shoulders, elbows, wrists, knees, and ankles.',
      symptoms: [
        'Pain during movement',
        'Tenderness',
        'Mild swelling',
        'Stiffness',
      ],
      treatments: [
        'Rest',
        'Ice',
        'Anti-inflammatory medication',
        'Physical therapy',
        'Stretching exercises',
      ],
      severity: 'Mild to Moderate',
      estimatedRecoveryDays: 28,
    ),
    InjuryInformation(
      name: 'Bruise',
      description:
          'A bruise occurs when small blood vessels break and leak blood into surrounding tissue. Usually heals on its own with rest and ice.',
      symptoms: ['Skin discoloration', 'Tenderness', 'Swelling', 'Pain'],
      treatments: ['Ice application', 'Rest', 'Elevation', 'Compression'],
      severity: 'Mild',
      estimatedRecoveryDays: 7,
    ),
    InjuryInformation(
      name: 'Dislocation',
      description:
          'A dislocation occurs when bones in a joint are forced out of their normal positions. Requires immediate medical attention.',
      symptoms: [
        'Visible deformity',
        'Severe pain',
        'Swelling',
        'Inability to move joint',
      ],
      treatments: [
        'Medical reduction',
        'Immobilization',
        'Pain management',
        'Rehabilitation',
      ],
      severity: 'Severe',
      estimatedRecoveryDays: 35,
    ),
    InjuryInformation(
      name: 'Torn Ligament',
      description:
          'A complete tear of a ligament that connects bones together. Often requires surgery and extensive rehabilitation.',
      symptoms: [
        'Severe pain',
        'Popping sound',
        'Instability',
        'Swelling',
        'Bruising',
      ],
      treatments: [
        'Surgery',
        'Immobilization',
        'Physical therapy',
        'Gradual strengthening',
      ],
      severity: 'Severe',
      estimatedRecoveryDays: 90,
    ),
    InjuryInformation(
      name: 'Back Injury',
      description:
          'Can include muscle strains, herniated discs, or other spinal issues. Range from mild to severe requiring medical intervention.',
      symptoms: [
        'Back pain',
        'Stiffness',
        'Limited mobility',
        'Radiating pain',
        'Numbness',
      ],
      treatments: [
        'Rest',
        'Physical therapy',
        'Pain management',
        'Core strengthening',
        'Proper posture',
      ],
      severity: 'Mild to Severe',
      estimatedRecoveryDays: 30,
    ),
  ];

  static InjuryInformation? getInjuryByName(String name) {
    try {
      return injuries.firstWhere((injury) => injury.name == name);
    } catch (e) {
      return null;
    }
  }
}
