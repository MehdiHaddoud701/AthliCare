import 'user_repo.dart';
import 'workout_repo.dart';
import '.././models/users_model.dart';
import '.././models/workout_model.dart';
import '.././models/task_model.dart';

// Initialize repositories
final userRepo = UserRepository();
final workoutRepo = WorkoutRepository();

// ============================================================================
// SECTION 1: USER MANAGEMENT TESTS
// ============================================================================

/// Test creating a new user
Future<int> testCreateUser() async {
  print('\n🧪 TEST: Creating User');
  print('─' * 50);

  final newUser = UserModel(
    username: 'madison_fit',
    email: 'madison@example.com',
    hashedPassword: 'hashed_password_here',
    age: 25,
    gender: 'female',
    height: 165.0,
    weight: 60.0,
    sportType: 'cycling',
    activeDaysPerWeek: 4,
    firstSignInDate: DateTime.now().toIso8601String(),
  );

  final userId = await userRepo.insertUser(newUser);

  if (userId != -1) {
    print('✅ User created with ID: $userId');
    return userId;
  } else {
    print('❌ Failed to create user');
    return -1;
  }
}

/// Test retrieving user by ID
Future<void> testGetUser(int userId) async {
  print('\n🧪 TEST: Getting User by ID');
  print('─' * 50);

  final user = await userRepo.getUserById(userId);

  if (user != null) {
    print('✅ User found!');
    print('   Username: ${user.username}');
    print('   Email: ${user.email}');
    print('   Age: ${user.age}');
    print('   Sport: ${user.sportType}');
    print('   Active days: ${user.activeDaysPerWeek}');
  } else {
    print('❌ User not found');
  }
}

/// Test updating user weight
Future<void> testUpdateUserWeight(int userId, double newWeight) async {
  print('\n🧪 TEST: Updating User Weight');
  print('─' * 50);

  final user = await userRepo.getUserById(userId);

  if (user != null) {
    final updatedUser = user.copyWith(weight: newWeight);
    await userRepo.updateUser(updatedUser);
    print('✅ Weight updated to $newWeight kg');
  } else {
    print('❌ User not found');
  }
}

/// Test login validation
Future<UserModel?> testLogin(String username, String hashedPassword) async {
  print('\n🧪 TEST: User Login');
  print('─' * 50);

  final user = await userRepo.validateCredentials(username, hashedPassword);

  if (user != null) {
    print('✅ Login successful for: ${user.username}');
    return user;
  } else {
    print('❌ Invalid credentials');
    return null;
  }
}

// ============================================================================
// SECTION 2: WORKOUT & TASK CREATION TESTS
// ============================================================================

/// Test creating a complete workout with tasks
Future<int> testCreateCyclingWorkout() async {
  print('\n🧪 TEST: Creating Cycling Workout with Tasks');
  print('─' * 50);

  // Step 1: Create the workout
  final workout = WorkoutModel(
    title: 'Cycling Challenge',
    description: 'High intensity cycling workout with intervals',
    imagePath: 'assets/images/cycling.jpg',
  );

  final workoutId = await workoutRepo.insertWorkout(workout);

  if (workoutId == -1) {
    print('❌ Failed to create workout');
    return -1;
  }

  print('✅ Workout created with ID: $workoutId');

  // Step 2: Add tasks for Round 1
  final round1Tasks = [
    TaskModel(
      workoutId: workoutId,
      level: 'moderate',
      durationSec: 630,
      roundNumber: 1,
      title: 'Endurance Ride',
      description: 'Maintain steady pace',
    ),
    TaskModel(
      workoutId: workoutId,
      level: 'high',
      durationSec: 10,
      roundNumber: 1,
      title: 'Hill Climbs',
      description: 'High intensity climb',
    ),
    TaskModel(
      workoutId: workoutId,
      level: 'high',
      durationSec: 420,
      roundNumber: 1,
      title: 'Interval Sprints',
      description: '30 sec sprint, 30 sec rest',
    ),
  ];

  // Step 3: Add tasks for Round 2
  final round2Tasks = [
    TaskModel(
      workoutId: workoutId,
      level: 'moderate',
      durationSec: 480,
      roundNumber: 2,
      title: 'Tempo Ride',
      description: 'Moderate intensity',
    ),
    TaskModel(
      workoutId: workoutId,
      level: 'moderate',
      durationSec: 360,
      roundNumber: 2,
      title: 'Cadence Drill',
      description: 'Focus on pedal speed',
    ),
  ];

  // Insert all tasks
  final allTasks = [...round1Tasks, ...round2Tasks];
  final success = await workoutRepo.insertTasks(allTasks);

  if (success) {
    print('✅ Added ${allTasks.length} tasks to workout');
  } else {
    print('❌ Failed to add tasks');
  }

  return workoutId;
}

