import 'package:athlicare/presentation/pages/LoginSignInPages/LoginBlocDesign/LoginPageCubit.dart';
import 'package:athlicare/presentation/pages/LoginSignInPages/SetupPage.dart';
import 'package:athlicare/presentation/pages/LoginSignInPages/SignUpBlocDesign/SignUpCubit.dart';
import 'package:athlicare/presentation/pages/LoginSignInPages/SignUpBlocDesign/SignUpState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(),
      child: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) async {
          if (state is SignupFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }

          if (state is SignupSuccess) {
            SharedPreferences preferences = await SharedPreferences.getInstance();
            preferences.setString("username", _nameController.text.trim());
            preferences.setString("email", _emailController.text.trim());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          }
        },
        child: _buildUI(context),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
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
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              const Text(
                "Create Account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign up to get started",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),

              SizedBox(height: height * 0.03),

              Container(
                width: width,
                decoration: const BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.08,
                  vertical: height * 0.04,
                ),
                child: BlocBuilder<SignupCubit, SignupState>(
                  builder: (context, state) {
                    final isLoading = state is SignupLoading;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Full Name",
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 8),

                        TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.black),
                          decoration: fieldDecoration("John Doe"),
                        ),
                        const SizedBox(height: 16),

                        const Text("Email",
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 8),

                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.black),
                          decoration: fieldDecoration("example@example.com"),
                        ),
                        const SizedBox(height: 16),

                        const Text("Password",
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 8),

                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.black),
                          decoration: fieldDecoration("************"),
                        ),

                        SizedBox(height: height * 0.03),

                        Center(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white, width: 1.2),
                              backgroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.25, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: isLoading
                                ? null
                                : () {
                              context.read<SignupCubit>().signupWithEmail(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                            },
                            child: isLoading
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                                : const Text("Sign Up",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ),
                        ),

                        SizedBox(height: height * 0.03),

                        const Center(
                          child: Text(
                            "or sign up with",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        SizedBox(height: height * 0.015),

                        Center(
                          child: GestureDetector(
                            onTap: isLoading
                                ? null
                                : () {
                              context
                                  .read<SignupCubit>()
                                  .signupWithGoogle();
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 22,
                              child: Text("G",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.03),

                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            },
                            child: const Text(
                              "Already have an account? Log in",
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration fieldDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }
}
