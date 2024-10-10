import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new user to Firestore
  Future<void> addUser(User user) async {
    try {
      // Check if user ID is null. If so, throw an exception.
      if (user.id == null) {
        throw Exception('User ID cannot be null');
      }

      // Use the document ID as the user's id
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Error in adding user: $e');
    }
  }
  

  // Retrieve a user by their ID from Firestore
  Future<User?> getUserById(String id) async {
    try {
      final userDoc = await _firestore.collection('users').doc(id).get();
      if (userDoc.exists && userDoc.data() != null) {
        return User.fromMap(userDoc.data()!);
      }
    } catch (e) {
      throw Exception("Error in getting User: $e");
    }
    return null;
  }

  // Update an existing user in Firestore
  Future<void> updateUser(User user) async {
    try {
      // Check if user ID is null. If so, throw an exception.
      if (user.id == null) {
        throw Exception('User ID cannot be null');
      }

      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  // Delete a user from Firestore by their ID
  Future<void> deleteUser(String id) async {
    try {
      await _firestore.collection('users').doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  // Retrieve all users from Firestore
  Future<List<User>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();

      // Convert each document to a User object using fromMap
      return querySnapshot.docs.map((doc) {
        return User.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}
