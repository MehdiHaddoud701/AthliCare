// File: lib/presentation/pages/settings_screen.dart

import 'package:athlicare/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlicare/l10n/app_localizations.dart';
import 'package:athlicare/services/locale_service.dart';
import 'package:athlicare/logic/localecubit.dart'; // Add this import
import './password_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String currentLanguage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  /// Load current language from SharedPreferences
  Future<void> _loadCurrentLanguage() async {
    final locale = await LocaleService.getLocale();
    setState(() {
      currentLanguage = locale;
      _isLoading = false;
    });
  }

  /// Change language using LocaleCubit
  void _changeLanguage(String languageCode) {
    final newLocale = LocaleService.stringToLocale(languageCode);

    // Use the LocaleCubit to change locale
    context.read<LocaleCubit>().changeLocale(newLocale);

    setState(() {
      currentLanguage = languageCode;
    });

    // Show a snackbar to confirm the change
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Language changed to ${_getLanguageName(languageCode)}'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      case 'fr':
        return 'Français';
      default:
        return code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF111111),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.settings,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Password Settings Item
            _SettingItem(
              icon: Icons.vpn_key,
              text: l10n.passwordsetting,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PasswordSettingsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Language Selector
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Language Header
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: AppColors.secondry,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.language, color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        l10n.language,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Language Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // English Button
                      _LanguageButton(
                        label: 'English',
                        languageCode: 'en',
                        currentLanguage: currentLanguage,
                        onTap: () => _changeLanguage('en'),
                      ),

                      // Arabic Button
                      _LanguageButton(
                        label: 'العربية',
                        languageCode: 'ar',
                        currentLanguage: currentLanguage,
                        onTap: () => _changeLanguage('ar'),
                      ),

                      // French Button
                      _LanguageButton(
                        label: 'Français',
                        languageCode: 'fr',
                        currentLanguage: currentLanguage,
                        onTap: () => _changeLanguage('fr'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Delete Account Item
            _SettingItem(
              icon: Icons.person_off,
              text: l10n.delete,
              onTap: () {
                print('Delete account tapped');
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable Language Button Widget
class _LanguageButton extends StatelessWidget {
  final String label;
  final String languageCode;
  final String currentLanguage;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.label,
    required this.languageCode,
    required this.currentLanguage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentLanguage == languageCode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[700]!,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

/// Reusable Settings Item Widget
class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _SettingItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
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
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.yellow, size: 18),
          ],
        ),
      ),
    );
  }
}
