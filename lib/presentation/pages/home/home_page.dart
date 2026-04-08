import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlicare/presentation/pages/home/widgets/card.dart';
import 'package:athlicare/presentation/pages/home/widgets/buildHeader.dart';
import 'package:athlicare/presentation/pages/home/widgets/buildSectionHeader.dart';
import 'package:athlicare/presentation/pages/home/widgets/buildProgreeBanner.dart';
import 'package:athlicare/presentation/pages/home/widgets/guidness.dart';
import '../../../l10n/app_localizations.dart';
// import 'package:athlicare/presentation/pages/tips/guidnesscenter.dart';
import 'package:athlicare/presentation/widgets/CustomBottomNavBar.dart';
// import 'package:athlicare/core/constants/colors.dart';
import 'package:athlicare/presentation/pages/injuries/injury_page.dart';
import 'package:athlicare/presentation/widgets/tipscard.dart';
import 'package:athlicare/presentation/pages/workout/weekly.dart';
import 'package:athlicare/presentation/pages/progressTracking/weekProgressTracking.dart';
import 'package:athlicare/presentation/pages/MealsPage/MealListPage.dart';
import 'package:athlicare/logic/workout_cubit.dart';
import 'package:athlicare/data/models/workout_state.dart';
import 'package:athlicare/logic/guidance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlicare/presentation/pages/home/widgets/card.dart';
import 'package:athlicare/presentation/pages/home/widgets/buildHeader.dart';
import 'package:athlicare/presentation/pages/home/widgets/buildSectionHeader.dart';
import 'package:athlicare/presentation/pages/home/widgets/buildProgreeBanner.dart';
import 'package:athlicare/presentation/pages/home/widgets/guidness.dart';
import 'package:athlicare/presentation/widgets/CustomBottomNavBar.dart';
import 'package:athlicare/presentation/pages/injuries/injury_page.dart';
import 'package:athlicare/presentation/widgets/tipscard.dart';
import 'package:athlicare/presentation/pages/workout/weekly.dart';
import 'package:athlicare/presentation/pages/progressTracking/weekProgressTracking.dart';
import 'package:athlicare/presentation/pages/MealsPage/MealListPage.dart';
import 'package:athlicare/logic/workout_cubit.dart';
import 'package:athlicare/data/models/workout_state.dart';
import 'package:athlicare/logic/guidance_cubit.dart';
import 'package:athlicare/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FitnessHomePage extends StatefulWidget {
  const FitnessHomePage({Key? key}) : super(key: key);

  @override
  State<FitnessHomePage> createState() => _FitnessHomePageState();
}

class _FitnessHomePageState extends State<FitnessHomePage> {
  int selectedDayIndex = 0;
  String? name;
  @override
  void initState() {
    super.initState();
    _loadWeeklyPlan();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    print(
      'shaaaaaarede preferencessssss: ----------///-----///0--------00000000000000000000000000000000 ${prefs.getString("username")}',
    );
    setState(() {
      name = prefs.getString("username");
    });
  }

