// import 'package:flutter/material.dart';
// import 'package:athlicare/presentation/widgets/CustomBottomNavBar.dart';
// import 'package:athlicare/core/constants/colors.dart';

// import 'injuries_page_3.dart';

// // =======================
// // PART 1: MAIN PAGE & DATA MODELS
// // =======================

// // Main page with tabs
// class InjuryRecoveryPage extends StatefulWidget {
//   const InjuryRecoveryPage({Key? key}) : super(key: key);

//   @override
//   State<InjuryRecoveryPage> createState() => _InjuryRecoveryPageState();
// }

// class _InjuryRecoveryPageState extends State<InjuryRecoveryPage> {
//   int _selectedIndex = 2; // Bottom nav
//   int selectedTab = 0; // 0 = Injury Treatment, 1 = Log Injury

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A1A),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header
//             _buildHeader(),

//             // Tab Buttons
//             _buildTabButtons(),

//             const SizedBox(height: 16),

//             // Content based on selected tab
//             Expanded(
//               child: selectedTab == 0 ? InjuryTreatmentList() : LogInjuryForm(),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNavBar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
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
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Row(
//         children: [
//           Expanded(child: _buildTabButton('Injury Treatment', 0)),
//           const SizedBox(width: 12),
//           Expanded(child: _buildTabButton('Log Your Injury', 1)),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabButton(String text, int index) {
//     final isSelected = selectedTab == index;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedTab = index;
//         });
//       },
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
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }

//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
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
//           'Learn about common injuries and their treatments, or log your current injury to track recovery progress.',
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
// // DATA MODEL
// // =======================

// class InjuryInfo {
//   final String name;
//   final String description;
//   final String imageUrl;
//   final String fullDescription;
//   final List<String> symptoms;
//   final List<String> treatments;
//   final String recoveryTime;
//   final List<String> preventionTips;

//   InjuryInfo({
//     required this.name,
//     required this.description,
//     required this.imageUrl,
//     required this.fullDescription,
//     required this.symptoms,
//     required this.treatments,
//     required this.recoveryTime,
//     required this.preventionTips,
//   });
// }

// // =======================
// // SAMPLE DATA
// // =======================