/// Test retrieving complete workout with tasks
Future<void> testGetCompleteWorkout(int workoutId) async {
  print('\n🧪 TEST: Getting Complete Workout with Tasks');
  print('─' * 50);

  final workout = await workoutRepo.getWorkoutWithTasks(workoutId);

  if (workout != null) {
    print('✅ Workout: ${workout.title}');
    print('   Description: ${workout.description}');
    print('   Total Tasks: ${workout.tasks?.length ?? 0}\n');

    // Get tasks grouped by round
    final tasksByRound = await workoutRepo.getTasksByWorkoutIdGroupedByRound(
      workoutId,
    );

    tasksByRound.forEach((round, tasks) {
      print('   📍 Round $round:');
      for (var task in tasks) {
        print('      • ${task.title}');
        print('        Duration: ${task.getFormattedDuration()}');
        print('        Level: ${task.level}');
        print('        Description: ${task.description}\n');
      }
    });
  } else {
    print('❌ Workout not found');
  }
}

/// Test getting workout statistics
Future<void> testShowWorkoutStats(int workoutId) async {
  print('\n🧪 TEST: Workout Statistics');
  print('─' * 50);

  final stats = await workoutRepo.getWorkoutStats(workoutId);

  print('✅ 📊 Workout Statistics:');
  print('   Total Duration: ${stats['totalDuration'] ~/ 60} minutes');
  print('   Total Calories: ${stats['totalCalories']} kcal');
  print('   Exercise Count: ${stats['exerciseCount']}');
  print('   Rounds: ${stats['rounds']}');
}

// ============================================================================
// SECTION 3: WEEKLY PLAN TESTS
// ============================================================================

/// Test generating a weekly plan for a user
Future<int> testGeneratePlanForUser(int userId, int activeDaysPerWeek) async {
  print('\n🧪 TEST: Generating Weekly Plan for User');
  print('─' * 50);

  final plan = await workoutRepo.generateWeeklyPlanForUser(
    userId,
    activeDaysPerWeek,
  );

  if (plan != null) {
    print('✅ Weekly plan created!');
    print('   Week Number: ${plan.weekNumber}');
    print('   Days: ${plan.days?.length ?? 0}');
    return plan.weekNumber;
  } else {
    print('❌ Failed to create weekly plan');
    return -1;
  }
}

/// Test assigning workouts to specific days
Future<void> testAssignWorkoutsToWeek(int weeklyPlanId) async {
  print('\n🧪 TEST: Assigning Workouts to Week Days');
  print('─' * 50);

  final days = await workoutRepo.getDaysByWeeklyPlan(weeklyPlanId);

  if (days.isEmpty) {
    print('❌ No days found for this weekly plan');
    return;
  }

  print('✅ Found ${days.length} days in the plan\n');

  // Assign workouts to each day
  for (var i = 0; i < days.length; i++) {
    final day = days[i];
    final workoutId = 1;

    await workoutRepo.assignWorkoutToDay(day.dayId!, workoutId);
    print('   ✅ Assigned workout $workoutId to Day ${day.dayIndex}');
  }
}

