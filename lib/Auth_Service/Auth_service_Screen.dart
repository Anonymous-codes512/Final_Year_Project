import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register user without email verification
  // Register user with email verification
  Future<User?> registerUser(String name, String email, String password) async {
    try {
      // Create new user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      // Store user info in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'name': name,
        'email': email,
      });

      return userCredential.user;
    } catch (e) {
      print("Error registering user: $e");
      return null;
    }
  }

  // Login user with email verification check
  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user?.emailVerified == true) {
        return userCredential.user;
      } else {
        print("Email not verified.");
        return null;
      }
    } catch (e) {
      print("Error logging in: $e");
      return null;
    }
  }

  // Log out user
  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  // Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

}
