// import 'package:flutter/material.dart';
// import 'package:athlicare/presentation/widgets/CustomBottomNavBar.dart';
// import 'package:athlicare/core/constants/colors.dart';
// import 'package:athlicare/presentation/pages/injuries/expandable_injury_card.dart';
// import 'package:athlicare/presentation/pages/injuries/section_header.dart';

// // =======================
// // DATA MODELS
// // =======================

// class InjuryLog {
//   final String id;
//   final String injuryType;
//   final String severity;
//   final DateTime injuryDate;
//   final int expectedRecoveryDays;
//   final String? notes;
//   bool isActive;
//   double painLevel;
//   int daysRested;

//   InjuryLog({
//     required this.id,
//     required this.injuryType,
//     required this.severity,
//     required this.injuryDate,
//     required this.expectedRecoveryDays,
//     this.notes,
//     this.isActive = true,
//     this.painLevel = 5.0,
//     this.daysRested = 0,
//   });

//   int get daysRemaining {
//     int elapsed = DateTime.now().difference(injuryDate).inDays;
//     int remaining = expectedRecoveryDays - elapsed;
//     return remaining > 0 ? remaining : 0;
//   }

//   double get recoveryProgress {
//     int elapsed = DateTime.now().difference(injuryDate).inDays;
//     double progress = elapsed / expectedRecoveryDays;
//     return progress > 1.0 ? 1.0 : progress;
//   }
// }

// class InjuryInfo {
//   final String name;
//   final List<String> dos;
//   final List<String> donts;
//   final int typicalRecoveryDays;

//   InjuryInfo({
//     required this.name,
//     required this.dos,
//     required this.donts,
//     required this.typicalRecoveryDays,
//   });
// }

// // Sample injury information database
// final Map<String, InjuryInfo> injuryInfoDatabase = {
//   'Muscle Strain': InjuryInfo(
//     name: 'Muscle Strain',
//     dos: [
//       'Rest the affected muscle for 24-48 hours',
//       'Apply ice packs for 15-20 minutes every 2-3 hours',
//       'Use compression bandages to reduce swelling',
//       'Elevate the injured area above heart level',
//       'Start gentle stretching after 48 hours',
//       'Take anti-inflammatory medication as directed',
//     ],
//     donts: [
//       'Don\'t continue activities that cause pain',
//       'Don\'t apply heat in the first 48 hours',
//       'Don\'t massage the injury immediately',
//       'Don\'t return to full activity too quickly',
//       'Don\'t ignore persistent or worsening pain',
//     ],
//     typicalRecoveryDays: 21,
//   ),
//   'Ankle Sprain': InjuryInfo(
//     name: 'Ankle Sprain',
//     dos: [
//       'Follow the R.I.C.E method (Rest, Ice, Compression, Elevation)',
//       'Use crutches if weight-bearing is painful',
//       'Wear an ankle brace for support',
//       'Do gentle ankle exercises after swelling reduces',
//       'Gradually increase weight-bearing as tolerated',
//     ],
//     donts: [
//       'Don\'t walk on it if it\'s very painful',
//       'Don\'t remove support too early',
//       'Don\'t return to sports without proper healing',
//       'Don\'t ignore instability symptoms',
//     ],
//     typicalRecoveryDays: 28,
//   ),
//   'Tennis Elbow': InjuryInfo(
//     name: 'Tennis Elbow',
//     dos: [
//       'Rest and avoid repetitive arm movements',
//       'Apply ice to reduce inflammation',
//       'Use a counterforce brace',
//       'Perform gentle stretching exercises',
//       'Consider physical therapy',
//     ],
//     donts: [
//       'Don\'t continue activities that cause pain',
//       'Don\'t grip objects tightly',
//       'Don\'t ignore early warning signs',
//       'Don\'t skip strengthening exercises',
//     ],
//     typicalRecoveryDays: 180,
//   ),
//   'Knee Injury': InjuryInfo(
//     name: 'Knee Injury',
//     dos: [
//       'Stop activity immediately',
//       'Apply ice and elevate the knee',
//       'Use knee brace if recommended',
//       'Seek medical evaluation for severe pain',
//       'Do prescribed rehabilitation exercises',
//     ],
//     donts: [
//       'Don\'t ignore popping sounds or instability',
//       'Don\'t rush back to sports',
//       'Don\'t skip physical therapy',
//       'Don\'t put weight on it if very painful',
//     ],
//     typicalRecoveryDays: 42,
//   ),
//   'Lower Back Strain': InjuryInfo(
//     name: 'Lower Back Strain',
//     dos: [
//       'Stay active with gentle movement',
//       'Apply ice first 48 hours, then heat',
//       'Practice proper posture',
//       'Strengthen core muscles',
//       'Use proper lifting techniques',
//     ],
//     donts: [
//       'Don\'t stay in bed for extended periods',
//       'Don\'t bend or twist suddenly',
//       'Don\'t lift heavy objects',
//       'Don\'t ignore proper ergonomics',
//     ],
//     typicalRecoveryDays: 21,
//   ),
//   'Shoulder Injury': InjuryInfo(
//     name: 'Shoulder Injury',
//     dos: [
//       'Rest the shoulder',
//       'Apply ice to reduce swelling',
//       'Do gentle range-of-motion exercises',
//       'Maintain good posture',
//       'Follow rehabilitation program',
//     ],
//     donts: [
//       'Don\'t do overhead activities that hurt',
//       'Don\'t sleep on the injured shoulder',
//       'Don\'t lift heavy objects',
//       'Don\'t ignore persistent pain',
//     ],
//     typicalRecoveryDays: 35,
//   ),
//   'Wrist Sprain': InjuryInfo(
//     name: 'Wrist Sprain',
//     dos: [
//       'Immobilize with a splint or brace',
//       'Apply ice regularly',
//       'Keep wrist elevated',
//       'Do gentle exercises after healing starts',
//     ],
//     donts: [
//       'Don\'t use the wrist for heavy lifting',
//       'Don\'t remove support too early',
//       'Don\'t ignore numbness or tingling',
//     ],
//     typicalRecoveryDays: 14,
//   ),
//   'Hamstring Pull': InjuryInfo(
//     name: 'Hamstring Pull',
//     dos: [
//       'Rest immediately',
//       'Apply ice for first 48 hours',
//       'Use compression wrap',
//       'Start gentle stretching after acute phase',
//       'Strengthen gradually',
//     ],
//     donts: [
//       'Don\'t stretch aggressively early on',
//       'Don\'t run until fully healed',
//       'Don\'t skip warm-up exercises',
//     ],
//     typicalRecoveryDays: 28,
//   ),
// };

