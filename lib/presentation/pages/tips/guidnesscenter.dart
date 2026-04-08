// // import 'package:flutter/material.dart';
// // import 'package:athlicare/presentation/widgets/header.dart';
// // import 'package:athlicare/presentation/widgets/tabButtons.dart';
// // import 'package:athlicare/presentation/widgets/build_artical_vitamins_card.dart';
// // import 'package:athlicare/presentation/widgets/CustomBottomNavBar.dart';

// // // Data Model
// // class Article {
// //   final String title;
// //   final String description;
// //   final String imageUrl;
// //   final String category;
// //   final String fullDescription;
// //   final List<String> tips;

// //   Article({
// //     required this.title,
// //     required this.description,
// //     required this.imageUrl,
// //     required this.category,
// //     required this.fullDescription,
// //     required this.tips,
// //   });
// // }

// // // Sample Data
// // final List<Article> articles = [
// //   Article(
// //     title: 'Strength Training Tips',
// //     description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
// //     imageUrl:
// //         'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&h=400&fit=crop',
// //     category: 'Articles & Tips',
// //     fullDescription:
// //         'Discover essential Strength Training Tips to maximize your workouts and achieve your fitness goals efficiently. Learn how to optimize your routine, prevent injuries, and unlock your full potential in the gym.',
// //     tips: [
// //       'Plan Your Routine: Before starting any workout, plan your routine for the week. Focus on different muscle groups on different days to allow for adequate rest and recovery.',
// //       'Warm-Up: Begin your workout with a proper warm-up session. This could include light cardio exercises like jogging or jumping jacks, as well as dynamic stretches to prepare your muscles for the upcoming workout.',
// //     ],
// //   ),
// //   Article(
// //     title: 'Healthy Weight Loss',
// //     description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
// //     imageUrl:
// //         'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=600&h=400&fit=crop',
// //     category: 'Articles & Tips',
// //     fullDescription:
// //         'Learn effective strategies for healthy and sustainable weight loss through proper nutrition and exercise.',
// //     tips: [
// //       'Balanced Diet: Focus on whole foods, lean proteins, and plenty of vegetables.',
// //       'Portion Control: Use smaller plates and be mindful of serving sizes.',
// //       'Stay Hydrated: Drink plenty of water throughout the day.',
// //     ],
// //   ),
// //   Article(
// //     title: 'Unlock Your Gym Potential',
// //     description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
// //     imageUrl:
// //         'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=600&h=400&fit=crop',
// //     category: 'Articles & Tips',
// //     fullDescription:
// //         'Maximize your gym performance with these expert tips and techniques for better results.',
// //     tips: [
// //       'Set Clear Goals: Define specific, measurable fitness goals.',
// //       'Track Progress: Keep a workout journal to monitor improvements.',
// //       'Rest Days: Allow your body time to recover and rebuild.',
// //     ],
// //   ),
// //   Article(
// //     title: 'From Beginner To Buff',
// //     description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
// //     imageUrl:
// //         'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=600&h=400&fit=crop',
// //     category: 'Articles & Tips',
// //     fullDescription:
// //         'A complete guide for beginners to build muscle and strength progressively.',
// //     tips: [
// //       'Start Light: Begin with lighter weights to perfect your form.',
// //       'Progressive Overload: Gradually increase weight and intensity.',
// //       'Consistency: Stick to your routine for long-term results.',
// //     ],
// //   ),
// //   Article(
// //     title: 'Strategies For Gym Success',
// //     description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
// //     imageUrl:
// //         'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=600&h=400&fit=crop',
// //     category: 'Articles & Tips',
// //     fullDescription:
// //         'Proven strategies to achieve success in your fitness journey.',
// //     tips: [
// //       'Find a Workout Partner: Stay motivated with a gym buddy.',
// //       'Vary Your Routine: Prevent plateaus by changing exercises.',
// //       'Celebrate Milestones: Acknowledge your progress along the way.',
// //     ],
// //   ),
// // ];

