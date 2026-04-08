import 'package:athlicare/core/constants/colors.dart';
import 'package:athlicare/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MealDetailPage extends StatelessWidget {
  final String title;
  final String kcal;
  final String image;
  final List<String> ingredients;

  const MealDetailPage({
    super.key,
    required this.title,
    required this.kcal,
    required this.image,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Color backgroundColor = const Color(0xFF0E0E0E);
    final Color accentColor = const Color(0xFFFF1E00);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.meals,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Meal Image
            Hero(
              tag: title,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 220,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🍳 Meal title and kcal
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              kcal,
              style: GoogleFonts.poppins(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            // 🧂 Ingredients section
            Text(
              l10n.ingredients,
              style: GoogleFonts.poppins(
                color: accentColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ingredients
                  .map(
                    (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    "• $item",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
