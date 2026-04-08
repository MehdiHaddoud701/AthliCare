import 'package:athlicare/data/models/users_model.dart';
import 'package:athlicare/data/models/workout_model.dart';
import 'package:athlicare/data/models/task_model.dart';
import 'package:athlicare/data/models/weekly_plan_model.dart';
import 'package:athlicare/data/models/day_scheduale_model.dart';
import 'package:athlicare/data/repositories/user_repo.dart';
import 'package:athlicare/data/repositories/workout_repo.dart';

class DummyDataHelper {
  final UserRepository userRepository;
  final WorkoutRepository workoutRepository;

  DummyDataHelper({
    required this.userRepository,
    required this.workoutRepository,
  });

  /// Insert dummy data if user doesn't exist
  /// Returns the user ID
  Future<int> initializeDummyData() async {
    try {
      print('\n🚀 Starting Dummy Data Initialization...');

      // Check if user already exists
      final existingUserByEmail = await userRepository.getUserByEmail(
        'madison@athlicare.com',
      );
      final existingUserByUsername = await userRepository.getUserByUsername(
        'madison_fit',
      );

      if (existingUserByEmail != null || existingUserByUsername != null) {
        final user = existingUserByEmail ?? existingUserByUsername;
        print('✅ Demo user already exists with ID: ${user!.userId}');
        return user.userId!;
      }

      // ==================== CREATE DEMO USER ====================
      final userId = await userRepository.insertUser(
        UserModel(
          username: 'madison_fit',
          email: 'madison@athlicare.com',
          hashedPassword: 'hashed_password_here',
          age: 25,
          gender: 'female',
          height: 165.0,
          weight: 60.0,
          sportType: 'fitness',
          activeDaysPerWeek: 4,
          firstSignInDate: DateTime.now().toIso8601String(),
        ),
      );

      if (userId == -1) {
        throw Exception('Failed to create demo user');
      }

      print('✅ Demo user created with ID: $userId');

      // ==================== CREATE SAMPLE WORKOUTS ====================
      // Create separate workout instances for each day to avoid task sharing
      // Each workout gets a unique image from the internet

      // Day 1 (Monday) - Squat + Full Body Stretching
      final workout1_day1 = WorkoutModel(
        title: 'Squat Exercise',
        description: 'Lower body workout - Squat focused',
        imagePath:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop', // Squat workout 1
      );

      final workout2_day1 = WorkoutModel(
        title: 'Full Body Stretching',
        description: 'Flexibility training - Full body',
        imagePath:
            'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop', // Yoga session 1
      );

      // Day 2 (Tuesday) - Full Body Stretching + Cardio Blast
      final workout2_day2 = WorkoutModel(
        title: 'Full Body Stretching',
        description: 'Flexibility training - Full body',
        imagePath:
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop', // Yoga session 2
      );

      final workout3_day2 = WorkoutModel(
        title: 'Cardio Blast',
        description: 'High intensity cardio workout',
        imagePath:
            'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400&h=300&fit=crop', // Cardio session 1
      );

      // Day 3 (Wednesday) - Squat + Cardio Blast
      final workout1_day3 = WorkoutModel(
        title: 'Squat Exercise',
        description: 'Lower body workout - Squat focused',
        imagePath:
            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400&h=300&fit=crop', // Squat workout 2
      );

      final workout3_day3 = WorkoutModel(
        title: 'Cardio Blast',
        description: 'High intensity cardio workout',
        imagePath:
            'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=400&h=300&fit=crop', // Cardio session 2
      );

      // Day 4 (Thursday) - Full Body Stretching
      final workout2_day4 = WorkoutModel(
        title: 'Full Body Stretching',
        description: 'Flexibility training - Full body',
        imagePath:
            'https://images.unsplash.com/photo-1594736797933-d0401ba2fe65?w=400&h=300&fit=crop', // Yoga session 3
      );

      // Insert all workout instances
      final workoutId1_day1 = await workoutRepository.insertWorkout(
        workout1_day1,
      );
      final workoutId2_day1 = await workoutRepository.insertWorkout(
        workout2_day1,
      );
      final workoutId2_day2 = await workoutRepository.insertWorkout(
        workout2_day2,
      );
      final workoutId3_day2 = await workoutRepository.insertWorkout(
        workout3_day2,
      );
      final workoutId1_day3 = await workoutRepository.insertWorkout(
        workout1_day3,
      );
      final workoutId3_day3 = await workoutRepository.insertWorkout(
        workout3_day3,
      );
      final workoutId2_day4 = await workoutRepository.insertWorkout(
        workout2_day4,
      );

      if (workoutId1_day1 == -1 ||
          workoutId2_day1 == -1 ||
          workoutId2_day2 == -1 ||
          workoutId3_day2 == -1 ||
          workoutId1_day3 == -1 ||
          workoutId3_day3 == -1 ||
          workoutId2_day4 == -1) {
        throw Exception('Failed to create workouts');
      }

      print('✅ Sample workouts created (separate instances for each day)');

      // ==================== CREATE TASKS FOR WORKOUTS ====================

      // Tasks for Squat Exercise (Day 1 and Day 3 versions) - Each task gets unique image
      final squatTasks_day1 = [
        TaskModel(
          workoutId: workoutId1_day1,
          title: 'Warm up squats',
          level: 'easy',
          durationSec: 3,
          roundNumber: 1,
          description: 'Light warm up',
          imagePath:
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop', // Warm-up specific
        ),
        TaskModel(
          workoutId: workoutId1_day1,
          title: 'Heavy squats',
          level: 'high',
          durationSec: 6,
          roundNumber: 1,
          description: 'Main lift - heavy weight',
          imagePath:
              'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400&h=300&fit=crop', // Heavy lifting specific
        ),
        TaskModel(
          workoutId: workoutId1_day1,
          title: 'Cool down',
          level: 'easy',
          durationSec: 12,
          roundNumber: 2,
          description: 'Recovery and cool down',
          imagePath:
              'https://images.unsplash.com/photo-1506629905607-d405315faa4b?w=400&h=300&fit=crop', // Recovery/stretching
        ),
      ];

      final squatTasks_day3 = [
        TaskModel(
          workoutId: workoutId1_day3,
          title: 'Warm up squats',
          level: 'easy',
          durationSec: 3,
          roundNumber: 1,
          description: 'Light warm up',
          imagePath:
              'https://images.unsplash.com/photo-1584464491033-06628f3a6b7b?w=400&h=300&fit=crop', // Different warm-up
        ),
        TaskModel(
          workoutId: workoutId1_day3,
          title: 'Heavy squats',
          level: 'high',
          durationSec: 6,
          roundNumber: 1,
          description: 'Main lift - heavy weight',
          imagePath:
              'https://images.unsplash.com/photo-1546483875-ad9014c88eba?w=400&h=300&fit=crop', // Different heavy lift
        ),
        TaskModel(
          workoutId: workoutId1_day3,
          title: 'Cool down',
          level: 'easy',
          durationSec: 12,
          roundNumber: 2,
          description: 'Recovery and cool down',
          imagePath:
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop', // Different recovery
        ),
      ];

      // Tasks for Full Body Stretching (Day 1, Day 2, and Day 4 versions) - Unique images for each
      final stretchTasks_day1 = [
        TaskModel(
          workoutId: workoutId2_day1,
          title: 'Full body stretch',
          level: 'moderate',
          durationSec: 9,
          roundNumber: 1,
          description: 'Complete flexibility routine',
          imagePath:
              'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop', // Yoga pose 1
        ),
      ];

      final stretchTasks_day2 = [
        TaskModel(
          workoutId: workoutId2_day2,
          title: 'Full body stretch',
          level: 'moderate',
          durationSec: 9,
          roundNumber: 1,
          description: 'Complete flexibility routine',
          imagePath:
              'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop', // Different yoga pose
        ),
      ];

      final stretchTasks_day4 = [
        TaskModel(
          workoutId: workoutId2_day4,
          title: 'Full body stretch',
          level: 'moderate',
          durationSec: 9,
          roundNumber: 1,
          description: 'Complete flexibility routine',
          imagePath:
              'https://images.unsplash.com/photo-1594736797933-d0401ba2fe65?w=400&h=300&fit=crop', // Another yoga pose
        ),
      ];

      // Tasks for Cardio Blast (Day 2 and Day 3 versions) - Unique images for each task
      final cardioTasks_day2 = [
        TaskModel(
          workoutId: workoutId3_day2,
          title: 'Running intervals',
          level: 'high',
          durationSec: 12,
          roundNumber: 1,
          description: 'High intensity intervals',
          imagePath:
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop', // Sprint intervals
        ),
        TaskModel(
          workoutId: workoutId3_day2,
          title: 'Recovery jog',
          level: 'moderate',
          durationSec: 3,
          roundNumber: 2,
          description: 'Cool down jog',
          imagePath:
              'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400&h=300&fit=crop', // Jogging recovery
        ),
      ];

      final cardioTasks_day3 = [
        TaskModel(
          workoutId: workoutId3_day3,
          title: 'Running intervals',
          level: 'high',
          durationSec: 12,
          roundNumber: 1,
          description: 'High intensity intervals',
          imagePath:
              'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=400&h=300&fit=crop', // Different sprint scene
        ),
        TaskModel(
          workoutId: workoutId3_day3,
          title: 'Recovery jog',
          level: 'moderate',
          durationSec: 3,
          roundNumber: 2,
          description: 'Cool down jog',
          imagePath:
              'https://images.unsplash.com/photo-1506629905607-d405315faa4b?w=400&h=300&fit=crop', // Different recovery jog
        ),
      ];

      // Insert all tasks
      final allTasks = [
        ...squatTasks_day1,
        ...squatTasks_day3,
        ...stretchTasks_day1,
        ...stretchTasks_day2,
        ...stretchTasks_day4,
        ...cardioTasks_day2,
        ...cardioTasks_day3,
      ];
      final taskSuccess = await workoutRepository.insertTasks(allTasks);

      if (!taskSuccess) {
        throw Exception('Failed to create tasks');
      }

      print('✅ Sample tasks created (Total: ${allTasks.length} tasks)');

      // ==================== CREATE WEEKLY PLAN ====================
      final weeklyPlanId = await workoutRepository.insertWeeklyPlan(
        WeeklyPlanModel(userId: userId, weekNumber: 1),
      );

      if (weeklyPlanId == -1) {
        throw Exception('Failed to create weekly plan');
      }

      print('✅ Weekly plan created (ID: $weeklyPlanId, Week: 1)');

      // ==================== CREATE DAYS AND ASSIGN WORKOUTS ====================
      // Each workout is a separate instance per day to avoid shared tasks
      // Only create days based on the user's activeDaysPerWeek setting
      const activeDaysPerWeek = 4; // This should match the user's activeDaysPerWeek
      
      final allDayConfigs = [
        {
          'dayIndex': 1,
          'name': 'Monday',
          'workoutIds': [workoutId1_day1, workoutId2_day1],
        },
        {
          'dayIndex': 2,
          'name': 'Tuesday',
          'workoutIds': [workoutId2_day2, workoutId3_day2],
        },
        {
          'dayIndex': 3,
          'name': 'Wednesday',
          'workoutIds': [workoutId1_day3, workoutId3_day3],
        },
        {
          'dayIndex': 4,
          'name': 'Thursday',
          'workoutIds': [workoutId2_day4],
        },
      ];

      // Limit to user's active days per week
      final dayConfigs = allDayConfigs.take(activeDaysPerWeek).toList();

      for (var dayConfig in dayConfigs) {
        final dayId = await workoutRepository.insertDaySchedule(
          DayScheduleModel(
            weeklyPlanId: weeklyPlanId,
            dayIndex: dayConfig['dayIndex'] as int,
          ),
        );

        if (dayId == -1) {
          throw Exception('Failed to create day schedule');
        }

        // Assign workouts to this day
        for (var workoutId in dayConfig['workoutIds'] as List<int>) {
          await workoutRepository.assignWorkoutToDay(dayId, workoutId);
        }

        print(
          '   ✅ Day ${dayConfig['dayIndex']} (${dayConfig['name']}) created with ${(dayConfig['workoutIds'] as List<int>).length} workouts',
        );
      }

      print('\n╔════════════════════════════════════════════════════════╗');
      print('║   DUMMY DATA INITIALIZATION COMPLETE!               ║');
      print('╚════════════════════════════════════════════════════════╝');
      print(' Summary:');
      print('   • User ID: $userId');
      print('   • Weekly Plan ID: $weeklyPlanId');
      print('   • Workouts Created: 3');
      print('   • Tasks Created: ${allTasks.length}');
      print('   • Days with Workouts: 4');
      print('   • Day 1 has 2 workouts for home page display ');
      print('\n');

      return userId;
    } catch (e) {
      print('❌ Dummy data initialization error: $e');
      rethrow;
    }
  }
}
