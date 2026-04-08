import 'package:flutter/material.dart';

Widget buildProgressBanner() {
  return Container(
    width: double.infinity,
    height: 200,
    padding: const EdgeInsets.all(24),
    decoration: const BoxDecoration(color: Color(0xFFFF6B35)),
    child: Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),

        child: Container(
          constraints: const BoxConstraints(maxWidth: 360, maxHeight: 150),
          child: Stack(
            children: [
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  height: 150,
                  // width: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 15, 12, 11).withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  // margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Track Your',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Progress !',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Image positioned at bottom-right with rounded edges
              Positioned(
                bottom: 0,
                right: 0,
                top: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), //  clip corners
                  child: Image.network(
                    'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
                    // height: 150,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