// // =======================
// // MAIN PAGE
// // =======================

// class InjuryRecoveryPage extends StatefulWidget {
//   const InjuryRecoveryPage({Key? key}) : super(key: key);

//   @override
//   State<InjuryRecoveryPage> createState() => _InjuryRecoveryPageState();
// }

// class _InjuryRecoveryPageState extends State<InjuryRecoveryPage> {
//   int _selectedIndex = 2;
//   int selectedTab = 0;

//   // Changed to support multiple active injuries
//   List<InjuryLog> currentInjuries = [];
//   List<InjuryLog> injuryHistory = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadInjuryData();
//   }

//   void _loadInjuryData() {
//     // Sample data with multiple active injuries
//     currentInjuries = [
//       InjuryLog(
//         id: '1',
//         injuryType: 'Muscle Strain',
//         severity: 'Moderate',
//         injuryDate: DateTime.now().subtract(const Duration(days: 5)),
//         expectedRecoveryDays: 21,
//         notes: 'Occurred during workout',
//         painLevel: 4.0,
//         daysRested: 5,
//       ),
//       InjuryLog(
//         id: '3',
//         injuryType: 'Wrist Sprain',
//         severity: 'Mild',
//         injuryDate: DateTime.now().subtract(const Duration(days: 3)),
//         expectedRecoveryDays: 14,
//         notes: 'Twisted during exercise',
//         painLevel: 3.0,
//         daysRested: 3,
//       ),
//     ];

//     injuryHistory = [
//       InjuryLog(
//         id: '2',
//         injuryType: 'Ankle Sprain',
//         severity: 'Mild',
//         injuryDate: DateTime.now().subtract(const Duration(days: 45)),
//         expectedRecoveryDays: 28,
//         isActive: false,
//         painLevel: 0,
//         daysRested: 28,
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A1A),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(),
//             _buildTabButtons(),
//             const SizedBox(height: 16),
//             Expanded(child: _buildContent()),
//           ],
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNavBar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: (index) => setState(() => _selectedIndex = index),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//           const Expanded(
//             child: Text(
//               'Injury & Recovery',
//               style: TextStyle(
//                 color: AppColors.boxColor,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.help_outline, color: AppColors.secondry),
//             onPressed: _showHelpDialog,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabButtons() {
//     List<String> tabs = ['Log Injury'];

//     if (currentInjuries.isNotEmpty) {
//       tabs.add('Current Injuries');
//     }

