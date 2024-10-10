import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authservice {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailPassword(
      String username, String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Store the username in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
        });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception("Sign-up failed: ${e.message}");
    }
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception("Login failed: ${e.message}");
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception("Logout failed: $e");
    }
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  bool isSignedIn() {
    final user = _firebaseAuth.currentUser;
    return user != null;
  }

  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }
}
