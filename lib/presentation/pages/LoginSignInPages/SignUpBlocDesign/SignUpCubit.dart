import 'package:athlicare/presentation/pages/LoginSignInPages/SignUpBlocDesign/SignUpState.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // EMAIL + PASSWORD SIGNUP
  Future<void> signupWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      emit(SignupFailure("Please fill in all fields"));
      return;
    }

    emit(SignupLoading());

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.updateDisplayName(name);

      emit(SignupSuccess());
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred";

      if (e.code == 'weak-password') {
        message = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        message = "The email already exists.";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email format.";
      }

      emit(SignupFailure(message));
    } catch (e) {
      emit(SignupFailure("Error: $e"));
    }
  }

  // GOOGLE SIGNUP
  Future<void> signupWithGoogle() async {
    emit(SignupLoading());

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      await googleSignIn.signOut();
      await _auth.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        emit(SignupFailure("Google sign-in cancelled"));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure("Google Sign-up Error: $e"));
    }
  }
}