// // // SCREEN 1: Guidance Center List
// // class GuidanceCenterScreen extends StatefulWidget {
// //   const GuidanceCenterScreen({Key? key}) : super(key: key);

// //   @override
// //   State<GuidanceCenterScreen> createState() => _GuidanceCenterScreenState();
// // }

// // class _GuidanceCenterScreenState extends State<GuidanceCenterScreen> {
// //   int selectedTab = 1; // 1 for Articles & Tips, 0 for Vitamines
// //   int bottomNavIndex = 0;
// //   int _selectedIndex = 1;
// //   void _onItemTapped(int index) {
// //     setState(() => _selectedIndex = index);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             Header(),
// //             TabsRow(selected: 1),
// //             const SizedBox(height: 16),
// //             Expanded(
// //               child: ListView.builder(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 itemCount: articles.length,
// //                 itemBuilder: (context, index) {
// //                   return ArticleCard(article: articles[index]);
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //       bottomNavigationBar: CustomBottomNavBar(
// //         selectedIndex: 3,
// //         onItemTapped: _onItemTapped,
// //       ),
// //     );
// //   }
// // }

// import 'package:athlicare/presentation/widgets/header.dart';
// import 'package:flutter/material.dart';
// import 'package:athlicare/presentation/widgets/tabButtons.dart';
// import 'package:athlicare/presentation/widgets/CustomBottomNavBar.dart';
// import 'package:athlicare/core/constants/colors.dart';
// import 'package:athlicare/logic/guidance_cubit.dart';
// import 'package:athlicare/data/models/article_model.dart';
// import 'package:athlicare/data/models/vitamin_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// // Remove the tipspage widget wrapper and use GuidanceCenterScreen directly
// // Or if you need tipspage, remove the MaterialApp from it:

// class tipspage extends StatelessWidget {
//   const tipspage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // REMOVED MaterialApp wrapper - this was causing navigation issues
//     return const GuidanceCenterScreen();
//   }
// }

// class Vitamin {
//   final String name;
//   final String description;
//   final String imageUrl;
//   final String category;
//   final String fullDescription;
//   final List<String> benefits;
//   final String dosage;
//   final List<String> sources;

//   Vitamin({
//     required this.name,
//     required this.description,
//     required this.imageUrl,
//     required this.category,
//     required this.fullDescription,
//     required this.benefits,
//     required this.dosage,
//     required this.sources,
//   });
// }

