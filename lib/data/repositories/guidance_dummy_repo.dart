// 📁 lib/data/repositories/guidance_repo.dart
import '../models/article_model.dart';
import '../models/vitamin_model.dart';

class GuidanceRepository {
  final List<Article> _articles = [
    Article(
      articleId: 1,
      title: 'Strength Training Tips',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
      imageUrl:
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&h=400&fit=crop',
      category: 'Articles & Tips',
      fullDescription:
          'Discover essential Strength Training Tips to maximize your workouts and achieve your fitness goals efficiently. Learn how to optimize your routine, prevent injuries, and unlock your full potential in the gym.',
      tips: [
        'Plan Your Routine: Before starting any workout, plan your routine for the week. Focus on different muscle groups on different days to allow for adequate rest and recovery.',
        'Warm-Up: Begin your workout with a proper warm-up session. This could include light cardio exercises like jogging or jumping jacks, as well as dynamic stretches to prepare your muscles for the upcoming workout.',
        'Progressive Overload: Gradually increase the weight you lift to continue building strength and muscle.',
        'Rest Days: Allow your muscles time to recover between workouts.',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Article(
      articleId: 2,
      title: 'Healthy Weight Loss',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
      imageUrl:
          'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=600&h=400&fit=crop',
      category: 'Articles & Tips',
      fullDescription:
          'Learn effective strategies for healthy and sustainable weight loss through proper nutrition and exercise.',
      tips: [
        'Balanced Diet: Focus on whole foods, lean proteins, and plenty of vegetables.',
        'Portion Control: Use smaller plates and be mindful of serving sizes.',
        'Stay Hydrated: Drink plenty of water throughout the day.',
        'Regular Exercise: Combine cardio and strength training for best results.',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Article(
      articleId: 3,
      title: 'Unlock Your Gym Potential',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
      imageUrl:
          'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=600&h=400&fit=crop',
      category: 'Articles & Tips',
      fullDescription:
          'Maximize your gym performance with these expert tips and techniques for better results.',
      tips: [
        'Set Clear Goals: Define specific, measurable fitness goals.',
        'Track Progress: Keep a workout journal to monitor improvements.',
        'Rest Days: Allow your body time to recover and rebuild.',
        'Find a Buddy: Working out with a partner keeps you motivated.',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Article(
      articleId: 4,
      title: 'From Beginner To Buff',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
      imageUrl:
          'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=600&h=400&fit=crop',
      category: 'Articles & Tips',
      fullDescription:
          'A complete guide for beginners to build muscle and strength progressively.',
      tips: [
        'Start Light: Begin with lighter weights to perfect your form.',
        'Progressive Overload: Gradually increase weight and intensity.',
        'Consistency: Stick to your routine for long-term results.',
        'Nutrition: Eat enough protein to support muscle growth.',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Article(
      articleId: 5,
      title: 'Strategies For Gym Success',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
      imageUrl:
          'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=600&h=400&fit=crop',
      category: 'Articles & Tips',
      fullDescription:
          'Proven strategies to achieve success in your fitness journey.',
      tips: [
        'Find a Workout Partner: Stay motivated with a gym buddy.',
        'Vary Your Routine: Prevent plateaus by changing exercises.',
        'Celebrate Milestones: Acknowledge your progress along the way.',
        'Stay Positive: Maintain a positive mindset throughout your journey.',
      ],
      createdAt: DateTime.now(),
    ),
  ];

  final List<VitaminModel> _vitamins = [
    VitaminModel(
      vitaminId: 1,
      name: 'Vitamin D',
      description: 'Essential for bone health and immune function...',
      imageUrl:
          'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&h=400&fit=crop',
      category: 'Vitamins',
      fullDescription:
          'Vitamin D is crucial for maintaining strong bones, supporting immune function, and regulating mood. It helps your body absorb calcium and phosphorus effectively.',
      benefits: [
        'Bone Health: Promotes calcium absorption and maintains bone density.',
        'Immune Support: Enhances your immune system\'s ability to fight infections.',
        'Mood Regulation: May help reduce symptoms of depression and anxiety.',
        'Muscle Function: Supports muscle strength and reduces risk of falls.',
      ],
      dosage: '600-800 IU daily for adults',
      sources: [
        'Sunlight exposure (10-15 minutes daily)',
        'Fatty fish (salmon, mackerel, tuna)',
        'Fortified milk and dairy products',
        'Egg yolks',
        'Mushrooms',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    VitaminModel(
      vitaminId: 2,
      name: 'Vitamin B12',
      description: 'Vital for energy production and nervous system health...',
      imageUrl:
          'https://images.unsplash.com/photo-1505576399279-565b52d4ac71?w=600&h=400&fit=crop',
      category: 'Vitamins',
      fullDescription:
          'Vitamin B12 plays a critical role in red blood cell formation, nerve function, and DNA synthesis. It\'s essential for energy metabolism and brain health.',
      benefits: [
        'Energy Production: Helps convert food into usable energy.',
        'Brain Health: Supports cognitive function and memory.',
        'Red Blood Cell Formation: Prevents anemia and fatigue.',
        'Nervous System: Maintains healthy nerve cells and myelin.',
      ],
      dosage: '2.4 mcg daily for adults',
      sources: [
        'Meat (beef, pork, lamb)',
        'Fish and shellfish',
        'Eggs and dairy products',
        'Fortified cereals',
        'Nutritional yeast',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    VitaminModel(
      vitaminId: 3,
      name: 'Vitamin C',
      description: 'Powerful antioxidant for immune health and skin...',
      imageUrl:
          'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=600&h=400&fit=crop',
      category: 'Vitamins',
      fullDescription:
          'Vitamin C is a powerful antioxidant that supports immune function, collagen production, and wound healing. It also helps your body absorb iron from plant-based foods.',
      benefits: [
        'Immune Support: Strengthens your body\'s natural defenses.',
        'Skin Health: Essential for collagen synthesis and skin repair.',
        'Antioxidant Protection: Protects cells from oxidative stress.',
        'Iron Absorption: Enhances iron uptake from plant sources.',
      ],
      dosage: '75-90 mg daily for adults',
      sources: [
        'Citrus fruits (oranges, lemons, grapefruits)',
        'Berries (strawberries, blueberries)',
        'Bell peppers',
        'Broccoli and Brussels sprouts',
        'Tomatoes',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
    VitaminModel(
      vitaminId: 4,
      name: 'Omega-3',
      description: 'Essential fatty acids for heart and brain health...',
      imageUrl:
          'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=600&h=400&fit=crop',
      category: 'Vitamins',
      fullDescription:
          'Omega-3 fatty acids are essential fats that support cardiovascular health, brain function, and reduce inflammation throughout the body.',
      benefits: [
        'Heart Health: Reduces risk of heart disease and lowers blood pressure.',
        'Brain Function: Supports cognitive performance and memory.',
        'Anti-inflammatory: Helps reduce chronic inflammation.',
        'Joint Health: May reduce joint pain and stiffness.',
      ],
      dosage: '250-500 mg combined EPA and DHA daily',
      sources: [
        'Fatty fish (salmon, sardines, mackerel)',
        'Fish oil supplements',
        'Flaxseeds and chia seeds',
        'Walnuts',
        'Algae-based supplements',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    VitaminModel(
      vitaminId: 5,
      name: 'Magnesium',
      description: 'Important mineral for muscle and nerve function...',
      imageUrl:
          'https://images.unsplash.com/photo-1628771065518-0d82f1938462?w=600&h=400&fit=crop',
      category: 'Vitamins',
      fullDescription:
          'Magnesium is a vital mineral involved in over 300 biochemical reactions in your body, including muscle and nerve function, blood sugar control, and bone health.',
      benefits: [
        'Muscle Function: Prevents cramps and supports muscle relaxation.',
        'Sleep Quality: Promotes better sleep and reduces insomnia.',
        'Bone Health: Works with calcium for strong bones.',
        'Energy Production: Essential for ATP synthesis.',
      ],
      dosage: '310-420 mg daily for adults',
      sources: [
        'Leafy green vegetables',
        'Nuts and seeds',
        'Whole grains',
        'Legumes (beans, lentils)',
        'Dark chocolate',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  Future<List<Article>> getAllArticles() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate API call
    return _articles;
  }

  /// Get article by ID
  Future<Article?> getArticleById(int articleId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _articles.firstWhere((article) => article.articleId == articleId);
    } catch (e) {
      return null;
    }
  }

  /// Search articles by title
  Future<List<Article>> searchArticles(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _articles
        .where(
          (article) =>
              article.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  /// Get recent articles
  Future<List<Article>> getRecentArticles({int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _articles.take(limit).toList();
  }

  // ==================== VITAMINS METHODS ====================

  /// Get all vitamins
  Future<List<VitaminModel>> getAllVitamins() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _vitamins;
  }

  /// Get vitamin by ID
  Future<VitaminModel?> getVitaminById(int vitaminId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _vitamins.firstWhere((vitamin) => vitamin.vitaminId == vitaminId);
    } catch (e) {
      return null;
    }
  }

  /// Search vitamins by name
  Future<List<VitaminModel>> searchVitamins(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _vitamins
        .where(
          (vitamin) => vitamin.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  /// Get recent vitamins
  Future<List<VitaminModel>> getRecentVitamins({int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _vitamins.take(limit).toList();
  }

  // ==================== COMBINED METHODS ====================

  /// Get all guidance content (articles + vitamins) - ✅ NOW RETURNS MAPS
  Future<Map<String, dynamic>> getAllGuidance() async {
    final articles = await getAllArticles();
    final vitamins = await getAllVitamins();

    return {
      'articles': articles.map((article) => article.toMap()).toList(),
      'vitamins': vitamins.map((vitamin) => vitamin.toMap()).toList(),
      'totalArticles': articles.length,
      'totalVitamins': vitamins.length,
    };
  }

  /// Search in both articles and vitamins
  Future<Map<String, dynamic>> searchGuidance(String query) async {
    final articles = await searchArticles(query);
    final vitamins = await searchVitamins(query);

    return {
      'articles': articles.map((article) => article.toMap()).toList(),
      'vitamins': vitamins.map((vitamin) => vitamin.toMap()).toList(),
      'results': articles.length + vitamins.length,
    };
  }
}