//     tabs.add('History');

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Row(
//         children: List.generate(tabs.length, (index) {
//           return Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(
//                 right: index < tabs.length - 1 ? 8 : 0,
//                 left: index > 0 ? 8 : 0,
//               ),
//               child: _buildTabButton(tabs[index], index),
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   Widget _buildTabButton(String text, int index) {
//     final isSelected = selectedTab == index;
//     return GestureDetector(
//       onTap: () => setState(() => selectedTab = index),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.secondry : Colors.white,
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Text(
//           text,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 13,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildContent() {
//     int actualTab = selectedTab;

//     if (currentInjuries.isEmpty) {
//       if (selectedTab >= 1) actualTab = selectedTab + 1;
//     }

//     if (actualTab == 0) {
//       return LogInjuryForm(onInjuryLogged: _onInjuryLogged);
//     } else if (actualTab == 1) {
//       return CurrentInjuriesListView(
//         injuries: currentInjuries,
//         onUpdate: _onCurrentInjuryUpdated,
//         onComplete: _onInjuryCompleted,
//       );
//     } else {
//       return InjuryHistoryList(injuries: injuryHistory);
//     }
//   }

//   void _onInjuryLogged(InjuryLog newInjury) {
//     setState(() {
//       currentInjuries.add(newInjury);
//       selectedTab = 1;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Injury logged successfully!'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   void _onCurrentInjuryUpdated(InjuryLog updated) {
//     setState(() {
//       int index = currentInjuries.indexWhere((i) => i.id == updated.id);
//       if (index != -1) {
//         currentInjuries[index] = updated;
//       }
//     });
//   }

//   void _onInjuryCompleted(String injuryId) {
//     setState(() {
//       int index = currentInjuries.indexWhere((i) => i.id == injuryId);
//       if (index != -1) {
//         currentInjuries[index].isActive = false;
//         injuryHistory.insert(0, currentInjuries[index]);
//         currentInjuries.removeAt(index);
        
//         if (currentInjuries.isEmpty) {
//           selectedTab = 0;
//         }
//       }
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Injury marked as recovered! 🎉'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   void _showHelpDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF2A2A2A),
//         title: const Text(
//           'Help & Information',
//           style: TextStyle(color: Colors.white),
//         ),
//         content: const Text(
//           'Log your injuries, track current recovery progress, and view your injury history. Follow the dos and don\'ts for faster recovery.',
//           style: TextStyle(color: Colors.white70),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text(
//               'Got it',
//               style: TextStyle(color: AppColors.secondry),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =======================
// // TAB 1: LOG INJURY FORM
// // =======================

// class LogInjuryForm extends StatefulWidget {
//   final Function(InjuryLog) onInjuryLogged;

//   const LogInjuryForm({Key? key, required this.onInjuryLogged})
//       : super(key: key);

//   @override
//   State<LogInjuryForm> createState() => _LogInjuryFormState();
// }

// class _LogInjuryFormState extends State<LogInjuryForm> {
//   String? selectedInjuryType;
//   String? selectedSeverity;
//   DateTime? injuryDate;
//   String? additionalNotes;
//   double painLevel = 5.0;

//   final List<String> injuryTypes = injuryInfoDatabase.keys.toList();
//   final List<String> severityLevels = ['Mild', 'Moderate', 'Severe'];

//   final Map<String, String> injuryInfo = {
//     'Muscle Strain':
//         'A muscle strain occurs when muscle fibers are overstretched or torn. Severity levels: Mild (slight discomfort), Moderate (pain with movement), Severe (significant pain and loss of function).',
//     'Sprain':
//         'A sprain is a stretching or tearing of ligaments. Common in ankles, knees, and wrists. Rest, ice, compression, and elevation are key treatments.',
//     'Fracture':
//         'A fracture is a broken bone. Can range from a hairline crack to a complete break. Requires immediate medical attention and immobilization.',
//     'Tendonitis':
//         'Inflammation of a tendon, often caused by repetitive motion. Common in shoulders, elbows, wrists, knees, and ankles.',
//     'Bruise':
//         'A bruise occurs when small blood vessels break and leak blood into surrounding tissue. Usually heals on its own with rest and ice.',
//   };

//   Widget _buildInjuryInformationCards() {
//     return Column(
//       children: [
//         ExpandableInjuryCard(
//           title: 'Muscle Strain',
//           description: injuryInfo['Muscle Strain']!,
//         ),
//         ExpandableInjuryCard(
//           title: 'Sprain',
//           description: injuryInfo['Sprain']!,
//         ),
//         ExpandableInjuryCard(
//           title: 'Fracture',
//           description: injuryInfo['Fracture']!,
//         ),
//         ExpandableInjuryCard(
//           title: 'Tendonitis',
//           description: injuryInfo['Tendonitis']!,
//         ),
//         ExpandableInjuryCard(
//           title: 'Bruise',
//           description: injuryInfo['Bruise']!,
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(