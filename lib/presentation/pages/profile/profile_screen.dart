import 'package:flutter/material.dart';
import 'package:athlicare/core/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:athlicare/l10n/app_localizations.dart';
import 'package:athlicare/presentation/pages/LoginSignInPages/LoginBlocDesign/LoginPageCubit.dart';

import '../../widgets/CustomBottomNavBar.dart';
import './settings_screen.dart';
import './edit-profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4; // 👣 Current tab = Profile
  SharedPreferences? preferences;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  void loadPreferences() async {
    preferences = await SharedPreferences.getInstance();
    if (mounted) setState(() {});
    print("Loaded preferences");
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),

      // 🔻 App Bar
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        automaticallyImplyLeading: false,
        title: Text(
          l10n.profile,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),

      // 📱 Body
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- Top Info Box ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _InfoItem(
                    title: l10n.weight,
                    value:
                    "${preferences?.getInt("weight")?.toString() ?? "70"} KG",
                  ),
                  _InfoItem(
                    title: l10n.age,
                    value:
                    "${preferences?.getInt("age")?.toString() ?? "25"}",
                  ),
                  _InfoItem(
                    title: l10n.height,
                    value:
                    "${preferences?.getInt("height")?.toString() ?? "170"} CM",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- Menu Options ---
            _ProfileItem(
              icon: Icons.person,
              text: l10n.profile,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserEditScreen()),
                ).then((_) {
                  // 🔄 Refresh when returning from Edit Profile
                  loadPreferences();
                });
              },
            ),

            const SizedBox(height: 20),

            _ProfileItem(
              icon: Icons.settings,
              text: l10n.settings,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),

            const SizedBox(height: 20),

            _ProfileItem(
              icon: Icons.logout,
              text: l10n.logout,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final localizations = AppLocalizations.of(context)!;
                    return AlertDialog(
                      backgroundColor: const Color(0xFF1A1A1A),
                      title: Text(
                        localizations.logout,
                        style: const TextStyle(color: AppColors.secondry),
                      ),
                      content: Text(
                        "Are you sure you want to log out?",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            localizations.cancel,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);

                            // Clear login state
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            await prefs.setBool("isLoggedIn", false);

                            if (mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginPage()),
                              );
                            }
                          },
                          child: Text(
                            localizations.logout,
                            style: const TextStyle(color: AppColors.secondry),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),

      // 🧭 Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() => _selectedIndex = index);

          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/workout');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/injuries');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/tips');
          } else if (index == 4) {
            // Already on profile
          }
        },
      ),
    );
  }
}

// --- Widgets ---
class _InfoItem extends StatelessWidget {
  final String title;
  final String value;
  const _InfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ProfileItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColors.secondry,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 20),
            Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.yellow, size: 18),
          ],
        ),
      ),
    );
  }
}