// final List<InjuryInfo> injuries = [
//   InjuryInfo(
//     name: 'Muscle Strain',
//     description:
//         'Overstretched or torn muscle fibers causing pain and stiffness...',
//     imageUrl:
//         'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=600&h=400&fit=crop',
//     fullDescription:
//         'A muscle strain occurs when muscle fibers are overstretched or torn, usually due to overexertion, poor form, or inadequate warm-up. This is one of the most common sports injuries.',
//     symptoms: [
//       'Sudden Pain: Sharp or aching pain in the affected muscle',
//       'Swelling: Visible swelling or bruising in the area',
//       'Limited Movement: Difficulty moving or using the muscle',
//       'Muscle Weakness: Reduced strength in the affected area',
//     ],
//     treatments: [
//       'Rest: Avoid activities that cause pain for 24-48 hours',
//       'Ice: Apply ice packs for 15-20 minutes every 2-3 hours',
//       'Compression: Use elastic bandage to reduce swelling',
//       'Elevation: Keep the injured area raised above heart level',
//       'Gentle Stretching: After 48 hours, begin gentle stretches',
//     ],
//     recoveryTime: '3-6 weeks depending on severity',
//     preventionTips: [
//       'Always warm up before exercise',
//       'Maintain proper form during workouts',
//       'Gradually increase workout intensity',
//       'Stay hydrated and maintain proper nutrition',
//     ],
//   ),
//   InjuryInfo(
//     name: 'Ankle Sprain',
//     description: 'Ligament injury in the ankle from rolling or twisting...',
//     imageUrl:
//         'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=600&h=400&fit=crop',
//     fullDescription:
//         'An ankle sprain occurs when the ligaments supporting the ankle stretch beyond their limits or tear. This commonly happens when the foot rolls inward or outward unexpectedly.',
//     symptoms: [
//       'Pain: Immediate pain when bearing weight',
//       'Swelling: Rapid swelling around the ankle',
//       'Bruising: Discoloration may appear within hours',
//       'Instability: Feeling that ankle may give way',
//     ],
//     treatments: [
//       'RICE Method: Rest, Ice, Compression, Elevation',
//       'No Weight Bearing: Use crutches if needed initially',
//       'Ankle Support: Wear a brace or wrap for stability',
//       'Physical Therapy: Strengthen surrounding muscles',
//       'Gradual Return: Slowly resume activities',
//     ],
//     recoveryTime: '2-6 weeks for mild sprains, 3-6 months for severe',
//     preventionTips: [
//       'Wear proper footwear with good support',
//       'Strengthen ankle muscles regularly',
//       'Be cautious on uneven surfaces',
//       'Use ankle braces if needed',
//     ],
//   ),
//   InjuryInfo(
//     name: 'Tennis Elbow',
//     description: 'Tendonitis of the elbow from repetitive motion...',
//     imageUrl:
//         'https://images.unsplash.com/photo-1598266663439-2056e6900339?w=600&h=400&fit=crop',
//     fullDescription:
//         'Tennis elbow (lateral epicondylitis) is inflammation of the tendons that join the forearm muscles to the outside of the elbow, caused by repetitive motion and overuse.',
//     symptoms: [
//       'Elbow Pain: Pain on the outside of the elbow',
//       'Weak Grip: Difficulty holding objects',
//       'Pain with Movement: Pain when extending wrist or gripping',
//       'Stiffness: Especially noticeable in the morning',
//     ],
//     treatments: [
//       'Rest: Avoid repetitive motions that cause pain',
//       'Ice Therapy: Apply ice several times daily',
//       'Bracing: Use a counterforce brace below the elbow',
//       'Physical Therapy: Strengthening and stretching exercises',
//       'Anti-inflammatories: As recommended by doctor',
//     ],
//     recoveryTime: '6 months to 1 year',
//     preventionTips: [
//       'Use proper technique in sports and activities',
//       'Strengthen forearm muscles',
//       'Take frequent breaks during repetitive tasks',
//       'Use proper equipment size and grip',
//     ],
//   ),
//   InjuryInfo(
//     name: 'Knee Injury',
//     description: 'Various injuries affecting the knee joint and ligaments...',
//     imageUrl:
//         'https://images.unsplash.com/photo-1434682881908-b43d0467b798?w=600&h=400&fit=crop',
//     fullDescription:
//         'Knee injuries can range from minor sprains to serious ligament tears (ACL, MCL, PCL) or meniscus damage. The knee is vulnerable due to its complex structure and load-bearing function.',
//     symptoms: [
//       'Swelling: Rapid or gradual swelling of the knee',
//       'Pain: Sharp pain or aching discomfort',
//       'Instability: Knee feels like it might give way',
//       'Popping Sound: May hear a pop at time of injury',
//     ],
//     treatments: [
//       'Immediate Rest: Stop activity immediately',
//       'Ice and Elevation: Reduce swelling',
//       'Immobilization: Use knee brace if needed',
//       'Medical Evaluation: See doctor for severe injuries',
//       'Rehabilitation: Physical therapy is crucial',
//     ],
//     recoveryTime: 'Varies: 2 weeks to 9 months depending on severity',
//     preventionTips: [
//       'Strengthen quadriceps and hamstrings',
//       'Practice proper landing techniques',
//       'Wear appropriate footwear',
//       'Avoid sudden changes in direction',
//     ],
//   ),
//   InjuryInfo(
//     name: 'Lower Back Strain',
//     description: 'Muscle or ligament strain in the lower back region...',
//     imageUrl:
//         'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=600&h=400&fit=crop',
//     fullDescription:
//         'Lower back strain involves damage to the muscles, ligaments, or tendons in the lumbar region. This is extremely common and can result from poor posture, improper lifting, or sudden movements.',
//     symptoms: [
//       'Pain: Dull ache or sharp pain in lower back',
//       'Muscle Spasms: Involuntary muscle contractions',
//       'Stiffness: Difficulty bending or standing straight',
//       'Limited Mobility: Reduced range of motion',
//     ],
//     treatments: [
//       'Rest: Short periods of rest (not extended bed rest)',
//       'Heat/Ice: Ice first 48 hours, then heat',
//       'Gentle Movement: Light walking aids recovery',
//       'Core Strengthening: Build supporting muscles',
//       'Posture Correction: Improve daily posture habits',
//     ],
//     recoveryTime: '2-4 weeks for most cases',
//     preventionTips: [
//       'Practice proper lifting techniques',
//       'Strengthen core muscles regularly',
//       'Maintain good posture throughout the day',
//       'Stretch regularly, especially hamstrings',
//     ],
//   ),
// ];

