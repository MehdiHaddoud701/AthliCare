import 'package:athlicare/presentation/pages/LoginSignInPages/LoginBlocDesign/LoginPageCubit.dart';
import 'package:athlicare/presentation/pages/ProfilePage/AgeSelectionPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsernameSelectionPage extends StatefulWidget {
  const UsernameSelectionPage({super.key});

  @override
  State<UsernameSelectionPage> createState() => _UsernameSelectionPageState();
}

class _UsernameSelectionPageState extends State<UsernameSelectionPage> {
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Color bgColor = const Color(0xFF0D0D0D);
  final Color primaryColor = Colors.orange;
  final Color buttonColor = Colors.black;

  bool isValid = false;
  bool showError = false;
  bool triedSubmit = false;

  @override
  void initState() {
    super.initState();

    // Initialize isValid in case controller already has text
    isValid = _usernameController.text.trim().isNotEmpty;

    // Listen to changes and update validity
    _usernameController.addListener(() {
      if (!mounted) return;
      final currentlyValid = _usernameController.text.trim().isNotEmpty;

      // Only call setState when validity changed
      if (currentlyValid != isValid) {
        setState(() {
          isValid = currentlyValid;
          // hide error as soon as user types something valid
          if (isValid) {
            showError = false;
          }
        });
      } else {
        // if not valid and user typed (still empty), show error after trying to submit
        if (!isValid && triedSubmit && !showError) {
          setState(() => showError = true);
        }
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _onContinuePressed() async {
    // mark that user tried to submit (for showing validation)
    setState(() {
      triedSubmit = true;
    });

    // Validate the form (hides default validator error)
    if (_formKey.currentState?.validate() ?? false) {
      // Save username trimmed
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("username", _usernameController.text.trim());

      // Navigate to next page
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AgeSelectionPage()),
      );
    } else {
      // show custom error message
      setState(() {
        showError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
    child: LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // your content EXACTLY the same
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                      color: primaryColor,
                    ),
                    const Text(
                      "Back",
                      style: TextStyle(color: Colors.orange),
                    )
                  ],
                ),

                Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "What's your username?",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 40),

                    Form(
                      key: _formKey,
                      autovalidateMode: triedSubmit
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: TextFormField(
                        controller: _usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Username",
                          labelStyle: const TextStyle(color: Colors.orange),
                          filled: true,
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.orange),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                            const BorderSide(color: Colors.orange, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                        ),
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return ''; // Hide default error message
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _onContinuePressed(),
                      ),
                    ),

                    const SizedBox(height: 8),

                    if (showError)
                      const Text(
                        "Username cannot be empty",
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                  ],
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onContinuePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: primaryColor),
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    ),
    ),

    );
  }
}