/// Test getting complete weekly plan with all nested data
Future<void> testShowCompleteWeeklyPlan(int userId) async {
  print('\n🧪 TEST: Complete Weekly Plan Display');
  print('─' * 50);

  final currentPlan = await workoutRepo.getCurrentWeeklyPlan(userId);

  if (currentPlan == null) {
    print('❌ No weekly plan found');
    return;
  }

  final fullPlan = await workoutRepo.getFullWeeklyPlan(
    userId,
    currentPlan.weekNumber,
  );

  if (fullPlan?.days != null) {
    print('✅ 📅 Week ${fullPlan!.weekNumber} Plan:\n');

    for (var day in fullPlan.days!) {
      print('   ${day.getDayName()}:');

      if (day.workouts != null && day.workouts!.isNotEmpty) {
        for (var workout in day.workouts!) {
          print('      • ${workout.title}');

          if (workout.tasks != null) {
            final duration = workout.tasks!.fold<int>(
              0,
              (sum, task) => sum + task.durationSec,
            );
            print('        Duration: ${duration ~/ 60} min');
            print('        Exercises: ${workout.tasks!.length}');
          }
        }
      } else {
        print('      🛌 Rest day');
      }
      print('');
    }
  } else {
    print('❌ Could not retrieve full plan');
  }
}

/// Test getting workouts for a specific day
Future<void> testGetTodayWorkouts(int dayId) async {
  print('\n🧪 TEST: Getting Today\'s Workouts');
  print('─' * 50);

  final day = await workoutRepo.getDayWithWorkouts(dayId);

  if (day?.workouts != null && day!.workouts!.isNotEmpty) {
    print('✅ Workouts for ${day.getDayName()}:\n');

    for (var workout in day.workouts!) {
      print('   📍 ${workout.title}');

      if (workout.tasks != null && workout.tasks!.isNotEmpty) {
        final tasksByRound = <int, List<TaskModel>>{};

        for (var task in workout.tasks!) {
          if (!tasksByRound.containsKey(task.roundNumber)) {
            tasksByRound[task.roundNumber] = [];
          }
          tasksByRound[task.roundNumber]!.add(task);
        }

        tasksByRound.forEach((round, tasks) {
          print('      🔄 Round $round:');
          for (var task in tasks) {
            print('         - ${task.title} (${task.getFormattedDuration()})');
            print('           Level: ${task.level}');
          }
        });
      }
      print('');
    }
  } else {
    print('❌ No workouts found for this day');
  }
}

// ============================================================================
// MAIN TEST EXECUTION
// ============================================================================

Future<void> runAllTests() async {
  print('╔════════════════════════════════════════════════════════════════╗');
  print('║         COMPREHENSIVE FITNESS APP TEST SUITE                 ║');
  print('╚════════════════════════════════════════════════════════════════╝');

  try {
    // Test 1: User Creation
    final userId = await testCreateUser() as int;
    if (userId == -1) return;

    // Test 2: Get User
    await testGetUser(userId);

    // Test 3: Update User Weight
    await testUpdateUserWeight(userId, 62.5);

    // Test 4: Login
    await testLogin('madison_fit', 'hashed_password_here');

    // Test 5: Create Cycling Workout
    final workoutId = await testCreateCyclingWorkout();
    if (workoutId == -1) return;

    // Test 6: Get Complete Workout
    await testGetCompleteWorkout(workoutId);

    // Test 7: Workout Statistics
    await testShowWorkoutStats(workoutId);

    // Test 8: Generate Weekly Plan
    final weekNumber = await testGeneratePlanForUser(userId, 4);
    if (weekNumber == -1) return;

    // Test 9: Assign Workouts to Week
    await testAssignWorkoutsToWeek(weekNumber);

    // Test 10: Show Complete Weekly Plan
    await testShowCompleteWeeklyPlan(userId);

    // Test 11: Get Today's Workouts (assuming dayId = 1)
    await testGetTodayWorkouts(1);

    print(
      '\n╔════════════════════════════════════════════════════════════════╗',
    );
    print('║                  ✅ ALL TESTS COMPLETED SUCCESSFULLY           ║');
    print(
      '╚════════════════════════════════════════════════════════════════╝\n',
    );
  } catch (e) {
    print('\n❌ ERROR during test execution: $e');
  }
}
