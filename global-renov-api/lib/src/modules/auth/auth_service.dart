import 'package:firebase_dart/firebase_dart.dart';
import 'package:global_renov_api/src/config/firebase_service.dart';

class AuthService {
  final FirebaseService _firebaseService = FirebaseService();

  // A function that creates a user with the provided email and password using Firebase authentication.
  //
  // Parameters:
  //   email: a String representing the user's email.
  //   password: a String representing the user's password.
  //
  // Returns:
  //   A Future<void> that represents the asynchronous operation of creating a user with the given email and password.
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password, String firstName, String lastName) async {
    try {
      final userCredential =
          await _firebaseService.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String name = '$firstName $lastName';

      await userCredential.user!.updateProfile(displayName: name);

      return userCredential;
    } catch (e) {
      throw Exception('AuthService: Error creating user. ${e.toString()}');
    }
  }

  // A function that signs in a user with the provided email and password.
  // Takes in two parameters: email (String) and password (String).
  // Returns a Future<void>.
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential =
          await _firebaseService.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } catch (e) {
      throw Exception('AuthService: Error signing in. ${e.toString()}');
    }
  }

  // Sign out the current user.
  Future<void> signOut() async {
    await _firebaseService.auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseService.auth.sendPasswordResetEmail(email: email);
  }
}
