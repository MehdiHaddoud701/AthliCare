class InjuryInfo {
  final String name;
  final List<String> dos;
  final List<String> donts;
  final int typicalRecoveryDays;
  final String description;

  InjuryInfo({
    required this.name,
    required this.dos,
    required this.donts,
    required this.typicalRecoveryDays,
    required this.description,
  });
}

class InjuryInfoDatabase {
  static final Map<String, InjuryInfo> data = {
    'Muscle Strain': InjuryInfo(
      name: 'Muscle Strain',
      description:
          'A muscle strain occurs when muscle fibers are overstretched or torn.',
      dos: [
        'Rest the affected muscle for 24-48 hours',
        'Apply ice packs for 15-20 minutes every 2-3 hours',
        'Use compression bandages to reduce swelling',
        'Elevate the injured area above heart level',
        'Start gentle stretching after 48 hours',
        'Take anti-inflammatory medication as directed',
      ],
      donts: [
        'Don\'t continue activities that cause pain',
        'Don\'t apply heat in the first 48 hours',
        'Don\'t massage the injury immediately',
        'Don\'t return to full activity too quickly',
        'Don\'t ignore persistent or worsening pain',
      ],
      typicalRecoveryDays: 21,
    ),
    'Ankle Sprain': InjuryInfo(
      name: 'Ankle Sprain',
      description:
          'A sprain is a stretching or tearing of ligaments in the ankle.',
      dos: [
        'Follow the R.I.C.E method (Rest, Ice, Compression, Elevation)',
        'Use crutches if weight-bearing is painful',
        'Wear an ankle brace for support',
        'Do gentle ankle exercises after swelling reduces',
        'Gradually increase weight-bearing as tolerated',
      ],
      donts: [
        'Don\'t walk on it if it\'s very painful',
        'Don\'t remove support too early',
        'Don\'t return to sports without proper healing',
        'Don\'t ignore instability symptoms',
      ],
      typicalRecoveryDays: 28,
    ),
    'Tennis Elbow': InjuryInfo(
      name: 'Tennis Elbow',
      description: 'Inflammation of tendons on the outside of the elbow.',
      dos: [
        'Rest and avoid repetitive arm movements',
        'Apply ice to reduce inflammation',
        'Use a counterforce brace',
        'Perform gentle stretching exercises',
        'Consider physical therapy',
      ],
      donts: [
        'Don\'t continue activities that cause pain',
        'Don\'t grip objects tightly',
        'Don\'t ignore early warning signs',
        'Don\'t skip strengthening exercises',
      ],
      typicalRecoveryDays: 180,
    ),
    'Knee Injury': InjuryInfo(
      name: 'Knee Injury',
      description:
          'Various knee injuries including ligament tears and cartilage damage.',
      dos: [
        'Stop activity immediately',
        'Apply ice and elevate the knee',
        'Use knee brace if recommended',
        'Seek medical evaluation for severe pain',
        'Do prescribed rehabilitation exercises',
      ],
      donts: [
        'Don\'t ignore popping sounds or instability',
        'Don\'t rush back to sports',
        'Don\'t skip physical therapy',
        'Don\'t put weight on it if very painful',
      ],
      typicalRecoveryDays: 42,
    ),
    'Lower Back Strain': InjuryInfo(
      name: 'Lower Back Strain',
      description:
          'Strain or sprain of muscles and ligaments in the lower back.',
      dos: [
        'Stay active with gentle movement',
        'Apply ice first 48 hours, then heat',
        'Practice proper posture',
        'Strengthen core muscles',
        'Use proper lifting techniques',
      ],
      donts: [
        'Don\'t stay in bed for extended periods',
        'Don\'t bend or twist suddenly',
        'Don\'t lift heavy objects',
        'Don\'t ignore proper ergonomics',
      ],
      typicalRecoveryDays: 21,
    ),
    'Shoulder Injury': InjuryInfo(
      name: 'Shoulder Injury',
      description:
          'Rotator cuff injuries, dislocations, or general shoulder pain.',
      dos: [
        'Rest the shoulder',
        'Apply ice to reduce swelling',
        'Do gentle range-of-motion exercises',
        'Maintain good posture',
        'Follow rehabilitation program',
      ],
      donts: [
        'Don\'t do overhead activities that hurt',
        'Don\'t sleep on the injured shoulder',
        'Don\'t lift heavy objects',
        'Don\'t ignore persistent pain',
      ],
      typicalRecoveryDays: 35,
    ),
    'Wrist Sprain': InjuryInfo(
      name: 'Wrist Sprain',
      description: 'Ligament injury in the wrist from falling or twisting.',
      dos: [
        'Immobilize with a splint or brace',
        'Apply ice regularly',
        'Keep wrist elevated',
        'Do gentle exercises after healing starts',
      ],
      donts: [
        'Don\'t use the wrist for heavy lifting',
        'Don\'t remove support too early',
        'Don\'t ignore numbness or tingling',
      ],
      typicalRecoveryDays: 14,
    ),
    'Hamstring Pull': InjuryInfo(
      name: 'Hamstring Pull',
      description: 'Tear or strain of the hamstring muscle group.',
      dos: [
        'Rest immediately',
        'Apply ice for first 48 hours',
        'Use compression wrap',
        'Start gentle stretching after acute phase',
        'Strengthen gradually',
      ],
      donts: [
        'Don\'t stretch aggressively early on',
        'Don\'t run until fully healed',
        'Don\'t skip warm-up exercises',
      ],
      typicalRecoveryDays: 28,
    ),
  };

  static List<String> get injuryTypes => data.keys.toList();

  static InjuryInfo? getInfo(String injuryType) => data[injuryType];
}
