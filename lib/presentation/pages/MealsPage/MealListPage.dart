import 'package:athlicare/core/constants/colors.dart';
import 'package:athlicare/l10n/app_localizations.dart';
import 'package:athlicare/presentation/pages/MealsPage/MealDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MealListPage extends StatefulWidget {
  const MealListPage({super.key});

  @override
  State<MealListPage> createState() => _MealListPageState();
}

class _MealListPageState extends State<MealListPage> {
  final Color backgroundColor = const Color(0xFF0E0E0E);
  final Color accentColor = const Color(0xFFFF1E00);

  final List<Map<String, dynamic>> allMeals = [
    {
      'title': 'Greek Yogurt Delight',
      'kcal': '420 Kcal',
      'image': 'assets/images/yogurt.jpg',
      'type': 'Breakfast',
      'ingredients': [
        '1 cup Greek yogurt',
        '½ cup mixed berries',
        '1 tbsp honey',
        '2 tbsp granola',
      ],
    },
    {
      'title': 'Spinach & Tomato Omelette',
      'kcal': '330 Kcal',
      'image': 'assets/images/yogurt.jpg',
      'type': 'Breakfast',
      'ingredients': [
        '3 eggs',
        '½ cup spinach',
        '¼ cup cherry tomatoes',
        'Salt and pepper to taste',
      ],
    },
    {
      'title': 'Avocado & Egg Toast',
      'kcal': '380 Kcal',
      'image': 'assets/images/yogurt.jpg',
      'type': 'Pre-Training',
      'ingredients': [
        '2 slices whole-grain bread',
        '1 ripe avocado',
        '2 poached eggs',
        'Chili flakes and olive oil',
      ],
    },
    {
      'title': 'Protein Shake with Fruits',
      'kcal': '290 Kcal',
      'image': 'assets/images/yogurt.jpg',
      'type': 'Pre-Training',
      'ingredients': [
        '1 scoop protein powder',
        '1 banana',
        '1 cup almond milk',
        '½ cup frozen berries',
      ],
    },
    {
      'title': 'Grilled Salmon with Veggies',
      'kcal': '450 Kcal',
      'image': 'assets/images/yogurt.jpg',
      'type': 'Dinner',
      'ingredients': [
        '150g salmon',
        '1 cup broccoli',
        '1 carrot',
        'Olive oil, salt, pepper',
      ],
    },
  ];

  late String selectedCategory;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    selectedCategory = l10n.breakfast; // default selected
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Map meal types to localized strings
    String getLocalizedType(String type) {
      switch (type) {
        case 'Breakfast':
          return l10n.breakfast;
        case 'Pre-Training':
          return l10n.preTraining;
        case 'Dinner':
          return l10n.dinner;
        default:
          return type;
      }
    }

    final filteredMeals = allMeals
        .where((meal) => getLocalizedType(meal['type']) == selectedCategory)
        .toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.mealsPlan,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CATEGORY BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryButton(l10n.breakfast),
                _buildCategoryButton(l10n.preTraining),
                _buildCategoryButton(l10n.dinner),
              ],
            ),
            const SizedBox(height: 20),

            // MEAL CARDS LIST
            Expanded(
              child: filteredMeals.isEmpty
                  ? Center(
                child: Text(
                  l10n.noMealsInCategory,
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              )
                  : ListView.builder(
                itemCount: filteredMeals.length,
                itemBuilder: (context, index) {
                  final meal = filteredMeals[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MealDetailPage(
                            title: meal['title']!,
                            kcal: meal['kcal']!,
                            image: meal['image']!,
                            ingredients: List<String>.from(
                                meal['ingredients']),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 100,
                      child: Row(
                        children: [
                          // TEXT INFO
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    meal['title']!,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    meal['kcal']!,
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey[700],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // IMAGE
                          Expanded(
                            flex: 4,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              child: meal['image']
                                  .toString()
                                  .startsWith('http')
                                  ? Image.network(
                                meal['image']!,
                                fit: BoxFit.cover,
                                height: double.infinity,
                              )
                                  : Image.asset(
                                meal['image']!,
                                fit: BoxFit.cover,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String text) {
    final bool isSelected = text == selectedCategory;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedCategory = text),
        child: Container(
          height: 38,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? accentColor : Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