// // Sample Vitamins Data
// final List<Vitamin> vitamins = [
//   Vitamin(
//     name: 'Vitamin D',
//     description: 'Essential for bone health and immune function...',
//     imageUrl:
//         'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&h=400&fit=crop',
//     category: 'Vitamins',
//     fullDescription:
//         'Vitamin D is crucial for maintaining strong bones, supporting immune function, and regulating mood. It helps your body absorb calcium and phosphorus effectively.',
//     benefits: [
//       'Bone Health: Promotes calcium absorption and maintains bone density.',
//       'Immune Support: Enhances your immune system\'s ability to fight infections.',
//       'Mood Regulation: May help reduce symptoms of depression and anxiety.',
//       'Muscle Function: Supports muscle strength and reduces risk of falls.',
//     ],
//     dosage: '600-800 IU daily for adults',
//     sources: [
//       'Sunlight exposure (10-15 minutes daily)',
//       'Fatty fish (salmon, mackerel, tuna)',
//       'Fortified milk and dairy products',
//       'Egg yolks',
//       'Mushrooms',
//     ],
//   ),
//   Vitamin(
//     name: 'Vitamin B12',
//     description: 'Vital for energy production and nervous system health...',
//     imageUrl:
//         'https://images.unsplash.com/photo-1505576399279-565b52d4ac71?w=600&h=400&fit=crop',
//     category: 'Vitamins',
//     fullDescription:
//         'Vitamin B12 plays a critical role in red blood cell formation, nerve function, and DNA synthesis. It\'s essential for energy metabolism and brain health.',
//     benefits: [
//       'Energy Production: Helps convert food into usable energy.',
//       'Brain Health: Supports cognitive function and memory.',
//       'Red Blood Cell Formation: Prevents anemia and fatigue.',
//       'Nervous System: Maintains healthy nerve cells and myelin.',
//     ],
//     dosage: '2.4 mcg daily for adults',
//     sources: [
//       'Meat (beef, pork, lamb)',
//       'Fish and shellfish',
//       'Eggs and dairy products',
//       'Fortified cereals',
//       'Nutritional yeast',
//     ],
//   ),
//   Vitamin(
//     name: 'Vitamin C',
//     description: 'Powerful antioxidant for immune health and skin...',
//     imageUrl:
//         'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=600&h=400&fit=crop',
//     category: 'Vitamins',
//     fullDescription:
//         'Vitamin C is a powerful antioxidant that supports immune function, collagen production, and wound healing. It also helps your body absorb iron from plant-based foods.',
//     benefits: [
//       'Immune Support: Strengthens your body\'s natural defenses.',
//       'Skin Health: Essential for collagen synthesis and skin repair.',
//       'Antioxidant Protection: Protects cells from oxidative stress.',
//       'Iron Absorption: Enhances iron uptake from plant sources.',
//     ],
//     dosage: '75-90 mg daily for adults',
//     sources: [
//       'Citrus fruits (oranges, lemons, grapefruits)',
//       'Berries (strawberries, blueberries)',
//       'Bell peppers',
//       'Broccoli and Brussels sprouts',
//       'Tomatoes',
//     ],
//   ),
//   Vitamin(
//     name: 'Omega-3',
//     description: 'Essential fatty acids for heart and brain health...',
//     imageUrl:
//         'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=600&h=400&fit=crop',
//     category: 'Vitamins',
//     fullDescription:
//         'Omega-3 fatty acids are essential fats that support cardiovascular health, brain function, and reduce inflammation throughout the body.',
//     benefits: [
//       'Heart Health: Reduces risk of heart disease and lowers blood pressure.',
//       'Brain Function: Supports cognitive performance and memory.',
//       'Anti-inflammatory: Helps reduce chronic inflammation.',
//       'Joint Health: May reduce joint pain and stiffness.',
//     ],
//     dosage: '250-500 mg combined EPA and DHA daily',
//     sources: [
//       'Fatty fish (salmon, sardines, mackerel)',
//       'Fish oil supplements',
//       'Flaxseeds and chia seeds',
//       'Walnuts',
//       'Algae-based supplements',
//     ],
//   ),
//   Vitamin(
//     name: 'Magnesium',
//     description: 'Important mineral for muscle and nerve function...',
//     imageUrl:
//         'https://images.unsplash.com/photo-1628771065518-0d82f1938462?w=600&h=400&fit=crop',
//     category: 'Vitamins',
//     fullDescription:
//         'Magnesium is a vital mineral involved in over 300 biochemical reactions in your body, including muscle and nerve function, blood sugar control, and bone health.',
//     benefits: [
//       'Muscle Function: Prevents cramps and supports muscle relaxation.',
//       'Sleep Quality: Promotes better sleep and reduces insomnia.',
//       'Bone Health: Works with calcium for strong bones.',
//       'Energy Production: Essential for ATP synthesis.',
//     ],
//     dosage: '310-420 mg daily for adults',
//     sources: [
//       'Leafy green vegetables',
//       'Nuts and seeds',
//       'Whole grains',
//       'Legumes (beans, lentils)',
//       'Dark chocolate',
//     ],
//   ),
// ];

// // SCREEN 1: Guidance Center List
// class GuidanceCenterScreen extends StatefulWidget {
//   const GuidanceCenterScreen({Key? key}) : super(key: key);

