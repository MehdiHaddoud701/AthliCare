import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/colors.dart';
import '../../logic/localecubit.dart';
import '../../l10n/app_localizations.dart';

// 🟩 Import your pages here (for navigation inside the widget)
import '../pages/home/home_page.dart';
import '../pages/workout/weekly.dart';
import '../pages/injuries/injuries_page_3.dart';
import 'package:athlicare/presentation/widgets/tipscard.dart';
import '../pages/profile/profile_screen.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int)? onItemTapped; // ✅ optional for backward compatibility

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    this.onItemTapped,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  void _onItemTapped(int index) {
    if (index == widget.selectedIndex) return; // prevent reloading same page

    // Navigate to selected page
    Widget page;
    switch (index) {
      case 0:
        page = const FitnessHomePage();
        break;
      case 1:
        page = const WeeklyWorkoutPage(userId: 1);
        break;
      case 2:
        page = const InjuryRecoveryPage(userId: 1);
        break;
      case 3:
        page = const tipspage();
        break;
      case 4:
        page = const ProfileScreen();
        break;
      default:
        page = const FitnessHomePage();
    }

    // 🟩 Use pushReplacement so the selected icon stays correct
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));

    // Call external callback if provided
    if (widget.onItemTapped != null) {
      widget.onItemTapped!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Wrap with BlocBuilder to rebuild when locale changes
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        final l10n = AppLocalizations.of(context)!;

        return BottomNavigationBar(
          backgroundColor: AppColors.primary,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          currentIndex: widget.selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: l10n.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.sports_gymnastics),
              label: l10n.workout,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.medical_services),
              label: l10n.injuries,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.tips_and_updates),
              label: l10n.tips,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: l10n.profile,
            ),
          ],
        );
      },
    );
  }
}
