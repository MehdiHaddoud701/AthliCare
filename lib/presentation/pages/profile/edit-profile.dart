import 'package:athlicare/core/constants/colors.dart';
import 'package:athlicare/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserEditScreen extends StatefulWidget {
  const UserEditScreen({super.key});

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    prefs = await SharedPreferences.getInstance();

    _emailController.text = prefs?.getString("email") ?? "";
    _usernameController.text = prefs?.getString("username") ?? "";
    _ageController.text = (prefs?.getInt("age") ?? 0).toString();
    _heightController.text = (prefs?.getInt("height") ?? 0).toString();
    _weightController.text = (prefs?.getInt("weight") ?? 0).toString();

    setState(() {});
  }

  Future<void> _saveChanges() async {
    final l10n = AppLocalizations.of(context)!;

    await prefs?.setString("email", _emailController.text);
    await prefs?.setString("username", _usernameController.text);
    await prefs?.setInt("age", int.parse(_ageController.text));
    await prefs?.setInt("height", int.parse(_heightController.text));
    await prefs?.setInt("weight", int.parse(_weightController.text));

    await _loadUserData();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.profileUpdated),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (prefs == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
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
          l10n.editProfile,
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

              // USER STATS
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _UserStat(
                      title: l10n.weight,
                      value: "${prefs!.getInt("weight") ?? 0} kg",
                    ),
                    _UserStat(
                      title: l10n.age,
                      value: "${prefs!.getInt("age") ?? 0}",
                    ),
                    _UserStat(
                      title: l10n.height,
                      value: "${prefs!.getInt("height") ?? 0} cm",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // INPUTS
              _UserTextField(
                label: l10n.email,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) return l10n.emailRequired;
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return l10n.invalidEmail;
                  }
                  return null;
                },
              ),

              _UserTextField(
                label: l10n.userName,
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.usernameRequired;
                  }
                  return null;
                },
              ),

              _UserTextField(
                label: l10n.age,
                controller: _ageController,
                keyboardType: TextInputType.number,
              ),

              _UserTextField(
                label: "${l10n.height} (cm)",
                controller: _heightController,
                keyboardType: TextInputType.number,
              ),

              _UserTextField(
                label: "${l10n.weight} (kg)",
                controller: _weightController,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.boxColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) _saveChanges();
                },
                child: Text(
                  l10n.saveChanges,
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

// ==============================================================
// SUBWIDGETS
// ==============================================================

class _UserTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const _UserTextField({
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserStat extends StatelessWidget {
  final String title;
  final String value;
  const _UserStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        Text(title,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