//   @override
//   State<GuidanceCenterScreen> createState() => _GuidanceCenterScreenState();
// }

// class _GuidanceCenterScreenState extends State<GuidanceCenterScreen> {
//   int selectedTab = 1; // 1 for Articles & Tips, 0 for Vitamins
//   int _selectedIndex = 3;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A1A),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Header(
//               title: 'Guidness Center',
//               showBackButton: true,
//               onNotificationPressed: () {
//                 // Handle notification tap
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Notifications clicked')),
//                 );
//               },
//             ),

//             // Tab Buttons with callback to update selectedTab
//             TabsRow(
//               selected: selectedTab,
//               onTabChanged: (index) {
//                 setState(() {
//                   selectedTab = index;
//                 });
//               },
//               enableNavigation: false,
//             ),

//             const SizedBox(height: 16),

//             // Dynamic List based on selected tab
//             Expanded(
//               child: selectedTab == 0
//                   ? _buildVitaminsList()
//                   : _buildArticlesList(),
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

//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//   }

//   Widget _buildArticlesList() {
//     return BlocConsumer<guidanceCubit, Map<String, dynamic>>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         if (state['state'] == 'loading') {
//           print(
//             'lllllllllllllloooooooooooooooooooooooooooooooooooooaaaaaaaaaaaaaaaaaaaaaaadiiiiiiiiiiiiinnnnnnnng',
//           );
//           return CircularProgressIndicator();
//         }
//         if (state['state'] == 'error') {
//           return Text('Error....${state['data']['message']}');
//         }
//         print(
//           '================================================////===============================',
//         );
//         if (state['state'] == 'done') {
//           final articles = state['data']['articles'] as List<Article>?;

//           if (articles == null || articles.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No articles available',
//                 style: TextStyle(color: Colors.white),
//               ),
//             );
//           }
//           // if (state['state'] == 'done') {
//           return ListView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             itemCount: state['data']['totalArticles'],
//             itemBuilder: (context, index) {
//               return ArticleCard(article: articles[index]);
//             },
//           );
//           // }
//         }
//         return const Center(
//           child: Text('Unknown state', style: TextStyle(color: Colors.white)),
//         );
//       },
//     );
//   }

//   Widget _buildVitaminsList() {
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       itemCount: vitamins.length,
//       itemBuilder: (context, index) {
//         return VitaminCard(vitamin: vitamins[index]);
//       },
//     );
//   }
// }

// // Article Card Widget
// class ArticleCard extends StatelessWidget {
//   final Article article;

//   const ArticleCard({Key? key, required this.article}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ArticleDetailScreen(article: article),
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
//                       article.title,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       article.description,
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
//                 article.imageUrl,
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

// // Vitamin Card Widget
// class VitaminCard extends StatelessWidget {
//   final Vitamin vitamin;

//   const VitaminCard({Key? key, required this.vitamin}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => VitaminDetailScreen(vitamin: vitamin),
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
//                       vitamin.name,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       vitamin.description,
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
//                 vitamin.imageUrl,
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

// // ARTICLE DETAIL SCREEN - FIXED
// class ArticleDetailScreen extends StatefulWidget {
//   final dynamic article; // Use your Article model

//   const ArticleDetailScreen({Key? key, required this.article})
//     : super(key: key);

//   @override
//   State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
// }

// class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
//   int _selectedIndex = 3;
//   int selectedTab = 1; // Articles tab selected

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
//                       'Guidness Center',
//                       style: TextStyle(
//                         color: AppColors.secondry,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(
//                       Icons.notifications,
//                       color: AppColors.secondry,
//                     ),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),

//             // Tab Buttons with navigation enabled
//             TabsRow(
//               selected: selectedTab,
//               enableNavigation: true, // Enable navigation on tab change
//               onTabChanged: (index) {
//                 // When tab changes, pop back to main list
//                 // The main screen will handle showing correct content
//                 if (index != selectedTab) {
//                   Navigator.pop(context);
//                 }
//               },
//             ),

