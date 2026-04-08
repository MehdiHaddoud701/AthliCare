// auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super( AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late SharedPreferences prefs;

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> loginWithEmail(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(const AuthError("Please enter both email and password"));
      return;
    }

    emit( AuthLoading());

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Save email in SharedPreferences
      await prefs.setString("email", email);

      emit(AuthSuccess(email));
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";
      if (e.code == 'user-not-found') message = "No user found for that email.";
      if (e.code == 'wrong-password') message = "Incorrect password.";
      if (e.code == 'invalid-email') message = "Invalid email format.";

      emit(AuthError(message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> loginWithGoogle() async {
    emit( AuthLoading());

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      await googleSignIn.signOut();
      await _auth.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        emit( AuthInitial());
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      // Save email
      await prefs.setString("email", googleUser.email);

      emit(AuthSuccess(googleUser.email));
    } on FirebaseAuthException catch (e) {
      String message = "Google Sign-in failed";
      if (e.code == 'account-exists-with-different-credential') {
        message = "This email is already registered with a different sign-in method.";
      }
      emit(AuthError(message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      emit(const AuthError("Please enter an email address"));
      return;
    }

    emit( AuthLoading());

    try {
      await _auth.sendPasswordResetEmail(email: email);
      emit( AuthInitial());
    } on FirebaseAuthException catch (e) {
      String message = "Password reset failed.";
      if (e.code == 'user-not-found') message = "No user found with this email.";
      if (e.code == 'invalid-email') message = "Invalid email format.";
      emit(AuthError(message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