  void _loadWeeklyPlan() {
    final workoutCubit = context.read<WorkoutCubit>();
    workoutCubit.loadCurrentWeeklyPlan(1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(context, userName: name ?? ' ,,,'),
                const SizedBox(height: 20),
                _buildSectionSelector(l10n),
                const SizedBox(height: 24),
                buildSectionHeader(
                  title: l10n.exercisesThisWeek,
                  action: l10n.seeMore,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const WeeklyWorkoutPage(userId: 1),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const WeeklyWorkoutPage(userId: 1),
                      ),
                    );
                  },
                  child: _buildExerciseCards(l10n),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProgressTrackingPage(),
                      ),
                    );
                  },
                  child: buildProgressBanner(),
                ),
                const SizedBox(height: 24),
                buildSectionHeader(
                  title: l10n.guidanceCenter,
                  action: l10n.seeMore,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: context.read<GuidanceCubit>(),
                          child: const tipspage(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildGuidanceCards(l10n),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0,
        onItemTapped: (int p1) {},
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 40, width: 1, color: Colors.grey[700]);
  }

  Widget _buildSectionSelector(AppLocalizations l10n) {
    final List<Map<String, dynamic>> iconItems = [
      {
        'name': l10n.workoutPlan,
        'icon': Icons.fitness_center,
        'page': const WeeklyWorkoutPage(userId: 1),
      },
      {
        'name': l10n.progress,
        'icon': Icons.show_chart,
        'page': const ProgressTrackingPage(),
      },
      {
        'name': l10n.nutrition,
        'icon': Icons.local_dining,
        'page': const MealListPage(),
      },
      {
        'name': l10n.injuries,
        'icon': Icons.health_and_safety,
        'page': const InjuryRecoveryPage(userId: 1),
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(iconItems.length * 2 - 1, (index) {
        if (index.isOdd) {
          return _buildVerticalDivider();
        }

        final actualIndex = index ~/ 2;
        final week = actualIndex + 1;
        final item = iconItems[actualIndex];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => item['page']),
            );
            setState(() {
              selectedDayIndex = week;
            });
          },
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 50,
                height: 50,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Icon(
                  item['icon'],
                  color: selectedDayIndex == 1
                      ? const Color(0xFFFF6B35)
                      : Colors.grey[600],
                  size: 32,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item['name'],
                style: TextStyle(
                  fontSize: 12,
                  color: selectedDayIndex == 1
                      ? Colors.white
                      : Colors.grey[400],
                  fontWeight: selectedDayIndex == 1
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildExerciseCards(AppLocalizations l10n) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<WorkoutCubit, WorkoutState>(
      builder: (context, state) {
        if (state is WorkoutLoading) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: const Color(0xFFFF6B35)),
            ),
          );
        }

        if (state is WorkoutError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '${l10n.error}: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (state is WeeklyPlanLoaded) {
          final weeklyPlan = state.weeklyPlan;
          final days = weeklyPlan.days ?? [];

          if (days.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  l10n.noData,
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
            );
          }

          final selectedDay = days.first;
          final workouts = selectedDay.workouts ?? [];

          if (workouts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  l10n.restday,
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
            );
          }

          Map<String, int> calculateStats(workout) {
            final tasks = workout.tasks ?? [];
            if (tasks.isEmpty) {
              return {'duration': 0, 'calories': 0};
            }

            int totalSeconds = tasks.length * 120;
            final durationMinutes = totalSeconds ~/ 60;
            final calories = (totalSeconds / 60 * 5).round();

            return {'duration': durationMinutes, 'calories': calories};
          }

          if (workouts.length == 1) {
            final stats = calculateStats(workouts[0]);
            return Center(
              child: ExerciseCard(
                imageUrl:
                    workouts[0].imagePath ??
                    'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=400&h=300&fit=crop',
                time: '${stats['duration']} ${l10n.minutes}/day',
                calories: '${stats['calories']} ${l10n.calories}',
                exerciseName: workouts[0].title ?? 'Workout',
                screenWidth: screenWidth * 0.45,
              ),
            );
          }

          final stats1 = calculateStats(workouts[0]);
          final stats2 = calculateStats(workouts[1]);

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ExerciseCard(
                  imageUrl:
                      workouts[0].imagePath ??
                      'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=400&h=300&fit=crop',
                  time: '${stats1['duration']} ${l10n.minutes}/day',
                  calories: '${stats1['calories']} ${l10n.calories}',
                  exerciseName: workouts[0].title ?? 'Workout 1',
                  screenWidth: MediaQuery.of(context).size.width,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ExerciseCard(
                  imageUrl:
                      workouts[1].imagePath ??
                      'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop',
                  time: '${stats2['duration']} ${l10n.minutes}/day',
                  calories: '${stats2['calories']} ${l10n.calories}',
                  exerciseName: workouts[1].title ?? 'Workout 2',
                  screenWidth: MediaQuery.of(context).size.width,
                ),
              ),
            ],
          );
        }

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(l10n.noData, style: TextStyle(color: Colors.grey[400])),
          ),
        );
      },
    );
  }

  Widget _buildGuidanceCards(AppLocalizations l10n) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<GuidanceCubit, Map<String, dynamic>>(
      builder: (context, state) {
        final status = state['state'] ?? 'loading';

        if (status == 'loading') {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: const Color(0xFFFF6B35)),
            ),
          );
        }

        if (status == 'error') {
          return Center(
            child: Text(l10n.error, style: TextStyle(color: Colors.grey[400])),
          );
        }

        if (status == 'done') {
          final data = state['data'] as Map<String, dynamic>? ?? {};
          final articles =
              (data['articles'] as List?)
                  ?.cast<Map<String, dynamic>>()
                  .take(2)
                  .toList() ??
              [];

          if (articles.isEmpty) {
            return Center(
              child: Text(
                l10n.noData,
                style: TextStyle(color: Colors.grey[400]),
              ),
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: articles.map((article) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ArticleDetailScreen(articleData: article),
                    ),
                  );
                },
                child: Container(
                  width: screenWidth / 2 - 20,
                  margin: const EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 170,
                        width: screenWidth / 2 - 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[900],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                article['imageUrl'] ??
                                    'https://via.placeholder.com/400x300',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[800],
                                    child: const Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          article['title'] ?? 'Article',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
