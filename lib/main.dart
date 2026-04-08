
import 'package:athlicare/presentation/pages/LoginSignInPages/LoginBlocDesign/LoginPageCubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlicare/logic/workout_cubit.dart';
import 'package:athlicare/logic/injury_cubit.dart';
import 'package:athlicare/logic/guidance_cubit.dart';
import 'package:athlicare/data/repositories/workout_repo.dart';
import 'package:athlicare/data/repositories/injury_repo.dart';
import 'package:athlicare/data/repositories/user_repo.dart';
import 'package:athlicare/data/helpers/dummy_data_helper.dart';
import 'package:athlicare/presentation/pages/LoginSignInPages/LoginPage.dart' hide LoginPage;
import 'package:athlicare/l10n/app_localizations.dart';
import 'package:provider/provider.dart'; // Add this to pubspec.yaml
import 'package:athlicare/services/local_provider.dart';
import 'package:athlicare/logic/localecubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();

    final userRepo = UserRepository();
    final workoutRepo = WorkoutRepository();
    final dummyDataHelper = DummyDataHelper(
      userRepository: userRepo,
      workoutRepository: workoutRepo,
    );
    await dummyDataHelper.initializeDummyData();

    runApp(
      ChangeNotifierProvider(
        create: (_) => LocaleProvider(),
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print('Initialization Error: $e');
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'Initialization Failed: Please check your Firebase setup and console logs. Error: $e',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(create: (context) => WorkoutCubit(WorkoutRepository())),
        BlocProvider(create: (context) => InjuryCubit(InjuryRepository())),
        BlocProvider(create: (context) => GuidanceCubit()..load()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            title: 'Athlicare',
            debugShowCheckedModeBanner: false,
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: const Color(0xFFFF6B35),
              scaffoldBackgroundColor: const Color(0xFF1A1A1A),
            ),
            home: LoginPage(),
          );
        },
      ),
    );
  }
}