// // Injury Treatment List (like Articles list)
// class InjuryTreatmentList extends StatelessWidget {
//   const InjuryTreatmentList({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       itemCount: injuries.length,
//       itemBuilder: (context, index) {
//         return InjuryCard(injury: injuries[index]);
//       },
//     );
//   }
// }

// // Injury Card Widget
// class InjuryCard extends StatelessWidget {
//   final InjuryInfo injury;

//   const InjuryCard({Key? key, required this.injury}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => InjuryDetailScreen(injury: injury),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       injury.name,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       injury.description,
//                       style: TextStyle(color: Colors.grey[700], fontSize: 12),
//                       maxLines: 3,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.network(
//                 injury.imageUrl,
//                 width: 150,
//                 height: 120,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // =======================
// // INJURY DETAIL SCREEN
// // =======================

// class InjuryDetailScreen extends StatefulWidget {
//   final InjuryInfo injury;

//   const InjuryDetailScreen({Key? key, required this.injury}) : super(key: key);

//   @override
//   State<InjuryDetailScreen> createState() => _InjuryDetailScreenState();
// }

// class _InjuryDetailScreenState extends State<InjuryDetailScreen> {
//   int _selectedIndex = 2;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A1A),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                   const Expanded(
//                     child: Text(
//                       'Injury Treatment',
//                       style: TextStyle(
//                         color: AppColors.boxColor,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(
//                       Icons.bookmark_border,
//                       color: AppColors.secondry,
//                     ),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Content
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Title
//                     Text(
//                       widget.injury.name,
//                       style: const TextStyle(
//                         color: Colors.yellow,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Main Image
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       padding: const EdgeInsets.all(16),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.network(
//                           widget.injury.imageUrl,
//                           width: double.infinity,
//                           height: 200,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     // Description
//                     Text(
//                       widget.injury.fullDescription,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         height: 1.6,
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     // Recovery Time
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: AppColors.secondry.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: AppColors.secondry),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.access_time,
//                             color: AppColors.secondry,
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Recovery Time',
//                                   style: TextStyle(
//                                     color: AppColors.secondry,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   widget.injury.recoveryTime,
//                                   style: const TextStyle(color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     // Symptoms
//                     _buildSection('Common Symptoms', widget.injury.symptoms),
//                     const SizedBox(height: 24),

//                     // Treatments
//                     _buildSection('Treatment Steps', widget.injury.treatments),
//                     const SizedBox(height: 24),

//                     // Prevention
//                     _buildSection(
//                       'Prevention Tips',
//                       widget.injury.preventionTips,
//                     ),

//                     const SizedBox(height: 80),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNavBar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: (index) {
//           setState(() => _selectedIndex = index);
//         },
//       ),
//     );
//   }

