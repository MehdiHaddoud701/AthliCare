import 'package:athlicare/core/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:athlicare/l10n/app_localizations.dart';

class PasswordSettingsScreen extends StatefulWidget {
  const PasswordSettingsScreen({super.key});

  @override
  State<PasswordSettingsScreen> createState() => _PasswordSettingsScreenState();
}

class _PasswordSettingsScreenState extends State<PasswordSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
  TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _isCurrentVisible = false;
  bool _isNewVisible = false;
  bool _isConfirmVisible = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'No authenticated user found.',
        );
      }

      // 🔐 Re-authenticate user with current password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPasswordController.text.trim(),
      );

      await user.reauthenticateWithCredential(credential);

      // 🔑 Update password
      await user.updatePassword(
        _newPasswordController.text.trim(),
      );

      // ✅ Success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password changed successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Optional: clear fields
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'wrong-password':
          message = 'Current password is incorrect';
          break;
        case 'weak-password':
          message = 'The new password is too weak';
          break;
        case 'requires-recent-login':
          message = 'Please log in again to change your password';
          break;
        default:
          message = e.message ?? 'Failed to change password';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  String? _validatePassword(String? value, {bool isConfirm = false}) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      return l10n.passwordEmpty;
    }
    if (!isConfirm) {
      if (value.length < 8) return l10n.passwordTooShort;
      if (!RegExp(r'[A-Z]').hasMatch(value)) return l10n.passwordNeedUppercase;
      if (!RegExp(r'[a-z]').hasMatch(value)) return l10n.passwordNeedLowercase;
      if (!RegExp(r'[0-9]').hasMatch(value)) return l10n.passwordNeedNumber;
      if (!RegExp(r'[!@#\$&*~_.,%^]').hasMatch(value)) {
        return l10n.passwordNeedSpecial;
      }
    } else {
      if (value != _newPasswordController.text) {
        return l10n.passwordsDoNotMatch;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.passwordSettings,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _PasswordField(
                label: l10n.currentPassword,
                controller: _currentPasswordController,
                obscureText: !_isCurrentVisible,
                onToggleVisibility: () =>
                    setState(() => _isCurrentVisible = !_isCurrentVisible),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.enterCurrentPassword;
                  }
                  return null;
                },
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.passwordResetSent),
                        backgroundColor: AppColors.boxColor,
                      ),
                    );
                  },
                  child: Text(
                    l10n.forgotPassword,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ),

              _PasswordField(
                label: l10n.newPassword,
                controller: _newPasswordController,
                obscureText: !_isNewVisible,
                onToggleVisibility: () =>
                    setState(() => _isNewVisible = !_isNewVisible),
                validator: (value) => _validatePassword(value),
              ),

              _PasswordField(
                label: l10n.confirmNewPassword,
                controller: _confirmPasswordController,
                obscureText: !_isConfirmVisible,
                onToggleVisibility: () =>
                    setState(() => _isConfirmVisible = !_isConfirmVisible),
                validator: (value) =>
                    _validatePassword(value, isConfirm: true),
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.boxColor,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: _submitForm,
                child: Text(
                  l10n.changePassword,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ====================== Password Field Widget ======================

class _PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final String? Function(String?)? validator;

  const _PasswordField({
    required this.label,
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              const TextStyle(color: AppColors.primary, fontSize: 14)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            validator: validator,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.purple,
                ),
                onPressed: onToggleVisibility,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