//             const SizedBox(height: 16),

//             // Content
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.article.title,
//                       style: const TextStyle(
//                         color: Colors.yellow,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     Container(
//                       decoration: BoxDecoration(
//                         color: AppColors.secondry,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       padding: const EdgeInsets.all(16),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.network(
//                           widget.article.imageUrl,
//                           width: double.infinity,
//                           height: 200,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Container(
//                               height: 200,
//                               color: Colors.grey[800],
//                               child: const Icon(Icons.broken_image, size: 50),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     Text(
//                       widget.article.fullDescription,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         height: 1.6,
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     ...widget.article.tips.map<Widget>((tip) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               tip.split(':')[0] + ':',
//                               style: const TextStyle(
//                                 color: AppColors.secondry,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               tip.split(':').length > 1
//                                   ? tip.split(':')[1].trim()
//                                   : tip,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 height: 1.6,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),

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
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }

//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//   }
// }

// // VITAMIN DETAIL SCREEN - FIXED
// class VitaminDetailScreen extends StatefulWidget {
//   final dynamic vitamin; // Use your Vitamin model

//   const VitaminDetailScreen({Key? key, required this.vitamin})
//     : super(key: key);

//   @override
//   State<VitaminDetailScreen> createState() => _VitaminDetailScreenState();
// }

// class _VitaminDetailScreenState extends State<VitaminDetailScreen> {
//   int _selectedIndex = 3;
//   int selectedTab = 0; // Vitamins tab selected

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
//                       'Guidness Center',
//                       style: TextStyle(
//                         color: AppColors.secondry,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(
//                       Icons.notifications,
//                       color: AppColors.secondry,
//                     ),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),

//             // Tab Buttons with navigation enabled
//             TabsRow(
//               selected: selectedTab,
//               enableNavigation: true, // Enable navigation on tab change
//               onTabChanged: (index) {
//                 // When tab changes, pop back to main list
//                 if (index != selectedTab) {
//                   Navigator.pop(context);
//                 }
//               },
//             ),

//             const SizedBox(height: 16),

//             // Content
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.vitamin.name,
//                       style: const TextStyle(
//                         color: Colors.yellow,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     Container(
//                       decoration: BoxDecoration(
//                         color: AppColors.secondry,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       padding: const EdgeInsets.all(16),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.network(
//                           widget.vitamin.imageUrl,
//                           width: double.infinity,
//                           height: 200,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Container(
//                               height: 200,
//                               color: Colors.grey[800],
//                               child: const Icon(Icons.broken_image, size: 50),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     Text(
//                       widget.vitamin.fullDescription,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         height: 1.6,
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     // Benefits Section
//                     const Text(
//                       'Key Benefits:',
//                       style: TextStyle(
//                         color: AppColors.secondry,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 12),

//                     ...widget.vitamin.benefits.map<Widget>((benefit) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               benefit.split(':')[0] + ':',
//                               style: const TextStyle(
//                                 color: AppColors.secondry,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               benefit.split(':').length > 1
//                                   ? benefit.split(':')[1].trim()
//                                   : benefit,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 height: 1.6,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),

//                     const SizedBox(height: 16),

//                     // Dosage Section
//                     const Text(
//                       'Recommended Dosage:',
//                       style: TextStyle(
//                         color: AppColors.secondry,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       widget.vitamin.dosage,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         height: 1.6,
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     // Sources Section
//                     const Text(
//                       'Food Sources:',
//                       style: TextStyle(
//                         color: AppColors.secondry,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 12),

//                     ...widget.vitamin.sources.map<Widget>((source) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 8),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               '• ',
//                               style: TextStyle(
//                                 color: AppColors.secondry,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 source,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 14,
//                                   height: 1.6,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),

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
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }

//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//   }
// }
