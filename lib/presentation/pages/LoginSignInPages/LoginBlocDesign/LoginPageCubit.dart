import 'package:athlicare/presentation/pages/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_cubit.dart';
import 'auth_state.dart';
import 'package:athlicare/presentation/pages/ProfilePage/UserNameSelectionPage.dart';
import 'package:athlicare/presentation/pages/LoginSignInPages/SignUpPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showResetPasswordDialog(AuthCubit authCubit) {
    final resetEmailController = TextEditingController(text: _emailController.text.trim());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reset Password"),
          content: TextField(
            controller: resetEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Enter your email",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                authCubit.resetPassword(resetEmailController.text.trim());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Password reset link sent!"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }
  Future<bool> checkIfUserExists() async {
    // Get the currently logged-in Firebase user
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      print("No user is logged in.");
      return false;
    }

    final String email = user.email!; // Using email as the document ID
    final DocumentReference userRef =
    FirebaseFirestore.instance.collection('users').doc(email);

    final DocumentSnapshot docSnapshot = await userRef.get();

    if (docSnapshot.exists) {
      // User exists
      print("User already exists in Firestore.");
      return true;
    } else {
      // User does not exist (first-time login)
      print("User does NOT exist in Firestore.");
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => AuthCubit()..initPrefs(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is AuthSuccess) {
            //TODO:SUCESSFULL LOGIN NAVIGATE TO USERNAME SELECTION PAGE

            if(await checkIfUserExists()){

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => FitnessHomePage()),
              );

            }else{
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => UsernameSelectionPage()),
              );
            }



          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF0D0D0D),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: height * 0.05),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("Welcome Back",
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Log in to continue",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  SizedBox(height: height * 0.03),
                  Container(
                    width: width,
                    decoration: const BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: width * 0.08, vertical: height * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Email", style: TextStyle(color: Colors.white, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "example@example.com",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text("Password", style: TextStyle(color: Colors.white, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "************",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              return TextButton(
                                onPressed: () => _showResetPasswordDialog(context.read<AuthCubit>()),
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        Center(
                          child: BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              final isLoading = state is AuthLoading;
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white, width: 1.2),
                                  backgroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(horizontal: width * 0.25, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: isLoading
                                    ? null
                                    : () {
                                  context.read<AuthCubit>().loginWithEmail(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  );
                                },
                                child: isLoading
                                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                    : const Text("Log In", style: TextStyle(color: Colors.white, fontSize: 16)),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        const Center(
                          child: Text("or log in with",
                              style: TextStyle(color: Colors.white, fontSize: 14)),
                        ),
                        SizedBox(height: height * 0.015),
                        Center(
                          child: BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              final isLoading = state is AuthLoading;
                              return GestureDetector(
                                onTap: isLoading ? null : () => context.read<AuthCubit>().loginWithGoogle(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 22,
                                  child: isLoading
                                      ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                      : const Text(
                                    "G",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SignupPage()),
                              );
                            },
                            child: const Text(
                              "Don't have an account? Sign up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
