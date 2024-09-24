import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user.dart';

class Userrepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(User user) async {
    try {
      // Check if a user with the same email exists
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('Email already exists');
      }

      // Add the user if email doesn't exist
      await _firestore.collection('users').add(user.toMap());
    } catch (e) {
      throw Exception('Error in adding user: $e');
    }
  }

  // The rest of the methods stay the same
  Future<User?> getUserById(String id) async {
    try {
      final user = await _firestore.collection('users').doc(id).get();
      if (user.exists) {
        return User(
          id: user.data()?['id'],
          username: user.data()?['username'],
          email: user.data()?['email'],
        );
      }
    } catch (e) {
      throw Exception("Error in getting User: $e");
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id.toString())
          .update(user.toMap());
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _firestore.collection('users').doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs.map((user) {
        return User(
            id: user.data()['id'],
            username: user.data()['username'],
            email: user.data()['email']);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}