//   Widget _buildSection(String title, List<String> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             color: Colors.red,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 12),
//         ...items.map((item) {
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (item.contains(':')) ...[
//                   Text(
//                     item.split(':')[0] + ':',
//                     style: const TextStyle(
//                       color: Colors.red,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     item.split(':')[1].trim(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       height: 1.6,
//                     ),
//                   ),
//                 ] else ...[
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         '• ',
//                         style: TextStyle(
//                           color: Colors.red,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Expanded(
//                         child: Text(
//                           item,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             height: 1.6,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ],
//             ),
//           );
//         }).toList(),
//       ],
//     );
//   }
// }
// // =======================
// // PART 3: LOG INJURY FORM TAB
// // =======================

// class LogInjuryForm extends StatefulWidget {
//   const LogInjuryForm({Key? key}) : super(key: key);

//   @override
//   State<LogInjuryForm> createState() => _LogInjuryFormState();
// }

// class _LogInjuryFormState extends State<LogInjuryForm> {
//   String? selectedInjuryType;
//   double painLevel = 5.0;
//   int daysResting = 0;
//   DateTime? injuryDate;
//   String? additionalNotes;

//   final List<String> injuryTypes = [
//     'Muscle Strain',
//     'Ankle Sprain',
//     'Tennis Elbow',
//     'Knee Injury',
//     'Lower Back Strain',
//     'Shoulder Injury',
//     'Wrist Sprain',
//     'Hamstring Pull',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Injury Type Dropdown
//           const Text(
//             'Injury Type',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           _buildDropdown(),
//           const SizedBox(height: 24),

//           // Injury Date
//           const Text(
//             'When did the injury occur?',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           _buildDatePicker(),
//           const SizedBox(height: 24),

//           // Pain Level Slider
//           const Text(
//             'Current Pain Level',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           _buildPainSlider(),
//           const SizedBox(height: 24),

//           // Days Resting Counter
//           const Text(
//             'Days Resting',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           _buildDaysCounter(),
//           const SizedBox(height: 24),

//           // Additional Notes
//           const Text(
//             'Additional Notes',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           _buildNotesField(),
//           const SizedBox(height: 32),

//           // Save Button
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: _saveInjuryLog,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.secondry,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text(
//                 'Save Injury Log',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),

//           const SizedBox(height: 24),

//           // Recovery Advice Card
//           _buildRecoveryAdviceCard(),
//         ],
//       ),
//     );
//   }

//   Widget _buildDropdown() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       decoration: BoxDecoration(
//         color: const Color(0xFF2A2A2A),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[800]!),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: selectedInjuryType,
//           hint: const Text(
//             'Select injury type',
//             style: TextStyle(color: Colors.grey),
//           ),
//           isExpanded: true,
//           dropdownColor: const Color(0xFF2A2A2A),
//           icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
//           items: injuryTypes.map((String type) {
//             return DropdownMenuItem<String>(
//               value: type,
//               child: Text(type, style: const TextStyle(color: Colors.white)),
//             );
//           }).toList(),
//           onChanged: (value) {
//             setState(() {
//               selectedInjuryType = value;
//             });
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildDatePicker() {
//     return GestureDetector(
//       onTap: () async {
//         final DateTime? picked = await showDatePicker(
//           context: context,
//           initialDate: injuryDate ?? DateTime.now(),
//           firstDate: DateTime(2020),
//           lastDate: DateTime.now(),
//           builder: (context, child) {
//             return Theme(
//               data: ThemeData.dark().copyWith(
//                 colorScheme: const ColorScheme.dark(
//                   primary: AppColors.secondry,
//                   surface: Color(0xFF2A2A2A),
//                 ),
//               ),
//               child: child!,
//             );
//           },
//         );
//         if (picked != null) {
//           setState(() {
//             injuryDate = picked;
//             daysResting = DateTime.now().difference(picked).inDays;
//           });
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xFF2A2A2A),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey[800]!),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               injuryDate != null
//                   ? '${injuryDate!.day}/${injuryDate!.month}/${injuryDate!.year}'
//                   : 'Select date',
//               style: TextStyle(
//                 color: injuryDate != null ? Colors.white : Colors.grey,
//               ),
//             ),
//             const Icon(Icons.calendar_today, color: AppColors.secondry),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPainSlider() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF2A2A2A),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[800]!),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 painLevel <= 3
//                     ? 'Mild'
//                     : painLevel <= 7
//                     ? 'Moderate'
//                     : 'Severe',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 painLevel.toInt().toString(),
//                 style: const TextStyle(
//                   color: AppColors.secondry,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           SliderTheme(
//             data: SliderThemeData(
//               activeTrackColor: AppColors.secondry,
//               inactiveTrackColor: Colors.grey[800],
//               thumbColor: AppColors.secondry,
//               overlayColor: AppColors.secondry.withOpacity(0.2),
//             ),
//             child: Slider(
//               value: painLevel,
//               min: 0,
//               max: 10,
//               divisions: 10,
//               onChanged: (value) {
//                 setState(() {
//                   painLevel = value;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDaysCounter() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF2A2A2A),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[800]!),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text('Days:', style: TextStyle(color: Colors.white)),
//           Row(
//             children: [
//               IconButton(
//                 onPressed: () {
//                   if (daysResting > 0) {
//                     setState(() {
//                       daysResting--;
//                     });
//                   }
//                 },
//                 icon: const Icon(
//                   Icons.remove_circle,
//                   color: AppColors.secondry,
//                 ),
//               ),
//               Text(
//                 daysResting.toString(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               IconButton(
//                 onPressed: () {
//                   setState(() {
//                     daysResting++;
//                   });
//                 },
//                 icon: const Icon(Icons.add_circle, color: AppColors.secondry),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNotesField() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF2A2A2A),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[800]!),
//       ),
//       child: TextField(
//         maxLines: 4,
//         style: const TextStyle(color: Colors.white),
//         decoration: const InputDecoration(
//           hintText: 'Add any additional notes about your injury...',
//           hintStyle: TextStyle(color: Colors.grey),
//           border: InputBorder.none,
//         ),
//         onChanged: (value) {
//           additionalNotes = value;
//         },
//       ),
//     );
//   }

//   Widget _buildRecoveryAdviceCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.secondry.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.secondry.withOpacity(0.3)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: const [
//               Icon(Icons.lightbulb_outline, color: AppColors.secondry),
//               SizedBox(width: 8),
//               Text(
//                 'Recovery Advice',
//                 style: TextStyle(
//                   color: AppColors.secondry,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           const Text(
//             'R.I.C.E Method:',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           _buildAdvicePoint('Rest', 'Avoid activities that cause pain'),
//           _buildAdvicePoint('Ice', 'Apply ice packs for 15-20 minutes'),
//           _buildAdvicePoint(
//             'Compression',
//             'Use elastic bandage to reduce swelling',
//           ),
//           _buildAdvicePoint('Elevation', 'Keep injured area raised'),
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.red.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               children: const [
//                 Icon(Icons.warning_amber, color: Colors.red, size: 20),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'Seek medical attention if pain persists or worsens',
//                     style: TextStyle(color: Colors.red, fontSize: 12),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAdvicePoint(String title, String description) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             '• ',
//             style: TextStyle(
//               color: AppColors.secondry,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Expanded(
//             child: RichText(
//               text: TextSpan(
//                 children: [
//                   TextSpan(
//                     text: '$title: ',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   TextSpan(
//                     text: description,
//                     style: const TextStyle(color: Colors.white70),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _saveInjuryLog() {
//     if (selectedInjuryType == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select an injury type'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     if (injuryDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select the injury date'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     // Here you would save to your database/storage
//     // For now, just show a success message
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Injury log saved successfully!'),
//         backgroundColor: Colors.green,
//       ),
//     );

//     // Optionally reset the form
//     setState(() {
//       selectedInjuryType = null;
//       painLevel = 5.0;
//       daysResting = 0;
//       injuryDate = null;
//       additionalNotes = null;
//     });
//   }
// }

// // Add this to the previous file after LogInjuryForm

// // =======================
// // TAB 2: CURRENT INJURY VIEW
// // =======================

// class CurrentInjuryView extends StatefulWidget {
//   final InjuryLog injury;
//   final Function(InjuryLog) onUpdate;
//   final Function() onComplete;

//   const CurrentInjuryView({
//     Key? key,
//     required this.injury,
//     required this.onUpdate,
//     required this.onComplete,
//   }) : super(key: key);

//   @override
//   State<CurrentInjuryView> createState() => _CurrentInjuryViewState();
// }

// class _CurrentInjuryViewState extends State<CurrentInjuryView> {
//   late double painLevel;
//   late int daysRested;

//   @override
//   void initState() {
//     super.initState();
//     painLevel = widget.injury.painLevel;
//     daysRested = widget.injury.daysRested;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final injuryInfo = injuryInfoDatabase[widget.injury.injuryType]!;

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Injury Summary Card
//           _buildSummaryCard(),
//           const SizedBox(height: 24),

//           // Recovery Progress
//           _buildRecoveryProgress(),
//           const SizedBox(height: 24),

//           // Days Remaining
//           _buildDaysRemaining(),
//           const SizedBox(height: 24),

//           // Current Pain Level
//           _buildPainLevelTracker(),
//           const SizedBox(height: 24),

//           // Days Rested Counter
//           _buildDaysRestedCounter(),
//           const SizedBox(height: 24),

//           // DO's Section
//           _buildDosDontsSection('DO\'s for Recovery', injuryInfo.dos, true),
//           const SizedBox(height: 24),

//           // DON'Ts Section
//           _buildDosDontsSection('DON\'Ts', injuryInfo.donts, false),
//           const SizedBox(height: 24),

//           // Mark as Recovered Button
//           _buildRecoveredButton(),
//           const SizedBox(height: 80),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryCard() {
//     Color severityColor;
//     if (widget.injury.severity == 'Mild')
//       severityColor = Colors.green;
//     else if (widget.injury.severity == 'Moderate')
//       severityColor = Colors.orange;
//     else
//       severityColor = Colors.red;

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             AppColors.secondry.withOpacity(0.2),
//             AppColors.secondry.withOpacity(0.05),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.secondry.withOpacity(0.3)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.medical_services, color: AppColors.secondry, size: 28),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   widget.injury.injuryType,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: severityColor.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: severityColor),
//                 ),
//                 child: Text(
//                   widget.injury.severity,
//                   style: TextStyle(
//                     color: severityColor,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 'Since ${widget.injury.injuryDate.day}/${widget.injury.injuryDate.month}/${widget.injury.injuryDate.year}',
//                 style: const TextStyle(color: Colors.white70, fontSize: 14),
//               ),
//             ],
//           ),
//           if (widget.injury.notes != null &&
//               widget.injury.notes!.isNotEmpty) ...[
//             const SizedBox(height: 12),
//             Text(
//               widget.injury.notes!,
//               style: const TextStyle(color: Colors.white60, fontSize: 13),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildRecoveryProgress() {
//     final progress = widget.injury.recoveryProgress;
//     final percentage = (progress * 100).toInt();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Recovery Progress',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               '$percentage%',
//               style: const TextStyle(
//                 color: AppColors.secondry,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: LinearProgressIndicator(
//             value: progress,
//             minHeight: 12,
//             backgroundColor: Colors.grey[800],
//             valueColor: AlwaysStoppedAnimation<Color>(
//               progress < 0.5
//                   ? Colors.red
//                   : progress < 0.8
//                   ? Colors.orange
//                   : Colors.green,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDaysRemaining() {
//     final remaining = widget.injury.daysRemaining;
//     final total = widget.injury.expectedRecoveryDays;
//     final elapsed = total - remaining;

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFF2A2A2A),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[800]!),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: AppColors.secondry.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(
//               Icons.schedule,
//               color: AppColors.secondry,
//               size: 32,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '$remaining days remaining',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '$elapsed of $total days elapsed',
//                   style: const TextStyle(color: Colors.white60, fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPainLevelTracker() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFF2A2A2A),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[800]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Current Pain Level',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 painLevel <= 3
//                     ? 'Mild'
//                     : painLevel <= 7
//                     ? 'Moderate'
//                     : 'Severe',
//                 style: TextStyle(
//                   color: painLevel <= 3
//                       ? Colors.green
//                       : painLevel <= 7
//                       ? Colors.orange
//                       : Colors.red,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 child: SliderTheme(
//                   data: SliderThemeData(
//                     activeTrackColor: AppColors.secondry,
//                     inactiveTrackColor: Colors.grey[800],
//                     thumbColor: AppColors.secondry,
//                     overlayColor: AppColors.secondry.withOpacity(0.2),
//                   ),
//                   child: Slider(
//                     value: painLevel,
//                     min: 0,
//                     max: 10,
//                     divisions: 10,
//                     onChanged: (value) {
//                       setState(() => painLevel = value);
//                       widget.injury.painLevel = value;
//                       widget.onUpdate(widget.injury);
//                     },
//                   ),
//                 ),
//               ),
//               Text(
//                 painLevel.toInt().toString(),
//                 style: const TextStyle(
//                   color: AppColors.secondry,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDaysRestedCounter() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFF2A2A2A),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[800]!),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             'Days Rested',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Row(
//             children: [
//               IconButton(
//                 onPressed: () {
//                   if (daysRested > 0) {
//                     setState(() => daysRested--);
//                     widget.injury.daysRested = daysRested;
//                     widget.onUpdate(widget.injury);
//                   }
//                 },
//                 icon: const Icon(
//                   Icons.remove_circle,
//                   color: AppColors.secondry,
//                   size: 32,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: AppColors.secondry.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   daysRested.toString(),
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               IconButton(
//                 onPressed: () {
//                   setState(() => daysRested++);
//                   widget.injury.daysRested = daysRested;
//                   widget.onUpdate(widget.injury);
//                 },
//                 icon: const Icon(
//                   Icons.add_circle,
//                   color: AppColors.secondry,
//                   size: 32,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDosDontsSection(String title, List<String> items, bool isDo) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(
//               isDo ? Icons.check_circle : Icons.cancel,
//               color: isDo ? Colors.green : Colors.red,
//               size: 24,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         ...items
//             .map(
//               (item) => Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: isDo
//                         ? Colors.green.withOpacity(0.1)
//                         : Colors.red.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: isDo
//                           ? Colors.green.withOpacity(0.3)
//                           : Colors.red.withOpacity(0.3),
//                     ),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(
//                         isDo ? Icons.check : Icons.close,
//                         color: isDo ? Colors.green : Colors.red,
//                         size: 20,
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           item,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             height: 1.5,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//             .toList(),
//       ],
//     );
//   }

//   Widget _buildRecoveredButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               backgroundColor: const Color(0xFF2A2A2A),
//               title: const Text(
//                 'Mark as Recovered?',
//                 style: TextStyle(color: Colors.white),
//               ),
//               content: const Text(
//                 'Are you sure you want to mark this injury as fully recovered?',
//                 style: TextStyle(color: Colors.white70),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text(
//                     'Cancel',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     widget.onComplete();
//                   },
//                   child: const Text(
//                     'Yes, Recovered!',
//                     style: TextStyle(color: Colors.green),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.green,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         child: const Text(
//           'Mark as Recovered',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

// // =======================
// // TAB 3: INJURY HISTORY
// // =======================

// class InjuryHistoryList extends StatelessWidget {
//   final List<InjuryLog> injuries;

//   const InjuryHistoryList({Key? key, required this.injuries}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (injuries.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.history, size: 80, color: Colors.grey[700]),
//             const SizedBox(height: 16),
//             const Text(
//               'No injury history yet',
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Your past injuries will appear here',
//               style: TextStyle(color: Colors.white54, fontSize: 14),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: injuries.length,
//       itemBuilder: (context, index) {
//         return InjuryHistoryCard(injury: injuries[index]);
//       },
//     );
//   }
// }

// class InjuryHistoryCard extends StatelessWidget {
//   final InjuryLog injury;

//   const InjuryHistoryCard({Key? key, required this.injury}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Color severityColor;
//     if (injury.severity == 'Mild')
//       severityColor = Colors.green;
//     else if (injury.severity == 'Moderate')
//       severityColor = Colors.orange;
//     else
//       severityColor = Colors.red;

//     final daysSince = DateTime.now().difference(injury.injuryDate).inDays;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF2A2A2A),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[800]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[800],
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(
//                   Icons.medical_services_outlined,
//                   color: Colors.white70,
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       injury.injuryType,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '$daysSince days ago',
//                       style: const TextStyle(
//                         color: Colors.white60,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: severityColor.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: severityColor),
//                 ),
//                 child: Text(
//                   injury.severity,
//                   style: TextStyle(
//                     color: severityColor,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 11,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Divider(color: Colors.grey[800], height: 1),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               _buildStat(
//                 Icons.calendar_today,
//                 'Date',
//                 '${injury.injuryDate.day}/${injury.injuryDate.month}/${injury.injuryDate.year}',
//               ),
//               const SizedBox(width: 16),
//               _buildStat(Icons.timer, 'Rested', '${injury.daysRested} days'),
//             ],
//           ),
//           if (injury.notes != null && injury.notes!.isNotEmpty) ...[
//             const SizedBox(height: 12),
//             Text(
//               injury.notes!,
//               style: const TextStyle(
//                 color: Colors.white54,
//                 fontSize: 13,
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildStat(IconData icon, String label, String value) {
//     return Expanded(
//       child: Row(
//         children: [
//           Icon(icon, color: AppColors.secondry, size: 16),
//           const SizedBox(width: 6),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(color: Colors.white54, fontSize: 11),
//               ),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 13,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
